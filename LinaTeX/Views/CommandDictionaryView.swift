import SwiftUI

struct CommandDictionaryView: View {
    @ObservedObject var vm: AppViewModel
    @State private var searchText = ""
    @State private var selectedCategory: CommandDictionaryCategory = .all

    private var filteredEntries: [LinuxCommandEntry] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        return linuxCommandDictionary.filter { entry in
            let categoryMatches = selectedCategory == .all || entry.category == selectedCategory
            let queryMatches = query.isEmpty || entry.searchText.contains(query)
            return categoryMatches && queryMatches
        }
    }

    var body: some View {
        ShellScreen {
            VStack(spacing: 0) {
                ShellHeader(
                    title: "Linuxコマンド辞典",
                    subtitle: "\(filteredEntries.count)件 / 基本から実務まで",
                    trailing: "< BACK",
                    action: {
                        vm.goBack()
                    }
                )

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        DictionarySearchPanel(searchText: $searchText)

                        CategoryFilterBar(
                            selectedCategory: $selectedCategory,
                            categories: CommandDictionaryCategory.allCases
                        )

                        QuickReferencePanel()

                        ShellSectionTitle(title: "コマンド一覧")

                        if filteredEntries.isEmpty {
                            EmptyDictionaryResultView()
                        } else {
                            LazyVStack(spacing: 10) {
                                ForEach(filteredEntries) { entry in
                                    CommandDictionaryCard(entry: entry)
                                }
                            }
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 28)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

private struct DictionarySearchPanel: View {
    @Binding var searchText: String

    var body: some View {
        ShellPanel(borderOpacity: 0.24) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(TerminalTheme.bluePrimary)

                TextField("例: grep、権限、ファイルを探す", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .shellFont(.body)
                    .foregroundColor(TerminalTheme.textPrimary)

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(TerminalTheme.textTertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

private struct CategoryFilterBar: View {
    @Binding var selectedCategory: CommandDictionaryCategory
    let categories: [CommandDictionaryCategory]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories) { category in
                    Button {
                        withAnimation(.easeOut(duration: 0.16)) {
                            selectedCategory = category
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: category.icon)
                                .font(.system(size: 12, weight: .semibold))
                            Text(category.rawValue)
                                .shellFont(.caption2, weight: .bold)
                                .lineLimit(1)
                        }
                    }
                    .buttonStyle(ShellButtonStyle(kind: .outline, isSelected: selectedCategory == category))
                    .frame(width: category == .all ? 88 : 112)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

private struct QuickReferencePanel: View {
    private let references = [
        ("今いる場所を見る", "pwd から始める。次に ls で中身を見る。", "$ pwd\n$ ls -la"),
        ("ログから探す", "grep で必要な行だけ取り出す。件数は wc -l。", "$ grep ERROR app.log\n$ grep ERROR app.log | wc -l"),
        ("変更前に確認する", "削除、移動、権限変更の前に対象を確認する。", "$ ls -l deploy.sh\n$ chmod +x deploy.sh")
    ]

    var body: some View {
        ShellPanel(borderOpacity: 0.22) {
            VStack(alignment: .leading, spacing: 12) {
                ShellSectionTitle(title: "よく使う流れ")

                ForEach(references, id: \.0) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.0)
                            .shellFont(.subheadline, weight: .bold)
                            .foregroundColor(TerminalTheme.textPrimary)
                        Text(item.1)
                            .shellFont(.caption)
                            .foregroundColor(TerminalTheme.textSecondary)
                            .lineSpacing(3)
                        CodeBlock(code: item.2)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }
}

private struct CommandDictionaryCard: View {
    let entry: LinuxCommandEntry
    @State private var isExpanded = false

    var body: some View {
        ShellPanel(borderOpacity: isExpanded ? 0.34 : 0.2) {
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        Text(entry.command)
                            .font(.system(.headline, design: .monospaced).weight(.bold))
                            .foregroundColor(TerminalTheme.textOnAccent)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [TerminalTheme.bluePrimary, TerminalTheme.emeraldPrimary],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )

                        VStack(alignment: .leading, spacing: 5) {
                            Text(entry.title)
                                .shellFont(.headline, weight: .bold)
                                .foregroundColor(TerminalTheme.textPrimary)
                                .lineLimit(2)

                            Text(entry.summary)
                                .shellFont(.caption)
                                .foregroundColor(TerminalTheme.textSecondary)
                                .lineSpacing(3)
                                .lineLimit(isExpanded ? nil : 2)
                        }

                        Spacer(minLength: 8)

                        Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(TerminalTheme.emeraldPrimary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if isExpanded {
                    VStack(alignment: .leading, spacing: 12) {
                        DictionaryDetailBlock(title: "基本形", text: entry.syntax)
                        CodeBlock(code: entry.example)

                        DictionaryBulletBlock(title: "使いどころ", items: entry.uses)

                        if !entry.cautions.isEmpty {
                            DictionaryBulletBlock(title: "注意", items: entry.cautions)
                        }

                        if !entry.related.isEmpty {
                            RelatedCommandRow(commands: entry.related)
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
    }
}

private struct DictionaryDetailBlock: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .shellFont(.caption2, weight: .bold)
                .foregroundColor(TerminalTheme.bluePrimary)
            Text(text)
                .shellFont(.caption)
                .foregroundColor(TerminalTheme.textSecondary)
                .lineSpacing(3)
        }
    }
}

private struct DictionaryBulletBlock: View {
    let title: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .shellFont(.caption2, weight: .bold)
                .foregroundColor(TerminalTheme.bluePrimary)

            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(TerminalTheme.emeraldPrimary)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(item)
                        .shellFont(.caption)
                        .foregroundColor(TerminalTheme.textSecondary)
                        .lineSpacing(3)
                }
            }
        }
    }
}

private struct RelatedCommandRow: View {
    let commands: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("一緒に覚える")
                .shellFont(.caption2, weight: .bold)
                .foregroundColor(TerminalTheme.bluePrimary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 58), spacing: 6)], alignment: .leading, spacing: 6) {
                ForEach(commands, id: \.self) { command in
                    Text(command)
                        .font(.system(.caption2, design: .monospaced).weight(.bold))
                        .foregroundColor(TerminalTheme.greenTertiary)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: TerminalTheme.buttonRadius, style: .continuous)
                                .fill(TerminalTheme.emeraldSoft.opacity(0.7))
                        )
                }
            }
        }
    }
}

private struct EmptyDictionaryResultView: View {
    var body: some View {
        ShellPanel(borderOpacity: 0.18) {
            VStack(alignment: .leading, spacing: 8) {
                Text("該当するコマンドが見つかりません")
                    .shellFont(.headline, weight: .bold)
                    .foregroundColor(TerminalTheme.textPrimary)
                Text("短い単語やカテゴリで探してみてください。")
                    .shellFont(.caption)
                    .foregroundColor(TerminalTheme.textSecondary)
            }
        }
    }
}

enum CommandDictionaryCategory: String, CaseIterable, Identifiable {
    case all = "すべて"
    case basics = "基本"
    case files = "ファイル"
    case text = "検索と加工"
    case permissions = "権限"
    case process = "プロセス"
    case network = "通信"
    case packages = "管理"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .basics: return "terminal.fill"
        case .files: return "folder.fill"
        case .text: return "magnifyingglass"
        case .permissions: return "lock.fill"
        case .process: return "cpu"
        case .network: return "network"
        case .packages: return "shippingbox.fill"
        }
    }
}

struct LinuxCommandEntry: Identifiable {
    let command: String
    let title: String
    let category: CommandDictionaryCategory
    let summary: String
    let syntax: String
    let example: String
    let uses: [String]
    let cautions: [String]
    let related: [String]

    var id: String { command }

    var searchText: String {
        ([command, title, category.rawValue, summary, syntax, example] + uses + cautions + related)
            .joined(separator: " ")
            .lowercased()
    }
}

let linuxCommandDictionary: [LinuxCommandEntry] = [
    LinuxCommandEntry(
        command: "pwd",
        title: "いまいる場所を表示する",
        category: .basics,
        summary: "現在のディレクトリを絶対パスで確認します。迷ったら最初に使う安全確認コマンドです。",
        syntax: "pwd",
        example: "$ pwd\n/home/user/project",
        uses: ["作業場所を確認する", "相対パスで作業する前に現在地を確かめる"],
        cautions: [],
        related: ["ls", "cd"]
    ),
    LinuxCommandEntry(
        command: "ls",
        title: "ファイルやフォルダを一覧する",
        category: .basics,
        summary: "ディレクトリの中身を表示します。実務では ls -la で隠しファイルや権限まで見ることが多いです。",
        syntax: "ls [オプション] [場所]",
        example: "$ ls -la\n-rw-r--r--  app.log\n-rwxr-xr-x  deploy.sh",
        uses: ["ファイルの存在確認", "権限、所有者、更新日時の確認"],
        cautions: ["隠しファイルは -a を付けないと表示されません。"],
        related: ["pwd", "cd", "chmod"]
    ),
    LinuxCommandEntry(
        command: "cd",
        title: "作業場所を移動する",
        category: .basics,
        summary: "ディレクトリを移動します。コマンドは現在地を基準に動くため、cd はすべての作業の土台です。",
        syntax: "cd [移動先]",
        example: "$ cd /var/log\n$ cd ..\n$ cd ~",
        uses: ["プロジェクトフォルダへ移動する", "ホームや1つ上の階層へ戻る"],
        cautions: ["移動後は pwd や ls で場所を確認すると安全です。"],
        related: ["pwd", "ls"]
    ),
    LinuxCommandEntry(
        command: "mkdir",
        title: "フォルダを作る",
        category: .files,
        summary: "新しいディレクトリを作成します。-p を付けると途中の階層もまとめて作れます。",
        syntax: "mkdir [フォルダ名]",
        example: "$ mkdir reports\n$ mkdir -p logs/2026/04",
        uses: ["ログ保存先やバックアップ先を作る", "プロジェクト構成を整える"],
        cautions: ["権限がない場所では作成できません。"],
        related: ["ls", "rm"]
    ),
    LinuxCommandEntry(
        command: "touch",
        title: "空ファイルを作る",
        category: .files,
        summary: "空のファイルを作る、または既存ファイルの更新日時を変えます。中身は消しません。",
        syntax: "touch [ファイル名]",
        example: "$ touch README.md\n$ touch app.log",
        uses: ["設定ファイルの雛形を作る", "ログファイルを先に用意する"],
        cautions: ["既存ファイルに使っても中身は変更されません。"],
        related: ["cat", "echo", "ls"]
    ),
    LinuxCommandEntry(
        command: "cat",
        title: "ファイル内容を表示する",
        category: .files,
        summary: "短いファイルの内容を見るときに使います。パイプで次の grep や wc に渡す入口にもなります。",
        syntax: "cat [ファイル名]",
        example: "$ cat config.txt\n$ cat app.log | grep ERROR",
        uses: ["設定ファイルを確認する", "検索や集計の前段に使う"],
        cautions: ["巨大なログは less や tail の方が読みやすく安全です。"],
        related: ["less", "tail", "grep"]
    ),
    LinuxCommandEntry(
        command: "less",
        title: "長いファイルをページ単位で読む",
        category: .files,
        summary: "長いログや設定ファイルをスクロールしながら確認します。終了は q です。",
        syntax: "less [ファイル名]",
        example: "$ less /var/log/system.log",
        uses: ["長いログを読む", "ファイル内を検索しながら確認する"],
        cautions: ["表示中は対話モードです。q で終了します。"],
        related: ["cat", "tail", "grep"]
    ),
    LinuxCommandEntry(
        command: "tail",
        title: "ファイルの末尾を見る",
        category: .files,
        summary: "ログの最後の数行を表示します。-f を付けると追跡表示できます。",
        syntax: "tail [オプション] [ファイル名]",
        example: "$ tail -n 50 app.log\n$ tail -f app.log",
        uses: ["最新ログを確認する", "アプリ起動直後のエラーを見る"],
        cautions: ["tail -f は表示が続くので Ctrl+C で止めます。"],
        related: ["less", "grep", "head"]
    ),
    LinuxCommandEntry(
        command: "vim",
        title: "ターミナル上でファイルを編集する",
        category: .files,
        summary: "サーバー上で設定ファイルを編集するためのエディタです。最初は開く、入力、保存終了だけ覚えれば十分です。",
        syntax: "vim [ファイル名]",
        example: "$ vim config/app.env\n# i で入力、Esc、:wq で保存終了",
        uses: ["設定ファイルを直接編集する", "サーバー上で小さな修正を行う"],
        cautions: ["編集前に cp でバックアップを作ると安全です。保存せず終了は :q! です。"],
        related: ["cp", "cat", "grep"]
    ),
    LinuxCommandEntry(
        command: "cp",
        title: "コピーする",
        category: .files,
        summary: "ファイルやディレクトリを複製します。変更前のバックアップでよく使います。",
        syntax: "cp [元] [先]",
        example: "$ cp config.yml config.yml.bak\n$ cp -r src src_backup",
        uses: ["設定変更前にバックアップを作る", "テンプレートからファイルを作る"],
        cautions: ["ディレクトリのコピーには -r が必要です。上書きに注意。"],
        related: ["mv", "rm", "diff"]
    ),
    LinuxCommandEntry(
        command: "mv",
        title: "移動・名前変更する",
        category: .files,
        summary: "ファイルの移動とリネームを行います。コピーではないので元の場所からは消えます。",
        syntax: "mv [元] [先]",
        example: "$ mv draft.txt final.txt\n$ mv app.log archive/",
        uses: ["ファイル名を変える", "アーカイブ用フォルダへ移動する"],
        cautions: ["移動先に同名ファイルがあると上書きされる場合があります。"],
        related: ["cp", "rm", "ls"]
    ),
    LinuxCommandEntry(
        command: "rm",
        title: "削除する",
        category: .files,
        summary: "ファイルを削除します。Linuxでは基本的にゴミ箱へ入らず、即削除です。",
        syntax: "rm [ファイル名]",
        example: "$ rm old.log\n$ rm -r old_directory",
        uses: ["不要ファイルを削除する", "古い一時ファイルを片付ける"],
        cautions: ["rm -rf は強力です。実行前に ls で対象を確認してください。"],
        related: ["ls", "cp", "mv"]
    ),
    LinuxCommandEntry(
        command: "grep",
        title: "文字列を検索する",
        category: .text,
        summary: "テキストから条件に合う行を探します。ログ解析、設定確認、ソース検索で頻出です。",
        syntax: "grep [オプション] [検索語] [ファイル]",
        example: "$ grep ERROR app.log\n$ grep -rin \"timeout\" ./logs",
        uses: ["エラー行を探す", "複数ファイルからキーワードを探す"],
        cautions: ["大文字小文字を無視したいときは -i、行番号は -n。"],
        related: ["cat", "wc", "find"]
    ),
    LinuxCommandEntry(
        command: "find",
        title: "ファイルを条件で探す",
        category: .text,
        summary: "名前、種類、サイズ、更新日時などでファイルを検索します。",
        syntax: "find [場所] [条件]",
        example: "$ find . -name \"*.log\"\n$ find /var/log -size +100M",
        uses: ["大きなファイルを探す", "特定拡張子のファイルをまとめて探す"],
        cautions: ["検索範囲が広いと時間がかかります。まず小さい範囲で試しましょう。"],
        related: ["grep", "ls", "du"]
    ),
    LinuxCommandEntry(
        command: "sed",
        title: "テキストを置換・加工する",
        category: .text,
        summary: "行単位でテキストを加工します。置換や抽出をパイプライン内で処理できます。",
        syntax: "sed 's/古い文字/新しい文字/g' [ファイル]",
        example: "$ sed 's/error/ERROR/g' app.log",
        uses: ["文字列を置換する", "ログや設定の一部を加工する"],
        cautions: ["ファイルを直接書き換える -i はバックアップを取ってから使うと安全です。"],
        related: ["grep", "awk", "cat"]
    ),
    LinuxCommandEntry(
        command: "awk",
        title: "列を取り出して加工する",
        category: .text,
        summary: "スペースや区切り文字で分かれた列を扱うのが得意です。ログ集計で力を発揮します。",
        syntax: "awk '{print $1}' [ファイル]",
        example: "$ awk '{print $1}' access.log\n$ ps aux | awk '{print $2, $11}'",
        uses: ["ログの特定列を取り出す", "プロセス一覧から必要な列だけ見る"],
        cautions: ["$1 は1列目、$2 は2列目です。シェル変数とは意味が違います。"],
        related: ["grep", "sort", "uniq"]
    ),
    LinuxCommandEntry(
        command: "sort",
        title: "並び替える",
        category: .text,
        summary: "行を並び替えます。uniq と組み合わせて件数集計によく使います。",
        syntax: "sort [ファイル]",
        example: "$ sort names.txt\n$ grep ERROR app.log | sort",
        uses: ["ログや一覧を並べる", "集計前に同じ値をまとめる"],
        cautions: ["数値として並べるときは -n、逆順は -r。"],
        related: ["uniq", "grep", "wc"]
    ),
    LinuxCommandEntry(
        command: "uniq",
        title: "重複行をまとめる",
        category: .text,
        summary: "連続した重複行をまとめます。sort とセットで使うのが基本です。",
        syntax: "sort [ファイル] | uniq -c",
        example: "$ sort access.log | uniq -c",
        uses: ["種類ごとの件数を数える", "重複した一覧を整理する"],
        cautions: ["隣り合った重複だけを処理するため、先に sort することが多いです。"],
        related: ["sort", "wc", "awk"]
    ),
    LinuxCommandEntry(
        command: "wc",
        title: "行数や単語数を数える",
        category: .text,
        summary: "行数、単語数、バイト数を数えます。grep と組み合わせると件数確認が速いです。",
        syntax: "wc [オプション] [ファイル]",
        example: "$ wc -l app.log\n$ grep ERROR app.log | wc -l",
        uses: ["ログ件数を数える", "検索結果の行数を確認する"],
        cautions: ["行数は -l、単語数は -w、バイト数は -c。"],
        related: ["grep", "sort", "uniq"]
    ),
    LinuxCommandEntry(
        command: "chmod",
        title: "権限を変更する",
        category: .permissions,
        summary: "読み取り、書き込み、実行の権限を変更します。スクリプト実行前によく使います。",
        syntax: "chmod [権限] [ファイル]",
        example: "$ chmod +x deploy.sh\n$ chmod 644 config.yml",
        uses: ["スクリプトに実行権限を付ける", "公開してよい範囲を調整する"],
        cautions: ["777 は誰でも読み書き実行できるため、基本的には避けます。"],
        related: ["ls", "chown", "umask"]
    ),
    LinuxCommandEntry(
        command: "chown",
        title: "所有者を変更する",
        category: .permissions,
        summary: "ファイルやディレクトリの所有者、グループを変更します。",
        syntax: "chown [ユーザー]:[グループ] [対象]",
        example: "$ sudo chown app:app deploy.sh\n$ sudo chown -R www-data:www-data public/",
        uses: ["Webサーバー用の所有者にする", "デプロイユーザーへ権限を合わせる"],
        cautions: ["-R は配下すべてに効きます。対象パスを必ず確認してください。"],
        related: ["chmod", "ls", "sudo"]
    ),
    LinuxCommandEntry(
        command: "sudo",
        title: "管理者権限で実行する",
        category: .permissions,
        summary: "一時的に管理者権限でコマンドを実行します。システム変更時に使います。",
        syntax: "sudo [コマンド]",
        example: "$ sudo apt update\n$ sudo systemctl restart nginx",
        uses: ["パッケージ更新", "サービス再起動や権限変更"],
        cautions: ["強い権限で動くため、コマンドと対象を確認してから実行します。"],
        related: ["apt", "chown", "chmod"]
    ),
    LinuxCommandEntry(
        command: "ps",
        title: "プロセス一覧を見る",
        category: .process,
        summary: "実行中のプロセスを確認します。止めたい処理のPIDを探す入口です。",
        syntax: "ps [オプション]",
        example: "$ ps aux | grep backup.sh",
        uses: ["実行中の処理を探す", "PIDを確認する"],
        cautions: ["grep 自身が検索結果に出ることがあります。"],
        related: ["top", "kill", "grep"]
    ),
    LinuxCommandEntry(
        command: "top",
        title: "負荷をリアルタイムに見る",
        category: .process,
        summary: "CPU、メモリ、プロセスをリアルタイムで監視します。終了は q です。",
        syntax: "top",
        example: "$ top",
        uses: ["CPUやメモリが重い原因を探す", "サーバーの負荷を見る"],
        cautions: ["対話モードです。q で終了します。"],
        related: ["ps", "kill"]
    ),
    LinuxCommandEntry(
        command: "kill",
        title: "プロセスを終了する",
        category: .process,
        summary: "PIDを指定してプロセスへ終了シグナルを送ります。",
        syntax: "kill [PID]",
        example: "$ kill 1234\n$ kill -9 1234",
        uses: ["止まらない処理を終了する", "バックグラウンド処理を止める"],
        cautions: ["まず通常の kill を使い、kill -9 は最後の手段にします。"],
        related: ["ps", "top"]
    ),
    LinuxCommandEntry(
        command: "systemctl",
        title: "サービスを操作する",
        category: .process,
        summary: "Linuxのサービスを起動、停止、再起動、状態確認します。Webサーバーや常駐アプリの管理で使います。",
        syntax: "sudo systemctl [操作] [サービス名]",
        example: "$ sudo systemctl status nginx\n$ sudo systemctl restart linatex",
        uses: ["サービスの状態を確認する", "設定変更後にサービスを再起動する"],
        cautions: ["本番環境で restart する前に、影響範囲と設定バックアップを確認します。"],
        related: ["sudo", "ps", "curl"]
    ),
    LinuxCommandEntry(
        command: "curl",
        title: "URLへリクエストする",
        category: .network,
        summary: "APIやWebサーバーにリクエストを送り、レスポンスを確認します。",
        syntax: "curl [オプション] [URL]",
        example: "$ curl -I https://example.com\n$ curl -s https://api.example.com/health",
        uses: ["API疎通確認", "HTTPステータスやヘッダーを見る"],
        cautions: ["JSONを見るときは jq と組み合わせると読みやすいです。"],
        related: ["jq", "wget", "ssh"]
    ),
    LinuxCommandEntry(
        command: "ssh",
        title: "リモートサーバーへ接続する",
        category: .network,
        summary: "安全にリモートサーバーへログインします。本番サーバー作業で必須です。",
        syntax: "ssh [ユーザー]@[ホスト]",
        example: "$ ssh user@example.com\n$ ssh -i key.pem ubuntu@server",
        uses: ["サーバーへ接続する", "鍵を使ってログインする"],
        cautions: ["秘密鍵は安全に保管し、権限を緩くしすぎないようにします。"],
        related: ["scp", "curl"]
    ),
    LinuxCommandEntry(
        command: "scp",
        title: "SSH経由でファイル転送する",
        category: .network,
        summary: "ローカルとリモート間でファイルをコピーします。",
        syntax: "scp [元] [先]",
        example: "$ scp app.log user@example.com:/tmp/\n$ scp user@example.com:/tmp/app.log .",
        uses: ["サーバーからログを取ってくる", "設定ファイルをアップロードする"],
        cautions: ["転送先パスを間違えると意図しない場所へコピーします。"],
        related: ["ssh", "cp"]
    ),
    LinuxCommandEntry(
        command: "jq",
        title: "JSONを読みやすく扱う",
        category: .network,
        summary: "JSONを整形、抽出、加工します。APIレスポンス確認で非常に便利です。",
        syntax: "jq '[フィルタ]'",
        example: "$ curl -s https://api.example.com/users | jq '.data[0].name'",
        uses: ["APIレスポンスを整形する", "必要なキーだけ取り出す"],
        cautions: ["jq '.' だけでも整形表示になります。"],
        related: ["curl", "grep"]
    ),
    LinuxCommandEntry(
        command: "tar",
        title: "まとめてアーカイブする",
        category: .files,
        summary: "複数ファイルを1つにまとめたり、展開したりします。バックアップでよく使います。",
        syntax: "tar [オプション] [アーカイブ] [対象]",
        example: "$ tar -czf backup.tar.gz project/\n$ tar -xzf backup.tar.gz",
        uses: ["ディレクトリをまとめてバックアップする", "配布されたアーカイブを展開する"],
        cautions: ["展開先に同名ファイルがあると上書きされる場合があります。"],
        related: ["gzip", "cp", "ls"]
    ),
    LinuxCommandEntry(
        command: "df",
        title: "ディスクの空き容量を見る",
        category: .packages,
        summary: "ファイルシステム全体の使用量と空き容量を確認します。容量不足の一次調査で最初に使います。",
        syntax: "df [オプション]",
        example: "$ df -h\nFilesystem  Size  Used Avail Use%",
        uses: ["サーバー全体の容量不足を確認する", "どの領域が逼迫しているか見る"],
        cautions: ["-h を付けると GB/MB 表示になり読みやすくなります。"],
        related: ["du", "rm", "tar"]
    ),
    LinuxCommandEntry(
        command: "du",
        title: "フォルダやファイルの使用量を見る",
        category: .packages,
        summary: "指定したファイルやディレクトリがどれくらい容量を使っているか確認します。",
        syntax: "du [オプション] [対象]",
        example: "$ du -sh logs\n$ du -h /var/log | sort -h",
        uses: ["大きいディレクトリを探す", "ログ肥大化の原因を調べる"],
        cautions: ["対象が大きいと時間がかかります。まず範囲を絞って確認しましょう。"],
        related: ["df", "find", "sort"]
    ),
    LinuxCommandEntry(
        command: "apt",
        title: "Ubuntu系のパッケージ管理",
        category: .packages,
        summary: "Debian/Ubuntu系でソフトウェアをインストール、更新、削除します。",
        syntax: "sudo apt [操作] [パッケージ名]",
        example: "$ sudo apt update\n$ sudo apt install nginx\n$ sudo apt upgrade",
        uses: ["ソフトをインストールする", "パッケージ一覧や更新を管理する"],
        cautions: ["apt update は一覧更新、apt upgrade はインストール済みの更新です。"],
        related: ["sudo", "dpkg"]
    ),
    LinuxCommandEntry(
        command: "man",
        title: "マニュアルを読む",
        category: .basics,
        summary: "コマンドの公式マニュアルを表示します。オプションの意味を深く確認できます。",
        syntax: "man [コマンド名]",
        example: "$ man grep\n$ man chmod",
        uses: ["オプションの意味を調べる", "コマンドの詳しい仕様を確認する"],
        cautions: ["表示中は q で終了、/ で検索できます。"],
        related: ["--help", "less"]
    )
]

#Preview {
    CommandDictionaryView(vm: AppViewModel())
}
