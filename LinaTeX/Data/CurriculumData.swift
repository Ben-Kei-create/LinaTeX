import SwiftUI

// MARK: - Consolidated Curriculum
// Single source of truth for all course content
// Combines previously fragmented curriculum from multiple files

// MARK: - Basics Course
let basicsCourseLessons: [Lesson] = [
    // cp - Copy Files
    Lesson(
        title: "cp - ファイルをコピー",
        emoji: "📋",
        estimatedMinutes: 8,
        content: .concept(ConceptLesson(
            headline: "ファイルを複製する",
            sections: [
                ConceptSection(
                    heading: "cp コマンドの役割",
                    body: "cp（Copy）は、既存のファイルを複製して、別の名前または別の場所に保存します。\n\n元のファイルは変わらず、新しいコピーが作成されます。バックアップを作成するとき、または複数の用途に分けるときに使用します。",
                    codeSample: "cp original.txt backup.txt\n# 元のファイルは変わらず、backup.txt が新しく作成される",
                    tip: "ディレクトリ全体をコピーする場合は cp -r を使用します"
                ),
                ConceptSection(
                    heading: "cp の使い方と注意点",
                    body: "• cp ファイル名 新しい名前: シンプルなコピー\n• cp ファイル ディレクトリ/: ディレクトリ内にコピー\n• cp -r ディレクトリ ディレクトリ: ディレクトリ全体をコピー（-r は recursive）\n\n⚠️ 既存ファイルと同じ名前でコピーすると上書きされます。cp -i でコマンド実行前に確認できます。",
                    codeSample: nil,
                    tip: nil
                )
            ]
        ))
    ),
    Lesson(
        title: "cp - ファイル複製クエスト",
        emoji: "🎯",
        estimatedMinutes: 6,
        content: .quest(QuestLesson(
            scenario: "プロジェクトの重要な設定ファイルをバックアップする必要があります。",
            prompt: "config.txt をバックアップ用に config_backup.txt として同じディレクトリにコピーするコマンドは？",
            hint: "cp config.txt config_backup.txt でコピーできます。",
            answer: "cp",
            options: [
                CommandOption(label: "cp", command: "cp", icon: "doc.on.doc"),
                CommandOption(label: "mv", command: "mv", icon: "arrow.right"),
                CommandOption(label: "cat", command: "cat", icon: "doc.text"),
            ],
            simulatedOutput: "user@linux:~/project$ cp config.txt config_backup.txt\nuser@linux:~/project$ ls\nconfig.txt  config_backup.txt",
            successMessage: "✅ ファイルが正常にコピーされました"
        ))
    ),
    // mv - Move/Rename Files
    Lesson(
        title: "mv - ファイルを移動・リネーム",
        emoji: "🚀",
        estimatedMinutes: 8,
        content: .concept(ConceptLesson(
            headline: "ファイルを移動する・名前を変える",
            sections: [
                ConceptSection(
                    heading: "mv コマンドの役割",
                    body: "mv（Move）は、ファイルを別の場所に移動したり、ファイルの名前を変えたりするコマンドです。\n\n重要な特徴: cp と異なり、元のファイルは残りません。ファイルは移動されます。同じディレクトリ内で使用すると、単なる「リネーム」になります。",
                    codeSample: "mv old_name.txt new_name.txt\n# 同じディレクトリ内では名前変更\nmv file.txt archive/\n# ディレクトリを指定すると移動",
                    tip: "cp コマンドとの最大の違いは、元のファイルが「置き換わる」点です"
                ),
                ConceptSection(
                    heading: "mv の使用シーン",
                    body: "• mv old_name.txt new_name.txt: ファイルをリネーム\n• mv file.txt directory/: ファイルを別のディレクトリに移動\n• mv directory/* archive/: ディレクトリ内の複数ファイルを移動\n• mv old_dir new_dir: ディレクトリ全体をリネーム・移動",
                    codeSample: nil,
                    tip: nil
                )
            ]
        ))
    ),
    Lesson(
        title: "mv - ファイル移動クエスト",
        emoji: "🎯",
        estimatedMinutes: 6,
        content: .quest(QuestLesson(
            scenario: "プロジェクトの一時ログファイル temp.log を、archive フォルダに移動して整理する必要があります。",
            prompt: "temp.log ファイルを archive/ ディレクトリに移動するコマンドは？",
            hint: "mv temp.log archive/ で移動できます。スラッシュでディレクトリを指定します。",
            answer: "mv",
            options: [
                CommandOption(label: "mv", command: "mv", icon: "arrow.right"),
                CommandOption(label: "cp", command: "cp", icon: "doc.on.doc"),
                CommandOption(label: "rm", command: "rm", icon: "trash"),
            ],
            simulatedOutput: "user@linux:~/project$ mv temp.log archive/\nuser@linux:~/project$ ls archive/\ntemp.log",
            successMessage: "✅ ファイルが archive/ に移動されました"
        ))
    ),
    // rm - Remove Files
    Lesson(
        title: "rm - ファイルを削除",
        emoji: "🗑️",
        estimatedMinutes: 8,
        content: .concept(ConceptLesson(
            headline: "不要なファイルを消す",
            sections: [
                ConceptSection(
                    heading: "rm コマンドの役割",
                    body: "rm（Remove）は、ファイルを削除するコマンドです。\n\n⚠️ 非常に強力なコマンドです。削除したファイルはゴミ箱に行かず、完全に消えます。そのため、削除前に必ず確認することが重要です。実務では -i オプション（確認を求める）をよく使用します。",
                    codeSample: "rm old_file.txt\n# ファイルは完全に削除される\nrm -i file.txt\n# 確認を求めてから削除",
                    tip: "削除する前に ls で対象ファイルを確認する習慣をつけましょう"
                ),
                ConceptSection(
                    heading: "rm の注意点と使い分け",
                    body: "• rm ファイル: ファイル削除（復旧不可）\n• rm -i ファイル: 確認してから削除\n• rm -r ディレクトリ: ディレクトリ全体を削除\n• rm -f: 強制削除（確認なし）- 危険！\n\n一度削除するとバックアップがない限り復旧できません。重要なファイルは必ず cp でバックアップしてから削除しましょう。",
                    codeSample: nil,
                    tip: nil
                )
            ]
        ))
    ),
    Lesson(
        title: "rm - ファイル削除クエスト",
        emoji: "🎯",
        estimatedMinutes: 6,
        content: .quest(QuestLesson(
            scenario: "古いログファイルが溜まっているので、不要な old_run.log を削除する必要があります。",
            prompt: "old_run.log ファイルを削除するコマンドは？",
            hint: "rm old_run.log で削除できます。実務では rm -i で確認しながら削除することをお勧めします。",
            answer: "rm",
            options: [
                CommandOption(label: "rm", command: "rm", icon: "trash"),
                CommandOption(label: "mv", command: "mv", icon: "arrow.right"),
                CommandOption(label: "rmdir", command: "rmdir", icon: "trash.fill"),
            ],
            simulatedOutput: "user@linux:~/project$ rm old_run.log\nuser@linux:~/project$",
            successMessage: "✅ ファイルが削除されました（復旧不可）"
        ))
    ),
    // Combined scenario lesson
    Lesson(
        title: "ファイル操作の複合シナリオ",
        emoji: "📋",
        estimatedMinutes: 15,
        content: .scenario(ScenarioLesson(
            setup: "プロジェクトの複数ファイルを整理し、バックアップを作成します。",
            goal: "cp と mv を組み合わせてファイルを管理する",
            steps: [
                ScenarioStep(
                    prompt: "重要なファイル config.txt をバックアップします（config_backup.txt に）",
                    hint: "cp config.txt config_backup.txt",
                    answer: "cp",
                    options: [
                        CommandOption(label: "cp", command: "cp", icon: "doc.on.doc"),
                        CommandOption(label: "mv", command: "mv", icon: "arrow.right"),
                        CommandOption(label: "mkdir", command: "mkdir", icon: "folder"),
                    ],
                    simulatedOutput: "user@linux:~/project$ cp config.txt config_backup.txt\nuser@linux:~/project$"
                ),
                ScenarioStep(
                    prompt: "temp.log ファイルを archive フォルダに移動します。",
                    hint: "mv temp.log archive/",
                    answer: "mv",
                    options: [
                        CommandOption(label: "mv", command: "mv", icon: "arrow.right"),
                        CommandOption(label: "cp", command: "cp", icon: "doc.on.doc"),
                        CommandOption(label: "rm", command: "rm", icon: "trash"),
                    ],
                    simulatedOutput: "user@linux:~/project$ mv temp.log archive/\nuser@linux:~/project$"
                ),
                ScenarioStep(
                    prompt: "古いログファイル old_run.log を削除します。",
                    hint: "rm old_run.log",
                    answer: "rm",
                    options: [
                        CommandOption(label: "rm", command: "rm", icon: "trash"),
                        CommandOption(label: "mv", command: "mv", icon: "arrow.right"),
                        CommandOption(label: "rmdir", command: "rmdir", icon: "trash.fill"),
                    ],
                    simulatedOutput: "user@linux:~/project$ rm old_run.log\nuser@linux:~/project$"
                ),
            ],
            finaleMessage: "✅ プロジェクトファイルの整理完了！"
        ))
    ),
    // Basics quiz (Chapter 3)
    Lesson(
        title: "ファイル操作の深掘りテスト",
        emoji: "✅",
        estimatedMinutes: 12,
        content: .quiz(QuizLesson(
            questions: [
                QuizQuestion(
                    question: "cp -r src/ dst/ を実行した。src ディレクトリが存在して dst が存在しない場合、結果は？",
                    choices: [
                        "dst/ という名前のディレクトリが新規作成され、src の内容がコピーされる",
                        "エラーになる（dst がないため）",
                        "src が dst にリネームされる",
                        "src の内容が /tmp/dst に保存される"
                    ],
                    correctIndex: 0,
                    explanation: "cp -r は宛先が存在しない場合、宛先ディレクトリを新規作成してコピーします。一方、dst/ が既に存在する場合は dst/src/ というサブディレクトリが作られます。この挙動の違いは実務でよく混乱の原因になります。"
                ),
                QuizQuestion(
                    question: "mv a.txt b.txt を実行したとき、b.txt が既に存在していた場合どうなる？",
                    choices: [
                        "確認なしで b.txt は上書きされ、a.txt は削除される",
                        "エラーになりどちらも変わらない",
                        "a.txt と b.txt が両方残る",
                        "a.txt_bak という名前で保存される"
                    ],
                    correctIndex: 0,
                    explanation: "mv はデフォルトで確認なく上書きします。既存ファイルを誤って消す事故を防ぐには mv -i（interactive）オプションを使います。-i を付けると上書き前に確認を求めます。cp も同様です。"
                ),
                QuizQuestion(
                    question: "rm -rf / を実行しようとしたところ「Operation not permitted」となった。この保護機能の名前は？",
                    choices: [
                        "--preserve-root（ルートディレクトリへの再帰削除を防ぐデフォルト保護）",
                        "SELinux のポリシー",
                        "ファイルのイミュータブルフラグ",
                        "sudo が必要なため"
                    ],
                    correctIndex: 0,
                    explanation: "GNU coreutils の rm にはデフォルトで --preserve-root オプションが有効で、/ を rm -r の対象にすることを防ぎます。--no-preserve-root で無効にできますが、実行すると取り返しがつかないため絶対に行わないでください。"
                ),
                QuizQuestion(
                    question: "cp コマンドでファイルのタイムスタンプ・権限・オーナー情報も含めてコピーするオプションは？",
                    choices: [
                        "cp -p（preserve: 属性を保持）",
                        "cp -a（archive、-p -r -d の組み合わせ）",
                        "どちらも正しい（-p は単体属性保持、-a はより完全なバックアップ用）",
                        "cp -x"
                    ],
                    correctIndex: 2,
                    explanation: "cp -p はタイムスタンプ・モード・オーナーを保持します。cp -a はさらにシンボリックリンクも保持する「アーカイブモード」で、バックアップ目的では -a が完全です。両方正しいですが目的によって使い分けます。"
                ),
                QuizQuestion(
                    question: "rm でファイルを削除した後、同じ容量のファイルで回復を試みたが失敗した。なぜか？",
                    choices: [
                        "rm は inode とデータブロックへの参照を削除するため、データは残っていても通常手段では復旧不可",
                        "rm はファイルを暗号化して削除するため",
                        "削除後は即座にディスクから消去されるため",
                        "ゴミ箱に移動されるが容量が足りないため"
                    ],
                    correctIndex: 0,
                    explanation: "rm はディレクトリエントリ（ファイル名→inode のマッピング）と inode を削除しますが、データブロック自体は即座には消えません。ただし他のファイルで上書きされる前なら forensics ツール（testdisk, extundelete）で復旧できる場合があります。重要ファイルはバックアップが必須です。"
                ),
            ]
        ))
    ),
]

let basicsCourse = Course(
    level: .basics,
    title: "Linuxの基本",
    subtitle: "ターミナルの世界へようこそ",
    description: "Linuxの基礎から始めます。ターミナル操作、ファイルシステム、基本コマンドを習得します。",
    emoji: "🐧",
    estimatedMinutes: 90,
    chapters: [
        Chapter(
            number: 1,
            title: "Linuxの世界へようこそ",
            summary: "カーネル・ディストリビューション・シェルの仕組みを理解し、コマンド実行の本質を掴む",
            lessons: [
                // ─── 学習 1 ──────────────────────────────────────────────
                Lesson(
                    title: "カーネル・ディストリビューション・GNU",
                    emoji: "🐧",
                    estimatedMinutes: 8,
                    content: .concept(ConceptLesson(
                        headline: "「Linux」は厳密にはカーネルの名前",
                        sections: [
                            ConceptSection(
                                heading: "Linux カーネルとは",
                                body: "Linux（厳密には「Linuxカーネル」）は、ハードウェアとソフトウェアを仲介する OS の中核部品です。CPU・メモリ・ストレージ・ネットワークデバイスを直接制御し、プロセス管理・メモリ管理・ファイルシステムなどを担当します。\n\nLinus Torvalds が 1991 年に発表し、現在は世界規模のコミュニティで開発が続いています。",
                                codeSample: "uname -r\n# カーネルバージョンを確認: 5.15.0-91-generic",
                                tip: "「Linux を使う」というとき、実際には Linux カーネル + GNU ツール群 + パッケージ管理ツールなどがセットになった「ディストリビューション」を使っています"
                            ),
                            ConceptSection(
                                heading: "ディストリビューションとは",
                                body: "カーネルだけではコンピュータは操作できません。コマンドラインツール・パッケージ管理・デフォルト設定などをまとめてパッケージ化したものが「ディストリビューション（ディストロ）」です。\n\n主要なディストリビューション：\n• Ubuntu / Debian 系: apt でパッケージ管理。開発用途や企業サーバーで広く利用。\n• Red Hat Enterprise Linux (RHEL) / CentOS 系: yum/dnf でパッケージ管理。エンタープライズ本番環境で採用多数。\n• Fedora: RHEL の実験場。最新技術をいち早く試せる。\n• Arch Linux: 最小構成から自分でカスタマイズ。学習目的に人気。\n\n本番サーバーでは RHEL/Ubuntu が圧倒的シェアを持ちます。",
                                codeSample: "cat /etc/os-release\n# ディストリビューション名とバージョンを確認",
                                tip: nil
                            ),
                            ConceptSection(
                                heading: "GNU とフリーソフトウェア",
                                body: "GNU プロジェクト（Richard Stallman 主導）は、ls・cp・grep などの基本コマンドを自由に使えるよう開発しました。これらを「GNU ツール」と呼びます。\n\nLinux カーネル + GNU ツール = 「GNU/Linux」が本来の正式名称です。\n\nGPL ライセンス（GNU General Public License）により、ソースコードの公開と改変の自由が保証されます。これが「オープンソース」の核心で、商用製品にも組み込みが可能なため、世界のサーバーの約 96% が Linux を採用しています。",
                                codeSample: nil,
                                tip: "Android も Linux カーネルの上で動いています"
                            )
                        ]
                    ))
                ),
                // ─── 学習 2 ──────────────────────────────────────────────
                Lesson(
                    title: "シェルの種類とコマンド実行の仕組み",
                    emoji: "⌨️",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "シェルはユーザーとカーネルを繋ぐ翻訳者",
                        sections: [
                            ConceptSection(
                                heading: "ターミナルとシェルの違い",
                                body: "混同されがちですが、役割が異なります。\n\n• ターミナル（端末エミュレータ）: 文字の入出力を行うウィンドウプログラム。画面に文字を表示するだけで、コマンドを解釈する能力はない。\n• シェル: コマンドを解釈し、カーネルへ命令を渡すプログラム。bash、sh、zsh などが「シェル」。\n\n「ターミナルを開く」→ ターミナルが bash などのシェルを起動→ ユーザーのコマンドをシェルが解釈 → カーネルへ渡す、という流れです。",
                                codeSample: "echo $SHELL\n# 現在使用しているシェルのパスを確認\n# 例: /bin/bash",
                                tip: nil
                            ),
                            ConceptSection(
                                heading: "主要なシェルの種類",
                                body: "• sh（Bourne Shell）: 最も古い標準シェル。POSIX 標準に準拠。Ubuntu では /bin/sh → dash へのシンボリックリンク。\n• bash（Bourne Again Shell）: sh の機能拡張版。Linux のデフォルトで最も広く使われる。\n• zsh（Z Shell）: bash 互換 + 高機能補完・プロンプトカスタマイズ。macOS のデフォルト。\n• ksh（Korn Shell）: 商用 Unix での採用が多い。POSIX 準拠。\n• dash: Ubuntu の /bin/sh 実態。bash より高速で軽量。POSIX 準拠。\n\n「bash スクリプト」と「sh スクリプト」の互換性：sh 向けに書いたスクリプトは bash でも動く（sh は bash のサブセット）。逆は保証されない。",
                                codeSample: "#!/bin/bash   # bash で実行（bash 拡張機能が使える）\n#!/bin/sh      # POSIX sh で実行（最大の移植性）",
                                tip: "本番環境用の汎用スクリプトは #!/bin/sh を使うと、異なるディストリビューションでも動作します"
                            ),
                            ConceptSection(
                                heading: "コマンドが実行される仕組み（PATH）",
                                body: "ターミナルで「ls」と入力したとき、シェルはどうやって ls プログラムを見つけるのか？\n\n1. まずシェルの「組み込みコマンド（built-in）」を確認（cd, echo, type など）\n2. なければ環境変数 PATH を左から順に検索\n3. PATH に含まれるディレクトリでコマンドファイルを発見 → 実行\n\nPATH は「:/」区切りのディレクトリリスト。通常 /usr/bin:/bin:/usr/local/bin など。\n\n「command not found」エラーは「PATH 上にコマンドが存在しない」を意味します。",
                                codeSample: "echo $PATH\n# /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin\ntype ls\n# ls is hashed (/bin/ls)  ← 外部コマンド\ntype cd\n# cd is a shell builtin  ← 組み込みコマンド",
                                tip: nil
                            )
                        ]
                    ))
                ),
                // ─── 学習 3 ──────────────────────────────────────────────
                Lesson(
                    title: "Linuxファイルシステム階層（FHS）",
                    emoji: "🗂️",
                    estimatedMinutes: 8,
                    content: .concept(ConceptLesson(
                        headline: "どこに何があるかを知る",
                        sections: [
                            ConceptSection(
                                heading: "FHS（Filesystem Hierarchy Standard）",
                                body: "Linux のディレクトリ構造は FHS という標準で定義されており、どのディストリビューションでも共通の場所にファイルが存在します。\n\n主要なディレクトリ：\n• / （ルート）: 全ての起点\n• /bin: 基本コマンド（ls, cp, mv など）→ 多くの環境で /usr/bin へのリンク\n• /sbin: システム管理コマンド（fdisk, ifconfig など）\n• /etc: 設定ファイル（nginx.conf, sshd_config など）\n• /var: 変動するデータ（ログ /var/log, キャッシュ /var/cache など）\n• /home: ユーザーのホームディレクトリ（/home/user）\n• /root: root ユーザーのホームディレクトリ\n• /tmp: 一時ファイル（再起動で消える）\n• /usr: ユーザー向けプログラム（/usr/bin, /usr/lib, /usr/share）\n• /proc: プロセス情報（仮想ファイルシステム）\n• /dev: デバイスファイル",
                                codeSample: "ls /etc | head -10\n# 設定ファイルを確認\ntail -20 /var/log/syslog\n# システムログを確認",
                                tip: "/proc/cpuinfo や /proc/meminfo のように、カーネル情報がファイルとして見える「全てはファイル」という Unix 哲学が Linux にも受け継がれています"
                            ),
                            ConceptSection(
                                heading: "プロンプトを正確に読む",
                                body: "プロンプトの形式: ユーザー名@ホスト名:カレントディレクトリ 記号\n\n例: admin@web01:/etc/nginx$\n• admin: ログインユーザー名\n• web01: マシン名（ホスト名）\n• /etc/nginx: 現在いるディレクトリ（絶対パス）\n• $: 一般ユーザー（root なら # になる）\n\n⚠️ # が表示されているとき root 権限があります。誤操作が即システム破壊になり得るため注意が必要です。",
                                codeSample: "user@server:~$      # 一般ユーザー、ホームディレクトリ\nroot@server:/var#   # root ユーザー、/var にいる",
                                tip: nil
                            )
                        ]
                    ))
                ),
                // ─── 問題 ─────────────────────────────────────────────────
                Lesson(
                    title: "Linux基礎・シェル・FHS 理解テスト",
                    emoji: "🎯",
                    estimatedMinutes: 12,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "次のプロンプトを見てください。\n\nadmin@web01:/etc/nginx$\n\nこのユーザーは root 権限を持っているか？",
                                choices: [
                                    "持っていない（$ は一般ユーザーを示す）",
                                    "持っている（admin という名前だから）",
                                    "判断できない",
                                    "持っている（/etc ディレクトリにいるから）"
                                ],
                                correctIndex: 0,
                                explanation: "プロンプト末尾の $ は一般ユーザーを示します。root なら # になります。ユーザー名が admin であっても、root グループに所属するかどうかはプロンプトだけでは判断できませんが、# でないため現在の有効 UID は 0（root）ではありません。"
                            ),
                            QuizQuestion(
                                question: "#!/bin/sh で始まるスクリプトを bash で実行したとき、動作は？",
                                choices: [
                                    "通常は動く（sh は bash のサブセットで bash は sh 互換）",
                                    "必ず動かない（シェルが違うため）",
                                    "bash は sh スクリプトを読めない",
                                    "#!/bin/sh は bash を指定するシェバング"
                                ],
                                correctIndex: 0,
                                explanation: "bash は Bourne Again Shell の略で sh の機能を包含しています。sh 準拠で書かれたスクリプトは bash で実行しても基本的に動きます。逆に bash 固有の拡張機能（配列、[[ ]] など）を使うと sh では動きません。"
                            ),
                            QuizQuestion(
                                question: "システムの Nginx 設定ファイルを編集したい。どのディレクトリを探すべきか？",
                                choices: [
                                    "/etc",
                                    "/var/nginx",
                                    "/usr/bin",
                                    "/home/nginx"
                                ],
                                correctIndex: 0,
                                explanation: "/etc はシステム全体の設定ファイルを格納する FHS の標準ディレクトリです。Nginx の場合 /etc/nginx/nginx.conf、Apache なら /etc/apache2/ などに設定ファイルがあります。/var はログやキャッシュ、/usr/bin はコマンドの実体が置かれます。"
                            ),
                            QuizQuestion(
                                question: "type cd を実行したところ「cd is a shell builtin」と表示された。これは何を意味するか？",
                                choices: [
                                    "cd はシェルに組み込まれた命令で、ファイルとしてディスク上には存在しない",
                                    "cd は /bin/cd にある外部コマンド",
                                    "cd はインストールが必要なツール",
                                    "cd は使用不可能な状態にある"
                                ],
                                correctIndex: 0,
                                explanation: "cd・echo・type・export などは「シェル組み込みコマンド（built-in）」です。外部プロセスを起動せずシェル自身が処理するため高速です。一方 ls や cp は /bin/ls のような実ファイルを持つ「外部コマンド」で、シェルが新しいプロセスを fork して実行します。"
                            ),
                            QuizQuestion(
                                question: "コマンドを実行したら「command not found」になった。最も可能性が高い原因は？",
                                choices: [
                                    "コマンドが PATH の通ったディレクトリに存在しない（未インストール or パスが通っていない）",
                                    "メモリ不足",
                                    "ファイルの読み取り権限がない",
                                    "ディスクが満杯"
                                ],
                                correctIndex: 0,
                                explanation: "「command not found」はシェルが PATH 上のどのディレクトリを検索してもコマンドが見つからなかった場合に表示されます。コマンドが未インストール、または /usr/local/bin など PATH に含まれていないディレクトリにある場合に発生します。which コマンドや type コマンドでコマンドの場所を調べられます。"
                            ),
                            QuizQuestion(
                                question: "Ubuntu では /bin/sh の実態は bash ではなく dash である。その主な理由は？",
                                choices: [
                                    "dash は POSIX 準拠で bash より軽量・高速なため、システム起動スクリプトの実行が速くなる",
                                    "bash は Ubuntu にインストールされていないため",
                                    "dash の方が多くの機能を持つため",
                                    "bash は GPL ライセンスでない"
                                ],
                                correctIndex: 0,
                                explanation: "Ubuntu は起動速度改善のため /bin/sh → dash（Debian Almquist Shell）を使っています。dash は bash より大幅に小さく高速です。POSIX 準拠スクリプトであれば dash で問題なく動作します。bash は別途 /bin/bash として存在し、ユーザーのデフォルトシェルとして通常使われます。"
                            ),
                        ]
                    ))
                ),
            ]
        ),
        Chapter(
            number: 2,
            title: "ファイルシステムナビゲーション",
            summary: "pwd, ls, cd でファイルシステムを自由に移動する",
            lessons: [
                Lesson(
                    title: "pwd - 現在位置の確認",
                    emoji: "📍",
                    estimatedMinutes: 8,
                    content: .concept(ConceptLesson(
                        headline: "ファイルシステムはツリー構造",
                        sections: [
                            ConceptSection(
                                heading: "pwd コマンドの役割",
                                body: "pwd（Print Working Directory）は、現在いるディレクトリの絶対パスを表示します。\n\nLinux のファイルシステムはツリー構造で、常に「どこのフォルダにいるのか」を意識する必要があります。pwd を実行することで、現在位置を確認できます。",
                                codeSample: "pwd\n# 出力例: /home/user/Documents",
                                tip: "ディレクトリ移動後は pwd で現在位置を確認する習慣をつけましょう"
                            ),
                            ConceptSection(
                                heading: "絶対パスと相対パス",
                                body: "• 絶対パス: / から始まるパス（例: /home/user）\n• 相対パス: 現在位置から見たパス（例: Documents）\n\npwd は絶対パスを表示するため、現在の正確な位置を知ることができます。",
                                codeSample: nil,
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "pwd - 現在位置クエスト",
                    emoji: "🎯",
                    estimatedMinutes: 6,
                    content: .quest(QuestLesson(
                        scenario: "あなたはファイルサーバーの深いディレクトリにいます。現在地を確認する必要があります。",
                        prompt: "現在のディレクトリパスを表示するコマンドは？",
                        hint: "Print Working Directory の略。実行すると絶対パスが表示されます。",
                        answer: "pwd",
                        options: [
                            CommandOption(label: "pwd", command: "pwd", icon: "mappin.circle.fill"),
                            CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                            CommandOption(label: "cd ..", command: "cd", icon: "chevron.right"),
                        ],
                        simulatedOutput: "/var/www/html/project/src",
                        successMessage: "✅ 完璧！現在地が確認できました"
                    ))
                ),
                Lesson(
                    title: "ls - ファイル一覧表示",
                    emoji: "📂",
                    estimatedMinutes: 8,
                    content: .concept(ConceptLesson(
                        headline: "フォルダの内容を見る",
                        sections: [
                            ConceptSection(
                                heading: "ls コマンドの目的",
                                body: "ls（List）は、現在のディレクトリに含まれるファイルとフォルダの一覧を表示します。\n\nGUI では、フォルダをダブルクリックして中身を見ますが、CLI では ls コマンドで中身を確認します。",
                                codeSample: "ls\n# 出力例:\n# Desktop  Documents  Downloads  Music",
                                tip: "ls -l で詳細情報（権限、サイズ、更新日時など）を表示できます"
                            ),
                            ConceptSection(
                                heading: "よく使う ls のオプション",
                                body: "• ls: 基本的なファイル一覧\n• ls -l: 詳細情報付き（権限、所有者、サイズ、更新日）\n• ls -a: 隠しファイル（. で始まるファイル）も表示\n• ls -h: ファイルサイズを人間が読みやすい形式で表示",
                                codeSample: "ls -lh",
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "ls - ファイル一覧クエスト",
                    emoji: "🎯",
                    estimatedMinutes: 6,
                    content: .quest(QuestLesson(
                        scenario: "プロジェクトフォルダに移動しました。フォルダの内容を確認して、どんなファイルがあるかを把握する必要があります。",
                        prompt: "フォルダ内のファイルとサブフォルダを詳細情報付きで表示するコマンドは？",
                        hint: "ls -l で詳細情報（権限、サイズ、更新日時）が表示されます。",
                        answer: "ls",
                        options: [
                            CommandOption(label: "ls -l", command: "ls", icon: "list.bullet"),
                            CommandOption(label: "pwd", command: "pwd", icon: "mappin.circle.fill"),
                            CommandOption(label: "cat", command: "cat", icon: "doc.text"),
                        ],
                        simulatedOutput: "drwxr-xr-x  src\n-rw-r--r--  README.md\ndrwxr-xr-x  tests",
                        successMessage: "✅ ファイル一覧が表示されました"
                    ))
                ),
                Lesson(
                    title: "cd - ディレクトリ移動",
                    emoji: "🚀",
                    estimatedMinutes: 8,
                    content: .concept(ConceptLesson(
                        headline: "ファイルシステムを移動する",
                        sections: [
                            ConceptSection(
                                heading: "cd コマンドの役割",
                                body: "cd（Change Directory）は、現在のディレクトリを別のディレクトリに変更します。\n\nGUI では、フォルダをダブルクリックして開きますが、CLI では cd コマンドで移動します。移動後、pwd で現在位置を確認できます。",
                                codeSample: "cd Documents\n# 移動後\npwd\n# /home/user/Documents",
                                tip: "cd ~ でホームディレクトリに移動、cd .. で親ディレクトリに移動できます"
                            ),
                            ConceptSection(
                                heading: "cd の使い方と特殊パス",
                                body: "• cd フォルダ名: 指定フォルダに移動（相対パス）\n• cd /絶対パス: 絶対パスで移動\n• cd ~: ホームディレクトリに移動\n• cd ..: 親ディレクトリに移動\n• cd: ホームディレクトリに移動（引数なし）",
                                codeSample: nil,
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "cd - ナビゲーションクエスト",
                    emoji: "🎯",
                    estimatedMinutes: 6,
                    content: .quest(QuestLesson(
                        scenario: "あなたは /var/www/html にいます。src サブフォルダに移動して、そこのファイルを確認する必要があります。",
                        prompt: "現在位置から src フォルダに移動するコマンドは？",
                        hint: "cd src で移動できます。相対パスを使用します。",
                        answer: "cd",
                        options: [
                            CommandOption(label: "cd src", command: "cd", icon: "chevron.right"),
                            CommandOption(label: "ls src", command: "ls", icon: "list.bullet"),
                            CommandOption(label: "pwd src", command: "pwd", icon: "mappin.circle.fill"),
                        ],
                        simulatedOutput: "user@server:/var/www/html$ cd src\nuser@server:/var/www/html/src$",
                        successMessage: "✅ src に移動！プロンプトのパスが変わったことに注目。pwd で確認できます。"
                    ))
                ),
                // ─── 問題（クイズ）────────────────────────────────────────
                Lesson(
                    title: "ナビゲーション 理解テスト",
                    emoji: "🗺️",
                    estimatedMinutes: 10,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "ls -l の出力を見てください。\n\n-rw-r--r-- 2 alice web 4096 Jan 15 report.txt\n\n「2」は何を意味するか？",
                                choices: [
                                    "ハードリンク数（この inode を指すリンクが2つある）",
                                    "ファイルのバージョン番号",
                                    "グループに属するユーザー数",
                                    "書き込み権限のビット値"
                                ],
                                correctIndex: 0,
                                explanation: "ls -l の3列目はハードリンク数です。同じ inode（ファイルの実体）を指すファイル名が何個あるかを示します。通常のファイルは 1 ですが、ハードリンクを作ると増えます。ディレクトリの場合はサブディレクトリ数 + 2（. と ..）になります。"
                            ),
                            QuizQuestion(
                                question: "現在 /var/www/html/project にいる。\ncd ../../ を実行後、pwd が返す値は？",
                                choices: [
                                    "/var/www",
                                    "/var",
                                    "/var/www/html",
                                    "/"
                                ],
                                correctIndex: 0,
                                explanation: "cd .. は1段上の親ディレクトリへ移動します。cd ../../ は2段上なので、/var/www/html/project → /var/www/html → /var/www となります。パスを手で追って確認する習慣をつけましょう。"
                            ),
                            QuizQuestion(
                                question: "ls -l の出力の先頭文字が d で始まるエントリ（例: drwxr-xr-x）は何を示すか？",
                                choices: [
                                    "ディレクトリ",
                                    "ダイナミックリンクライブラリ",
                                    "削除済みファイル",
                                    "デバイスファイル"
                                ],
                                correctIndex: 0,
                                explanation: "ls -l の先頭文字はファイルタイプを示します。d=ディレクトリ、-=通常ファイル、l=シンボリックリンク、c=キャラクタデバイス、b=ブロックデバイス、p=パイプ、s=ソケット。実務で頻出の区別です。"
                            ),
                            QuizQuestion(
                                question: "ホームディレクトリ /home/alice にいるとき cd を引数なしで実行し、その後 pwd を実行した。結果は？",
                                choices: [
                                    "/home/alice（引数なし cd はホームへ戻る）",
                                    "/ （ルートへ移動）",
                                    "何も起きない（引数なしは無効）",
                                    "エラーになる"
                                ],
                                correctIndex: 0,
                                explanation: "cd を引数なしで実行すると、環境変数 HOME に設定されたディレクトリ（通常は /home/ユーザー名）へ移動します。cd ~ も同じ動作です。深いディレクトリにいて素早くホームへ戻りたい場合に使います。"
                            ),
                            QuizQuestion(
                                question: "ls を実行すると .bashrc が表示されなかった。原因は？",
                                choices: [
                                    ".（ドット）で始まるファイルは ls のデフォルト出力で非表示になる",
                                    ".bashrc はシステムファイルで通常ユーザーには見えない",
                                    "ファイルが存在しない",
                                    "ls は txt ファイルしか表示しない"
                                ],
                                correctIndex: 0,
                                explanation: "Linux では . で始まるファイル・ディレクトリは「隠しファイル」として扱われ、ls のデフォルト出力には含まれません。ls -a（または ls -la で詳細付き）で表示できます。.bashrc .gitignore .env などの設定ファイルに多く使われます。"
                            ),
                        ]
                    ))
                ),
            ]
        ),
        Chapter(
            number: 3,
            title: "ファイル操作マスター",
            summary: "cp, mv, rm を組み合わせて実践的なファイル管理",
            lessons: basicsCourseLessons
        ),
    ]
)

// MARK: - Standard Course
let standardCourse = Course(
    level: .standard,
    title: "テキスト処理と権限",
    subtitle: "grep, sed, chmod をマスター",
    description: "ファイル操作の応用、テキスト検索・処理、権限管理を学びます。",
    emoji: "⚙️",
    estimatedMinutes: 120,
    chapters: [
        Chapter(
            number: 4,
            title: "テキストを検索・操作する",
            summary: "grep, sed で強力なテキスト処理",
            lessons: [
                Lesson(
                    title: "grep - テキストを検索する",
                    emoji: "🔍",
                    estimatedMinutes: 8,
                    content: .concept(ConceptLesson(
                        headline: "ファイル内から特定の行を見つける",
                        sections: [
                            ConceptSection(
                                heading: "grep コマンドの役割",
                                body: "grep（Global Regular Expression Print）は、ファイルやパイプからテキストを検索し、マッチした行を表示するコマンドです。\n\nログファイルからエラーだけを抽出したり、ファイルから特定の単語を含む行を見つけたりするとき、grep は必須ツールです。",
                                codeSample: "grep ERROR application.log\n# 出力: ERROR を含む行だけが表示される\ngrep \"connection\" *.txt\n# 複数ファイルから検索",
                                tip: "grep は大文字小文字を区別します。区別したくない場合は -i オプション"
                            ),
                            ConceptSection(
                                heading: "よく使う grep のオプション",
                                body: "• grep パターン ファイル: パターンを含む行を表示\n• grep -i: 大文字小文字を区別しない\n• grep -r: ディレクトリ内を再帰的に検索\n• grep -n: マッチした行の行番号も表示\n• grep -v: パターンに「マッチしない」行を表示（逆マッチ）\n• grep -c: マッチした行の件数だけを表示",
                                codeSample: "grep -r \"TODO\" .\n# 現在のディレクトリ以下から \"TODO\" を含むファイル行を全て探す",
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "grep - テキスト検索クエスト",
                    emoji: "🎯",
                    estimatedMinutes: 6,
                    content: .quest(QuestLesson(
                        scenario: "サーバーのエラーログから問題を診断する必要があります。多くの行がある中から ERROR ログだけ抽出します。",
                        prompt: "ログファイル app.log から ERROR を含む行だけを表示するコマンドは？",
                        hint: "grep ERROR app.log で ERROR を含む行を抽出できます。",
                        answer: "grep",
                        options: [
                            CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
                            CommandOption(label: "sed", command: "sed", icon: "pencil.and.outline"),
                            CommandOption(label: "awk", command: "awk", icon: "square.and.pencil"),
                        ],
                        simulatedOutput: "[10:25] ERROR: Database connection failed\n[10:26] ERROR: Timeout on query",
                        successMessage: "✅ エラーログのみが抽出されました"
                    ))
                ),
                Lesson(
                    title: "sed - テキストを置換する",
                    emoji: "✏️",
                    estimatedMinutes: 8,
                    content: .concept(ConceptLesson(
                        headline: "テキストを一括置換する",
                        sections: [
                            ConceptSection(
                                heading: "sed コマンドの役割",
                                body: "sed（Stream Editor）は、ファイルのテキストを検索して置換（または削除）するコマンドです。\n\nグローバル置換や条件付き置換、複数行の削除など、高度なテキスト処理ができます。ログファイルの機密情報を隠したり、設定ファイルの値を一括変更したりするときに使用します。",
                                codeSample: "sed 's/old/new/g' file.txt\n# file.txt 内の「old」を「new」に全て置換\nsed -i 's/old/new/g' file.txt\n# ファイルを直接編集(-i オプション)",
                                tip: "g フラグなしの場合、1行につき最初にマッチした1つだけが置換されます"
                            ),
                            ConceptSection(
                                heading: "sed の基本構文と g フラグ",
                                body: "• s/old/new/: 最初の1つだけを置換\n• s/old/new/g: 1行内の「全て」を置換（global）\n• sed '5s/old/new/': 5行目だけを置換\n• sed '1,10s/old/new/g': 1〜10行目を置換\n• sed 's/^/prefix-/': 行の先頭に追加\n• sed 's/$/-suffix/': 行の末尾に追加",
                                codeSample: nil,
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "sed - テキスト置換クエスト",
                    emoji: "🎯",
                    estimatedMinutes: 6,
                    content: .quest(QuestLesson(
                        scenario: "設定ファイル config.txt 内の database_host 値を新しいサーバーに変更する必要があります。",
                        prompt: "config.txt 内の「localhost」を全て「192.168.1.10」に置換するコマンドは？",
                        hint: "sed 's/localhost/192.168.1.10/g' config.txt で全て置換できます。g フラグを忘れずに。",
                        answer: "sed",
                        options: [
                            CommandOption(label: "sed", command: "sed", icon: "pencil.and.outline"),
                            CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
                            CommandOption(label: "awk", command: "awk", icon: "square.and.pencil"),
                        ],
                        simulatedOutput: "database_host=192.168.1.10\ncache_host=192.168.1.10",
                        successMessage: "✅ 全ての localhost が新しいホストに置換されました"
                    ))
                ),
                Lesson(
                    title: "grep 実践クイズ",
                    emoji: "🧪",
                    estimatedMinutes: 10,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "次の2つのコマンドで出力が異なるのはどんな場合か？\n\nA: grep 'error' app.log\nB: grep -i 'error' app.log",
                                choices: [
                                    "ログに「Error」や「ERROR」が含まれる行がある場合（A は一致しないが B は一致する）",
                                    "常に同じ結果になる",
                                    "A の方がより多くの行を返す",
                                    "B はファイルを変更してしまう"
                                ],
                                correctIndex: 0,
                                explanation: "grep はデフォルトで大文字小文字を区別します。-i を付けると区別しなくなります。実務のログは ERROR、Error、error など表記が混在することがあるため、ログ解析では -i を使うことが多いです。"
                            ),
                            QuizQuestion(
                                question: "cat app.log | grep CRITICAL | wc -l を実行したら「0」と表示された。正確に何を意味するか？",
                                choices: [
                                    "app.log 内に「CRITICAL」という文字列を含む行が0行だった",
                                    "app.log が空ファイルだった",
                                    "grep が実行に失敗した",
                                    "wc -l は0を表示しない（最低1）"
                                ],
                                correctIndex: 0,
                                explanation: "wc -l は標準入力の行数を表示します。grep に一致する行が0件なら、wc -l への入力も0行なので「0」と表示されます。CRITICAL ログが一件もないということで、これは正常な状態です。"
                            ),
                            QuizQuestion(
                                question: "grep -l 'pattern' /var/log/*.log の出力は何か？",
                                choices: [
                                    "pattern を含む行ではなく、pattern を含むファイル名の一覧",
                                    "pattern を含む行と行番号",
                                    "pattern を含まないファイルの一覧",
                                    "pattern が何行あるかを各ファイルごとに表示"
                                ],
                                correctIndex: 0,
                                explanation: "-l（lowercase L）は list の意。マッチした行の内容ではなく、マッチが見つかったファイル名だけを表示します。複数のログファイルから「このパターンを含むログはどれか」を調べるときに便利です。-c はマッチ件数を、-n は行番号を表示します。"
                            ),
                        ]
                    ))
                ),
                Lesson(
                    title: "ログ解析の実務シナリオ",
                    emoji: "📊",
                    estimatedMinutes: 14,
                    content: .scenario(ScenarioLesson(
                        setup: "本番サーバーのログファイルから、エラーを検出し、統計情報を取得します。",
                        goal: "grep と パイプを使ったログ解析",
                        steps: [
                            ScenarioStep(
                                prompt: "application.log ファイルのすべての内容を表示します。",
                                hint: "cat application.log",
                                answer: "cat",
                                options: [
                                    CommandOption(label: "cat", command: "cat", icon: "doc.text"),
                                    CommandOption(label: "less", command: "less", icon: "book"),
                                    CommandOption(label: "tail", command: "tail", icon: "triangle.fill"),
                                ],
                                simulatedOutput: "[2024-01-15 10:23:45] INFO: Server started\n[2024-01-15 10:25:12] ERROR: Connection timeout\n[2024-01-15 10:26:33] ERROR: Database failed\n[2024-01-15 10:27:01] WARNING: Memory low"
                            ),
                            ScenarioStep(
                                prompt: "ERROR ログの行だけを抽出します。",
                                hint: "cat application.log | grep ERROR",
                                answer: "grep",
                                options: [
                                    CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
                                    CommandOption(label: "sed", command: "sed", icon: "pencil.and.outline"),
                                    CommandOption(label: "awk", command: "awk", icon: "square.and.pencil"),
                                ],
                                simulatedOutput: "[2024-01-15 10:25:12] ERROR: Connection timeout\n[2024-01-15 10:26:33] ERROR: Database failed"
                            ),
                            ScenarioStep(
                                prompt: "ERROR ログの件数をカウントします。",
                                hint: "cat application.log | grep ERROR | wc -l",
                                answer: "wc",
                                options: [
                                    CommandOption(label: "wc", command: "wc", icon: "sum"),
                                    CommandOption(label: "sort", command: "sort", icon: "arrow.up.arrow.down"),
                                    CommandOption(label: "cut", command: "cut", icon: "scissors"),
                                ],
                                simulatedOutput: "2"
                            ),
                        ],
                        finaleMessage: "✅ ログ解析のプロになりました！"
                    ))
                ),
                Lesson(
                    title: "テキスト処理総合クイズ",
                    emoji: "🎯",
                    estimatedMinutes: 12,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "1行に「apple」が3回現れるテキストに対して、以下2つの sed コマンドの出力の違いは？\n\nA: sed 's/apple/orange/' data.txt\nB: sed 's/apple/orange/g' data.txt",
                                choices: [
                                    "A は1行につき最初の1個だけ置換、B は全ての apple を置換する",
                                    "A と B は同じ結果になる",
                                    "A は全部、B は最後の1個だけ置換",
                                    "A は行を削除、B は置換"
                                ],
                                correctIndex: 0,
                                explanation: "g フラグ（global）なしの sed は1行につき最初にマッチした1箇所だけを置換します。3回 apple が出現する行でも A では最初の1個だけ orange に変わります。設定ファイルの一括置換では g フラグを忘れると一部だけが変わり、見つかりにくいバグの原因になります。"
                            ),
                            QuizQuestion(
                                question: "sed -i 's/DEBUG/INFO/g' app.log を実行した。元のファイルはどうなるか？",
                                choices: [
                                    "ファイルそのものが書き換えられる（-i はファイルをインプレースで編集）",
                                    "app.log は変更されず、結果が標準出力に表示される",
                                    "app.log.bak というバックアップが自動作成される",
                                    "エラーになる（-i は危険なため使用不可）"
                                ],
                                correctIndex: 0,
                                explanation: "-i（in-place）オプションはファイルを直接書き換えます。バックアップなしで上書きされるため元に戻せません。安全のため sed -i.bak 's/DEBUG/INFO/g' app.log のようにバックアップ拡張子を指定するとよいです（app.log.bak が作成されます）。"
                            ),
                            QuizQuestion(
                                question: "パイプで繋いだコマンド A | B | C がある。コマンド B がエラー終了した場合、デフォルトで C は実行されるか？",
                                choices: [
                                    "される（デフォルトでパイプはエラーを伝播しない。C は B の出力を受け取り実行される）",
                                    "されない（エラーで即時中断）",
                                    "A だけ再実行される",
                                    "C はエラーコードを受け取って実行される"
                                ],
                                correctIndex: 0,
                                explanation: "bash のデフォルト動作では、パイプライン中のコマンドがエラー終了しても次のコマンドは実行されます。パイプライン全体の終了コードは最後のコマンド（C）のものになります。B のエラーに気づかず処理を続けるため、set -o pipefail を設定するか、各ステップで終了コードをチェックする習慣が重要です。"
                            ),
                        ]
                    ))
                ),
            ]
        ),
        Chapter(
            number: 5,
            title: "ファイル権限を管理する",
            summary: "chmod で権限設定をマスター",
            lessons: [
                Lesson(
                    title: "chmod - ファイル権限の基本",
                    emoji: "🔑",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "ファイルアクセス権限を設定する",
                        sections: [
                            ConceptSection(
                                heading: "chmod コマンドの役割",
                                body: "chmod（Change Mode）は、ファイルやディレクトリのアクセス権限を変更するコマンドです。\n\nLinux では全てのファイルに「所有者」「グループ」「その他」の3つの対象に対して「読み（r）」「書き（w）」「実行（x）」の3つの権限があります。chmod でこれらを制御します。",
                                codeSample: "chmod 755 script.sh\n# 出力: -rwxr-xr-x\n# 所有者: 読み書き実行、グループ: 読み実行、他: 読み実行",
                                tip: "デフォルト（644）はテキストファイル向け。実行ファイルは755を使用します"
                            ),
                            ConceptSection(
                                heading: "権限の数値表記（8進数）",
                                body: "権限は8進数（0〜7）で表されます。各桁は3つの権限（読み4 + 書き2 + 実行1）の合計です：\n\n• 7 = 4+2+1 = 読み書き実行（rwx）\n• 6 = 4+2   = 読み書き（rw-）\n• 5 = 4   +1 = 読み実行（r-x）\n• 4 = 4       = 読みのみ（r--）\n• 0           = 権限なし（---）\n\n例: 755 = 所有者7（rwx）, グループ5（r-x）, 他5（r-x）",
                                codeSample: "chmod 644 file.txt   # 読み書き、読み、読み\nchmod 755 script.sh  # 読み書き実行、読み実行、読み実行",
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "chmod - 権限設定クエスト",
                    emoji: "🎯",
                    estimatedMinutes: 8,
                    content: .quest(QuestLesson(
                        scenario: "あなたが deploy.sh という自動デプロイスクリプトを作成しました。所有者は実行可能にし、グループと他のユーザーには読み実行権限を与える必要があります。",
                        prompt: "deploy.sh に 755 権限を設定して、全員が実行可能にするコマンドは？",
                        hint: "chmod 755 deploy.sh で権限を設定します。755 = 所有者rwx, グループr-x, 他r-x",
                        answer: "chmod",
                        options: [
                            CommandOption(label: "chmod", command: "chmod", icon: "lock.open"),
                            CommandOption(label: "chown", command: "chown", icon: "person.fill"),
                            CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                        ],
                        simulatedOutput: "user@linux:~$ chmod 755 deploy.sh\nuser@linux:~$ ls -l deploy.sh\n-rwxr-xr-x  1 user group  1234 Jan 15 10:00 deploy.sh",
                        successMessage: "✅ スクリプトが実行可能な状態になりました"
                    ))
                ),
                Lesson(
                    title: "chmod 実践シナリオ",
                    emoji: "🔐",
                    estimatedMinutes: 12,
                    content: .scenario(ScenarioLesson(
                        setup: "Webサーバーのファイル権限を正しく設定します。",
                        goal: "chmod で段階的に権限を設定",
                        steps: [
                            ScenarioStep(
                                prompt: "スクリプトファイル deploy.sh を実行可能にします。（-rwxr-xr-x = 755）",
                                hint: "chmod 755 deploy.sh",
                                answer: "chmod",
                                options: [
                                    CommandOption(label: "chmod", command: "chmod", icon: "lock.open"),
                                    CommandOption(label: "chown", command: "chown", icon: "person.fill"),
                                    CommandOption(label: "chgrp", command: "chgrp", icon: "person.2.fill"),
                                ],
                                simulatedOutput: "user@linux:~$ chmod 755 deploy.sh\nuser@linux:~$ ls -l deploy.sh\n-rwxr-xr-x  1 user group  1234 Jan 15 10:00 deploy.sh"
                            ),
                            ScenarioStep(
                                prompt: "機密ファイル secret.key を所有者のみが読めるようにします。（-r-------- = 400）",
                                hint: "chmod 400 secret.key",
                                answer: "chmod",
                                options: [
                                    CommandOption(label: "chmod", command: "chmod", icon: "lock"),
                                    CommandOption(label: "chown", command: "chown", icon: "person.fill"),
                                    CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                ],
                                simulatedOutput: "user@linux:~$ chmod 400 secret.key\nuser@linux:~$ ls -l secret.key\n-r--------  1 user group  2048 Jan 15 10:00 secret.key"
                            ),
                            ScenarioStep(
                                prompt: "共有ファイル notes.txt をグループと所有者が読み書きできるようにします。（-rw-rw---- = 660）",
                                hint: "chmod 660 notes.txt",
                                answer: "chmod",
                                options: [
                                    CommandOption(label: "chmod", command: "chmod", icon: "lock.open"),
                                    CommandOption(label: "chown", command: "chown", icon: "person.fill"),
                                    CommandOption(label: "umask", command: "umask", icon: "lock"),
                                ],
                                simulatedOutput: "user@linux:~$ chmod 660 notes.txt\nuser@linux:~$ ls -l notes.txt\n-rw-rw----  1 user group  4096 Jan 15 10:00 notes.txt"
                            ),
                        ],
                        finaleMessage: "✅ 権限設定のマスターになりました！"
                    ))
                ),
                Lesson(
                    title: "権限管理の深掘りテスト",
                    emoji: "🔑",
                    estimatedMinutes: 12,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "umask 022 の場合、新規作成したファイルのデフォルト権限は？",
                                choices: [
                                    "644（rw-r--r--）",
                                    "755（rwxr-xr-x）",
                                    "777（rwxrwxrwx）",
                                    "022（--------w-w）"
                                ],
                                correctIndex: 0,
                                explanation: "umask は新規ファイル作成時に「引く」ビットマスクです。ファイルのデフォルト最大権限は 666（実行なし）で、そこから umask 022 を引くと 644 になります。ディレクトリの最大権限は 777 で umask 022 を引くと 755。umask はセキュリティの観点で重要な設定です。"
                            ),
                            QuizQuestion(
                                question: "ls -l の出力が '-rwsr-xr-x' となっているファイルがあった。's' が示すのは？",
                                choices: [
                                    "Set UID ビット：このファイルを実行すると、所有者の権限でプロセスが動く",
                                    "Sticky ビット：ファイルが常にメモリに残る",
                                    "シンボリックリンクを示す",
                                    "書き込み専用ファイル"
                                ],
                                correctIndex: 0,
                                explanation: "Set UID（SUID）ビットが設定されたコマンドは、実行者ではなくファイル所有者の権限で動作します。代表例は /usr/bin/passwd：一般ユーザーが実行しても /etc/shadow を書き換えられるのは SUID で root 権限で動くためです。SUID ファイルは攻撃者に悪用されることもあるため、不用意な設定は危険です。"
                            ),
                            QuizQuestion(
                                question: "ディレクトリに chmod 1777 を設定した。最初の '1' は何を意味するか？",
                                choices: [
                                    "スティッキービット：そのディレクトリ内のファイルは所有者か root しか削除できない",
                                    "Set UID：ディレクトリ内のファイルの所有者を固定",
                                    "読み専用フラグ",
                                    "バージョン番号"
                                ],
                                correctIndex: 0,
                                explanation: "スティッキービット（Sticky bit）は /tmp のようなパブリックな書き込みディレクトリで使われます。1777 を設定すると、全員がファイルを作成できても、自分のファイルしか削除できません。ls -l では drwxrwxrwt のように t で表示されます（T は実行権限なし）。"
                            ),
                            QuizQuestion(
                                question: "chmod g-w,o-r script.sh を実行した。このコマンドの意味は？",
                                choices: [
                                    "グループの書き込み権限を削除し、他のユーザーの読み取り権限を削除する",
                                    "グループに書き込みを追加し、他に読み取りを追加する",
                                    "グループのみ全権限を削除する",
                                    "エラー（カンマで複数指定はできない）"
                                ],
                                correctIndex: 0,
                                explanation: "chmod のシンボリック表記では対象（u/g/o/a）、操作（+/-/=）、権限（r/w/x）を組み合わせます。カンマで複数の変更を一度に指定できます。g-w はグループから書き込みを引く、o-r は他から読み取りを引く、という意味です。"
                            ),
                        ]
                    ))
                ),
            ]
        ),
    ]
)

// MARK: - Advanced Course
let advancedCourse = Course(
    level: .advanced,
    title: "シェルスクリプトとネットワーク",
    subtitle: "自動化と遠隔操作を極める",
    description: "bash スクリプト、SSH、ネットワークコマンドで実務レベルのスキルを習得。",
    emoji: "🚀",
    estimatedMinutes: 90,
    chapters: [
        Chapter(
            number: 6,
            title: "シェルスクリプトで自動化",
            summary: "bash で効率的な自動化スクリプト",
            lessons: [
                Lesson(
                    title: "bash スクリプトの基礎",
                    emoji: "📚",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "シェルスクリプトで自動化を実現",
                        sections: [
                            ConceptSection(
                                heading: "bash スクリプトとは",
                                body: "bash スクリプトは、Linux コマンドを複数組み合わせて、一度に実行するファイルです。\n\nターミナルで1行ずつ入力する代わりに、スクリプトファイルに書いた複数のコマンドが順番に実行されます。バックアップ、ログ処理、定期メンテナンスなど、日常の繰り返し作業を自動化できます。",
                                codeSample: "#!/bin/bash\necho \"バックアップを開始します\"\ncp -r /home/user/documents /backup/\necho \"バックアップが完了しました\"",
                                tip: "スクリプトの最初の行 #!/bin/bash（shebang）は必須。これがないと実行時にどのインタプリタを使うか判断できません"
                            ),
                            ConceptSection(
                                heading: "スクリプト実行の流れ",
                                body: "1. スクリプトファイルを作成（例: backup.sh）\n2. chmod +x で実行可能にする\n3. ./backup.sh で実行\n\n• ./backup.sh: シェバング指定で自動的に bash を選択\n• bash backup.sh: bash コマンドで明示的に実行\n• sh backup.sh: 標準シェルで実行\n\n実行権限がない場合、「Permission denied」エラーが出ます。",
                                codeSample: "chmod +x script.sh  # 実行可能にする\n./script.sh          # 実行",
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "bash スクリプト作成クエスト",
                    emoji: "🎯",
                    estimatedMinutes: 8,
                    content: .quest(QuestLesson(
                        scenario: "毎日データをバックアップするスクリプトが必要です。新しいスクリプトファイルを作成し、実行可能にしましょう。",
                        prompt: "新しいスクリプトファイル backup.sh を作成するコマンドは？",
                        hint: "touch backup.sh でスクリプトファイルを作成します。",
                        answer: "touch",
                        options: [
                            CommandOption(label: "touch", command: "touch", icon: "doc.badge.plus"),
                            CommandOption(label: "nano", command: "nano", icon: "square.and.pencil"),
                            CommandOption(label: "vi", command: "vi", icon: "pencil.and.outline"),
                        ],
                        simulatedOutput: "user@linux:~$ touch backup.sh\nuser@linux:~$ ls backup.sh\nbackup.sh",
                        successMessage: "✅ スクリプトファイルが作成されました"
                    ))
                ),
                Lesson(
                    title: "スクリプト作成の実践",
                    emoji: "📝",
                    estimatedMinutes: 15,
                    content: .scenario(ScenarioLesson(
                        setup: "簡単な bash スクリプトを作成・実行して自動化を体験します。",
                        goal: "スクリプトを作成・実行・デバッグ",
                        steps: [
                            ScenarioStep(
                                prompt: "backup.sh という新しいシェルスクリプトファイルを作成します。",
                                hint: "touch backup.sh",
                                answer: "touch",
                                options: [
                                    CommandOption(label: "touch", command: "touch", icon: "doc.badge.plus"),
                                    CommandOption(label: "nano", command: "nano", icon: "square.and.pencil"),
                                    CommandOption(label: "cat", command: "cat", icon: "doc.text"),
                                ],
                                simulatedOutput: "user@linux:~$ touch backup.sh"
                            ),
                            ScenarioStep(
                                prompt: "backup.sh を実行可能にします。",
                                hint: "chmod +x backup.sh",
                                answer: "chmod",
                                options: [
                                    CommandOption(label: "chmod", command: "chmod", icon: "lock.open"),
                                    CommandOption(label: "chown", command: "chown", icon: "person.fill"),
                                    CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                ],
                                simulatedOutput: "user@linux:~$ chmod +x backup.sh"
                            ),
                            ScenarioStep(
                                prompt: "スクリプトを実行します。",
                                hint: "./backup.sh",
                                answer: "./backup.sh",
                                options: [
                                    CommandOption(label: "./backup.sh", command: "./backup.sh", icon: "play.fill"),
                                    CommandOption(label: "bash backup.sh", command: "bash", icon: "terminal.fill"),
                                    CommandOption(label: "cat backup.sh", command: "cat", icon: "doc.text"),
                                ],
                                simulatedOutput: "Backing up files...\nBackup completed!"
                            ),
                        ],
                        finaleMessage: "✅ スクリプト実行のマスター！"
                    ))
                ),
                Lesson(
                    title: "シェルスクリプト知識クイズ",
                    emoji: "💭",
                    estimatedMinutes: 12,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "次のスクリプトに set -e が先頭に書かれている。cp が失敗した場合、スクリプトはどう動くか？\n\nset -e\ncp source.txt /nonexistent/\necho 'コピー成功'",
                                choices: [
                                    "cp が失敗した時点でスクリプトが即座に終了し、echo は実行されない",
                                    "cp が失敗してもスクリプトは続行し、echo が実行される",
                                    "set -e はエラーメッセージを抑制する",
                                    "cp はエラーを無視して成功扱いにする"
                                ],
                                correctIndex: 0,
                                explanation: "set -e（errexit）を設定すると、コマンドがゼロ以外の終了コードを返した時点でスクリプト全体が終了します。本番環境のスクリプトでは set -e を入れることがベストプラクティスで、エラーを見落とすリスクを減らします。さらに set -o pipefail と組み合わせると、パイプラインのエラーも補足できます。"
                            ),
                            QuizQuestion(
                                question: "スクリプト内で $? が 0 以外の値を示していた。何を意味するか？",
                                choices: [
                                    "直前のコマンドが失敗した（終了コードが0でない = エラー）",
                                    "スクリプトが正常完了した",
                                    "$? は常に 0 を返す",
                                    "変数が未定義"
                                ],
                                correctIndex: 0,
                                explanation: "$? は直前のコマンドの終了コードを保持する特殊変数です。0 は成功、1以上は失敗（エラーの種類によって値が異なる）。if [ $? -eq 0 ]; then ... の形で条件分岐に使います。ただし $? は次のコマンドを実行すると上書きされるため、必要なら変数に保存します。"
                            ),
                            QuizQuestion(
                                question: "次の2つの変数展開の違いは？\n\nA: echo \"$HOME/backup\"\nB: echo '$HOME/backup'",
                                choices: [
                                    "A は変数展開され /home/user/backup と表示、B はリテラルで $HOME/backup と表示",
                                    "A と B は同じ結果",
                                    "B の方が変数展開される",
                                    "どちらもエラー"
                                ],
                                correctIndex: 0,
                                explanation: "bash では二重引用符（\"\"）の中では変数展開・コマンド置換が行われます。単引用符（''）の中では全てのメタ文字が文字通りに扱われ、変数展開は行われません。パスワードや正規表現を含む文字列に単引用符を使うとトラブルを避けられます。"
                            ),
                        ]
                    ))
                ),
            ]
        ),
        Chapter(
            number: 7,
            title: "ネットワークと遠隔操作",
            summary: "SSH、curl で外部システムと連携",
            lessons: [
                Lesson(
                    title: "SSH - リモートサーバーに接続",
                    emoji: "🔒",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "安全にリモートサーバーを操作する",
                        sections: [
                            ConceptSection(
                                heading: "SSH の役割",
                                body: "SSH（Secure Shell）は、インターネット経由でリモートサーバーに安全に接続して、コマンドを実行するプロトコルです。\n\nネットワーク通信が暗号化されるため、盗聴や改ざんから保護されます。Telnet のような古いプロトコルとは異なり、SSH は本番環境やセキュリティが必要な場面で標準的に使われます。",
                                codeSample: "ssh user@example.com\n# example.com に user でログイン\nssh -i ~/.ssh/id_rsa user@example.com\n# SSH鍵を使用して接続",
                                tip: "SSH キー認証を設定すると、パスワード入力が不要になり、自動化スクリプトから安全に接続できます"
                            ),
                            ConceptSection(
                                heading: "SSH の接続方法",
                                body: "• ssh user@host: パスワード認証で接続\n• ssh -i keyfile user@host: SSH鍵で接続\n• ssh -p 2222 user@host: 非標準ポート（22以外）で接続\n• ssh -X user@host: X11 フォワーディング（GUI アプリ実行）\n\nSSH 鍵認証は以下の利点があります：\n• パスワード不要（スクリプト自動化が容易）\n• パスワード盗聴の心配がない\n• ブルートフォース攻撃に強い",
                                codeSample: nil,
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "SSH - リモート接続クエスト",
                    emoji: "🎯",
                    estimatedMinutes: 8,
                    content: .quest(QuestLesson(
                        scenario: "本番サーバー example.com にログインして、システムメンテナンスを行う必要があります。",
                        prompt: "example.com のリモートサーバーに user でログインするコマンドは？",
                        hint: "ssh user@example.com でログインできます。",
                        answer: "ssh",
                        options: [
                            CommandOption(label: "ssh", command: "ssh", icon: "network"),
                            CommandOption(label: "telnet", command: "telnet", icon: "square.connected.to.square"),
                            CommandOption(label: "ftp", command: "ftp", icon: "arrow.up.arrow.down"),
                        ],
                        simulatedOutput: "user@example.com:~$ ",
                        successMessage: "✅ リモートサーバーに接続されました"
                    ))
                ),
                Lesson(
                    title: "curl - Web API データ取得",
                    emoji: "📡",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "インターネットからデータを取得・送信",
                        sections: [
                            ConceptSection(
                                heading: "curl コマンドの役割",
                                body: "curl は、HTTP/HTTPS 通信でインターネットからデータを取得・送信するコマンドです。\n\nWeb ページのダウンロード、REST API との通信、ファイルのアップロード、ヘッダー情報の確認など、Web 関連の様々な操作ができます。API 統合やデータ取得の自動化に必須のツールです。",
                                codeSample: "curl https://api.example.com/users\n# JSON 形式のレスポンスを取得\ncurl -X POST -d '{\"name\":\"John\"}' https://api.example.com/users\n# POST リクエストを送信",
                                tip: "curl の出力を jq でパースすると、JSON データを見やすく整形・抽出できます"
                            ),
                            ConceptSection(
                                heading: "curl の基本的な使用方法",
                                body: "• curl URL: GET リクエストでページを取得\n• curl -X POST URL: POST リクエストを送信\n• curl -d 'data' URL: ボディデータを送信\n• curl -H 'Header: value' URL: ヘッダーを指定\n• curl -o file.txt URL: ファイルに保存\n• curl -i URL: レスポンスヘッダーも表示\n\n出力をパイプして jq に渡すことで、JSON の整形・フィルタリングができます。",
                                codeSample: "curl https://api.example.com/data | jq '.users[]'",
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "curl - API データ取得クエスト",
                    emoji: "🎯",
                    estimatedMinutes: 8,
                    content: .quest(QuestLesson(
                        scenario: "外部 API からユーザー情報を取得する必要があります。",
                        prompt: "https://api.example.com/users から JSON データを取得するコマンドは？",
                        hint: "curl https://api.example.com/users でデータを取得できます。",
                        answer: "curl",
                        options: [
                            CommandOption(label: "curl", command: "curl", icon: "arrow.down.doc"),
                            CommandOption(label: "wget", command: "wget", icon: "arrow.down.circle"),
                            CommandOption(label: "ssh", command: "ssh", icon: "network"),
                        ],
                        simulatedOutput: "{\"users\":[{\"id\":1,\"name\":\"Alice\"},{\"id\":2,\"name\":\"Bob\"}]}",
                        successMessage: "✅ API からデータが取得されました"
                    ))
                ),
                Lesson(
                    title: "ネットワークコマンド実践",
                    emoji: "🌐",
                    estimatedMinutes: 14,
                    content: .scenario(ScenarioLesson(
                        setup: "リモートサーバーに接続し、Web API からデータを取得します。",
                        goal: "SSH と curl の実務使用",
                        steps: [
                            ScenarioStep(
                                prompt: "リモートサーバー example.com に SSH で接続します。",
                                hint: "ssh user@example.com",
                                answer: "ssh",
                                options: [
                                    CommandOption(label: "ssh", command: "ssh", icon: "network"),
                                    CommandOption(label: "telnet", command: "telnet", icon: "square.connected.to.square"),
                                    CommandOption(label: "curl", command: "curl", icon: "arrow.down.doc"),
                                ],
                                simulatedOutput: "The authenticity of host 'example.com' can't be established.\nRSA key fingerprint is...\nuser@example.com's password:\nuser@example.com:~$"
                            ),
                            ScenarioStep(
                                prompt: "API エンドポイント https://api.example.com/data からデータを取得します。",
                                hint: "curl https://api.example.com/data",
                                answer: "curl",
                                options: [
                                    CommandOption(label: "curl", command: "curl", icon: "arrow.down.doc"),
                                    CommandOption(label: "wget", command: "wget", icon: "arrow.down.circle"),
                                    CommandOption(label: "ssh", command: "ssh", icon: "network"),
                                ],
                                simulatedOutput: "{\"status\":\"success\",\"data\":[{\"id\":1,\"name\":\"Item 1\"}]}"
                            ),
                            ScenarioStep(
                                prompt: "JSON データを jq で整形表示します。",
                                hint: "curl https://api.example.com/data | jq",
                                answer: "jq",
                                options: [
                                    CommandOption(label: "jq", command: "jq", icon: "square.and.pencil"),
                                    CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
                                    CommandOption(label: "cat", command: "cat", icon: "doc.text"),
                                ],
                                simulatedOutput: "{\n  \"status\": \"success\",\n  \"data\": [\n    {\n      \"id\": 1,\n      \"name\": \"Item 1\"\n    }\n  ]\n}"
                            ),
                        ],
                        finaleMessage: "✅ ネットワーク操作のプロになりました！"
                    ))
                ),
                Lesson(
                    title: "ネットワーク・セキュリティクイズ",
                    emoji: "🔒",
                    estimatedMinutes: 12,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "SSH 接続時に「Host key verification failed」エラーが表示された。最も可能性が高い原因は？",
                                choices: [
                                    "~/.ssh/known_hosts の記録と実際のサーバーの公開鍵が異なる（OS 再インストールや MITM 攻撃の可能性）",
                                    "パスワードが間違っている",
                                    "SSH サーバーが停止している",
                                    "ネットワークが切断されている"
                                ],
                                correctIndex: 0,
                                explanation: "SSH は最初の接続時にサーバーの公開鍵を ~/.ssh/known_hosts に保存します。次回以降、保存した鍵と異なる場合に警告が出ます。サーバーの OS 再インストール後によく発生します。ssh-keygen -R hostname でエントリを削除してから再接続できます。一方、予期しない変更は中間者攻撃（MITM）のサインである場合もあります。"
                            ),
                            QuizQuestion(
                                question: "curl で HTTP POST リクエストを送り、JSON データを含めるコマンドはどれか？",
                                choices: [
                                    "curl -X POST -H 'Content-Type: application/json' -d '{\"key\":\"value\"}' https://api.example.com",
                                    "curl POST https://api.example.com -json '{\"key\":\"value\"}'",
                                    "curl --post '{\"key\":\"value\"}' https://api.example.com",
                                    "curl -r https://api.example.com '{\"key\":\"value\"}'"
                                ],
                                correctIndex: 0,
                                explanation: "-X POST でメソッドを指定、-H でヘッダーを付加、-d でリクエストボディを指定します。Content-Type: application/json を指定しないとサーバーが JSON と認識しない場合があります。実務での API テストや自動化で頻出のパターンです。"
                            ),
                            QuizQuestion(
                                question: "ssh -L 8080:localhost:3306 user@db-server.example.com の意味は？",
                                choices: [
                                    "ローカルの 8080 番ポートを db-server の 3306 番（MySQL）にフォワーディング",
                                    "リモートサーバーのポート 8080 を開放する",
                                    "SSH 接続を 8080 番ポートで確立する",
                                    "ポート 8080 でリモートサーバーを起動する"
                                ],
                                correctIndex: 0,
                                explanation: "ssh -L はローカルポートフォワーディングです。-L 8080:localhost:3306 は「ローカルの 8080 番へのアクセスを、SSHトンネル経由でリモートサーバーの 3306 番に転送」します。ファイアウォールで直接アクセスできないデータベースに安全に接続するために使われます。"
                            ),
                        ]
                    ))
                ),
            ]
        ),
    ]
)

// MARK: - Expert/Professional Course 1 - User and Group Management
let expertCourse1 = Course(
    level: .expert,
    title: "ユーザー・グループ管理と権限制御",
    subtitle: "複雑な権限体系をマスター",
    description: "ユーザー・グループの作成・管理、sudo 権限、高度な権限設定を学ぶ",
    emoji: "👥",
    estimatedMinutes: 150,
    chapters: [
        Chapter(
            number: 8,
            title: "ユーザーとグループの基礎",
            summary: "useradd, groupadd, id, su, sudo の実践",
            lessons: [
                Lesson(
                    title: "ユーザーとグループの概念",
                    emoji: "👥",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "Linux のマルチユーザー構造を理解",
                        sections: [
                            ConceptSection(
                                heading: "ユーザーとグループの役割",
                                body: "Linux はマルチユーザー・マルチタスク OS です。複数のユーザーが同時にシステムを利用できます。\n\n各ユーザーには：\n• UID（ユーザーID）: ユーザーを一意に識別する数値\n• GID（グループID）: ユーザーが属するグループの識別番号\n• ホームディレクトリ: ユーザー専用のファイル保存領域\n\nグループにより、複数ユーザーでのファイル共有や権限管理が容易になります。",
                                codeSample: "id\n# uid=1000(user) gid=1000(user) groups=1000(user),4(adm)",
                                tip: "UID 0 は root（スーパーユーザー）で、管理者権限を持ちます"
                            ),
                            ConceptSection(
                                heading: "ユーザー・グループ管理コマンド",
                                body: "• useradd: ユーザー作成\n• usermod: ユーザー情報修正\n• userdel: ユーザー削除\n• groupadd: グループ作成\n• groupdel: グループ削除\n• id: 現在のユーザーID・グループID確認\n• whoami: 現在のユーザー名確認\n• su: ユーザー切り替え\n• sudo: 管理者権限でコマンド実行",
                                codeSample: "sudo useradd -m newuser\n# -m: ホームディレクトリを作成\nsudo usermod -aG sudo newuser\n# -a: 既存グループに追加\n# -G: グループを指定",
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "ユーザー情報の確認",
                    emoji: "🔍",
                    estimatedMinutes: 10,
                    content: .quest(QuestLesson(
                        scenario: "現在のユーザー情報を確認する必要があります。",
                        prompt: "現在のユーザーID、グループID、所属グループを確認するコマンドは？",
                        hint: "id コマンドを使用します",
                        answer: "id",
                        options: [
                            CommandOption(label: "id", command: "id", icon: "person.crop.circle"),
                            CommandOption(label: "whoami", command: "whoami", icon: "person.fill"),
                            CommandOption(label: "groups", command: "groups", icon: "person.2.fill"),
                        ],
                        simulatedOutput: "uid=1000(user) gid=1000(user) groups=1000(user),4(adm),27(sudo)",
                        successMessage: "✅ ユーザー情報が確認できました"
                    ))
                ),
                Lesson(
                    title: "ユーザー作成のシナリオ",
                    emoji: "➕",
                    estimatedMinutes: 15,
                    content: .scenario(ScenarioLesson(
                        setup: "新しいシステムユーザーを作成します。",
                        goal: "useradd で段階的にユーザーを管理",
                        steps: [
                            ScenarioStep(
                                prompt: "新しいユーザー appuser を作成します（ホームディレクトリ付き）",
                                hint: "sudo useradd -m appuser",
                                answer: "useradd",
                                options: [
                                    CommandOption(label: "useradd", command: "useradd", icon: "person.badge.plus"),
                                    CommandOption(label: "adduser", command: "adduser", icon: "person.badge.plus"),
                                    CommandOption(label: "usermod", command: "usermod", icon: "person.fill"),
                                ],
                                simulatedOutput: "root@linux:~# useradd -m appuser\nroot@linux:~#"
                            ),
                            ScenarioStep(
                                prompt: "appuser のパスワードを設定します。",
                                hint: "sudo passwd appuser",
                                answer: "passwd",
                                options: [
                                    CommandOption(label: "passwd", command: "passwd", icon: "lock"),
                                    CommandOption(label: "usermod", command: "usermod", icon: "person.fill"),
                                    CommandOption(label: "chpasswd", command: "chpasswd", icon: "key"),
                                ],
                                simulatedOutput: "root@linux:~# passwd appuser\nNew password: \nRetype password:"
                            ),
                            ScenarioStep(
                                prompt: "appuser を sudo グループに追加します。",
                                hint: "sudo usermod -aG sudo appuser",
                                answer: "usermod",
                                options: [
                                    CommandOption(label: "usermod", command: "usermod", icon: "person.fill"),
                                    CommandOption(label: "addgroup", command: "addgroup", icon: "person.2.plus"),
                                    CommandOption(label: "gpasswd", command: "gpasswd", icon: "lock.open"),
                                ],
                                simulatedOutput: "root@linux:~# usermod -aG sudo appuser"
                            ),
                        ],
                        finaleMessage: "✅ ユーザー管理のマスター！"
                    ))
                ),
                Lesson(
                    title: "ユーザー管理の深掘りテスト",
                    emoji: "🎯",
                    estimatedMinutes: 12,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "usermod -G sudo alice を実行した（-a なし）。何が起きるか？",
                                choices: [
                                    "alice の追加グループが sudo のみに上書きされる（既存の他のグループから外れる）",
                                    "alice が sudo グループに追加される（既存グループは維持）",
                                    "エラーになる",
                                    "sudo グループが削除される"
                                ],
                                correctIndex: 0,
                                explanation: "-G のみではグループリストが上書きされます。alice が以前 developers や docker グループにも属していた場合、-G sudo だけで実行すると sudo 以外のグループから全て外れます。既存グループを保持しつつ追加するには必ず -a と組み合わせて -aG を使います。これは実務でよくある落とし穴です。"
                            ),
                            QuizQuestion(
                                question: "/etc/passwd の各フィールドの順序と意味は？\n\nalice:x:1001:1001:Alice Smith:/home/alice:/bin/bash",
                                choices: [
                                    "ユーザー名:パスワード(x=シャドウ化):UID:GID:GECOS(コメント):ホームディレクトリ:デフォルトシェル",
                                    "ユーザー名:実パスワード:GID:UID:ホームディレクトリ:シェル:コメント",
                                    "UID:GID:ユーザー名:パスワード:シェル:ホームディレクトリ:コメント",
                                    "ユーザー名:UID:GID:パスワード:ホームディレクトリ:シェル:有効期限"
                                ],
                                correctIndex: 0,
                                explanation: "/etc/passwd の形式: ユーザー名:パスワード:UID:GID:GECOS:ホームディレクトリ:シェル。パスワードフィールドの x はパスワードが /etc/shadow に分離管理されていることを示します（セキュリティ強化）。/etc/shadow は root のみが読めます。"
                            ),
                            QuizQuestion(
                                question: "su - alice と su alice の動作の違いは？",
                                choices: [
                                    "su - alice はログインシェルを起動し alice の環境変数を完全に引き継ぐ。su alice は現在の環境変数を保持したまま alice に切り替える",
                                    "どちらも同じ動作",
                                    "su - alice は root のみ実行可能",
                                    "su alice はパスワードが不要"
                                ],
                                correctIndex: 0,
                                explanation: "su - はログインシェル（login shell）として切り替えるため、ホームディレクトリへの移動・環境変数の初期化・シェル設定ファイルの読み込みが行われます。su のみは非ログインシェルで、現在の環境変数が引き継がれます。本番環境での作業やデバッグには su - を使う方が環境の差異によるトラブルを防げます。"
                            ),
                        ]
                    ))
                ),
            ]
        ),
    ]
)

// MARK: - Expert/Professional Course 2 - Package Management & System Administration
let expertCourse2 = Course(
    level: .expert,
    title: "パッケージ管理とシステム管理",
    subtitle: "ソフトウェア管理とサービス制御",
    description: "apt/yum によるパッケージ管理、systemctl によるサービス制御を学ぶ",
    emoji: "📦",
    estimatedMinutes: 150,
    chapters: [
        Chapter(
            number: 9,
            title: "パッケージ管理システム",
            summary: "apt, yum, dpkg, rpm を使いこなす",
            lessons: [
                Lesson(
                    title: "パッケージ管理コマンド入門",
                    emoji: "📥",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "Linux のパッケージ管理",
                        sections: [
                            ConceptSection(
                                heading: "主要なパッケージマネージャー",
                                body: "Debian/Ubuntu: apt, dpkg\nRed Hat/CentOS: yum, rpm\n\n• apt: 高レベルのパッケージマネージャー（依存関係自動解決）\n• dpkg: 低レベルのパッケージマネージャー（Debian パッケージ）\n• yum: Red Hat 系のパッケージマネージャー\n• rpm: Red Hat パッケージ形式",
                                codeSample: nil,
                                tip: "apt は yum と異なり、Ubuntu/Debian 系で使用。yum は CentOS/RHEL で使用"
                            ),
                            ConceptSection(
                                heading: "apt の基本コマンド",
                                body: "apt update: パッケージリスト更新\napt upgrade: インストール済みパッケージを更新\napt install パッケージ名: パッケージをインストール\napt remove パッケージ名: パッケージを削除\napt search キーワード: パッケージを検索",
                                codeSample: "apt update && apt upgrade -y",
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "apt による実務パッケージ管理",
                    emoji: "⚙️",
                    estimatedMinutes: 15,
                    content: .scenario(ScenarioLesson(
                        setup: "Linux システムを最新に保ち、必要なパッケージをインストールします。",
                        goal: "apt で段階的にパッケージを管理",
                        steps: [
                            ScenarioStep(
                                prompt: "パッケージリストを最新に更新します。",
                                hint: "sudo apt update",
                                answer: "update",
                                options: [
                                    CommandOption(label: "update", command: "update", icon: "arrow.clockwise"),
                                    CommandOption(label: "upgrade", command: "upgrade", icon: "arrow.up"),
                                    CommandOption(label: "install", command: "install", icon: "plus.circle"),
                                ],
                                simulatedOutput: "Reading package lists... Done\nBuilding dependency tree... Done\n0 upgraded, 0 newly installed"
                            ),
                            ScenarioStep(
                                prompt: "curl コマンドをインストールします（まだインストールされていない場合）",
                                hint: "sudo apt install curl -y",
                                answer: "install",
                                options: [
                                    CommandOption(label: "install", command: "install", icon: "plus.circle"),
                                    CommandOption(label: "update", command: "update", icon: "arrow.clockwise"),
                                    CommandOption(label: "search", command: "search", icon: "magnifyingglass"),
                                ],
                                simulatedOutput: "Reading package lists... Done\nSetting up curl (7.68.0-1) ...\nProcessing triggers"
                            ),
                            ScenarioStep(
                                prompt: "インストール済みパッケージを確認します。",
                                hint: "apt list --installed | grep curl",
                                answer: "apt list",
                                options: [
                                    CommandOption(label: "apt list", command: "apt list", icon: "list.bullet"),
                                    CommandOption(label: "dpkg", command: "dpkg", icon: "list.dash"),
                                    CommandOption(label: "which", command: "which", icon: "magnifyingglass"),
                                ],
                                simulatedOutput: "curl/focal,now 7.68.0-1ubuntu1.14 amd64 [installed]"
                            ),
                        ],
                        finaleMessage: "✅ パッケージ管理のプロ！"
                    ))
                ),
            ]
        ),
        Chapter(
            number: 10,
            title: "systemd とサービス管理",
            summary: "systemctl でサービスを制御",
            lessons: [
                Lesson(
                    title: "systemd とサービスの基本",
                    emoji: "⚙️",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "Linux サービスの生命サイクル管理",
                        sections: [
                            ConceptSection(
                                heading: "systemd とは",
                                body: "systemd はモダンな Linux 初期化システムで、システム起動時にサービスを管理し、実行時にもサービス制御を行います。\n\n従来の SysVinit に代わり、並列起動による高速ブート、サービス間の依存関係管理、自動再起動などの機能を提供します。ほぼ全ての現代的な Linux ディストリビューションで標準採用されています。",
                                codeSample: "systemctl status nginx\n# サービスの状態確認\nsystemctl start nginx\n# サービス開始",
                                tip: "systemctl は /etc/systemd/system/ のユニットファイルを読み込んでサービスを管理します"
                            ),
                            ConceptSection(
                                heading: "主要な systemctl コマンド",
                                body: "• systemctl start サービス名: サービスを開始\n• systemctl stop サービス名: サービスを停止\n• systemctl restart サービス名: サービスを再起動\n• systemctl reload サービス名: 設定を再読み込み\n• systemctl status サービス名: サービスの状態確認\n• systemctl enable サービス名: 起動時に自動実行\n• systemctl disable サービス名: 自動実行を無効化\n• systemctl list-units --type=service: 全サービスリスト",
                                codeSample: "sudo systemctl enable nginx\n# 起動時に nginx を自動実行\nsudo systemctl reload nginx\n# 設定変更後に再読み込み",
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "systemctl コマンドの実践",
                    emoji: "🔧",
                    estimatedMinutes: 12,
                    content: .scenario(ScenarioLesson(
                        setup: "Web サーバーなどのサービスをシステムレベルで管理します。",
                        goal: "systemctl で段階的にサービスを制御",
                        steps: [
                            ScenarioStep(
                                prompt: "nginx サービスが実行中か確認します。",
                                hint: "sudo systemctl status nginx",
                                answer: "status",
                                options: [
                                    CommandOption(label: "status", command: "status", icon: "checkmark.circle"),
                                    CommandOption(label: "start", command: "start", icon: "play.fill"),
                                    CommandOption(label: "stop", command: "stop", icon: "stop.fill"),
                                ],
                                simulatedOutput: "● nginx.service - A high performance web server\n   Loaded: loaded (/lib/systemd/system/nginx.service)\n   Active: active (running)"
                            ),
                            ScenarioStep(
                                prompt: "nginx を再起動します。",
                                hint: "sudo systemctl restart nginx",
                                answer: "restart",
                                options: [
                                    CommandOption(label: "restart", command: "restart", icon: "arrow.clockwise"),
                                    CommandOption(label: "reload", command: "reload", icon: "goforward"),
                                    CommandOption(label: "start", command: "start", icon: "play.fill"),
                                ],
                                simulatedOutput: "root@linux:~# systemctl restart nginx"
                            ),
                            ScenarioStep(
                                prompt: "nginx をシステム起動時に自動開始するよう設定します。",
                                hint: "sudo systemctl enable nginx",
                                answer: "enable",
                                options: [
                                    CommandOption(label: "enable", command: "enable", icon: "checkmark.square"),
                                    CommandOption(label: "disable", command: "disable", icon: "xmark.square"),
                                    CommandOption(label: "start", command: "start", icon: "play.fill"),
                                ],
                                simulatedOutput: "Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service"
                            ),
                        ],
                        finaleMessage: "✅ サービス管理のエキスパート！"
                    ))
                ),
                Lesson(
                    title: "systemd 深掘りクイズ",
                    emoji: "🎓",
                    estimatedMinutes: 12,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "systemctl enable nginx を実行したが、nginx は起動していない。なぜか？",
                                choices: [
                                    "enable は次回起動時の自動実行を設定するだけ。現時点での起動には systemctl start が別途必要",
                                    "enable はサービスを開始する",
                                    "nginx がインストールされていない",
                                    "enable の後は自動的に起動する"
                                ],
                                correctIndex: 0,
                                explanation: "enable は「次回のシステム起動時に自動実行するよう登録」する設定で、即座にサービスを起動しません。現在のセッションでも起動したい場合は systemctl enable --now nginx または systemctl enable nginx && systemctl start nginx のようにします。enable と start の役割の違いは重要な概念です。"
                            ),
                            QuizQuestion(
                                question: "nginx の設定ファイルを編集した後、設定を適用するために最も適切なコマンドはどれか？",
                                choices: [
                                    "設定検証後 systemctl reload nginx（ダウンタイムなし）、不可能なら systemctl restart",
                                    "systemctl stop nginx && systemctl start nginx",
                                    "systemctl status nginx",
                                    "systemctl daemon-reload"
                                ],
                                correctIndex: 0,
                                explanation: "本番環境では reload が最善です。nginx -t で設定の文法チェックをしてから reload すると安全です。reload は設定ファイルを再読み込みしつつ既存の接続を維持します（グレースフルリロード）。restart は全接続が一時切断されるためダウンタイムが発生します。daemon-reload は systemd のユニットファイル（.service ファイル）を変更したときに必要です。"
                            ),
                            QuizQuestion(
                                question: "systemctl status nginx の出力で「Active: failed (Result: exit-code)」と表示された。次に何を確認すべきか？",
                                choices: [
                                    "journalctl -u nginx -n 50 でサービスのログを確認する",
                                    "systemctl enable nginx を再実行する",
                                    "nginx をアンインストールして再インストールする",
                                    "サーバーを再起動する"
                                ],
                                correctIndex: 0,
                                explanation: "failed 状態はサービスが起動に失敗したことを示します。journalctl -u nginx でサービス固有のログ、-n 50 で直近50行を表示できます。-e オプションで末尾（最新ログ）から確認します。設定ファイルのミス、ポートの競合、依存サービスの問題などが原因として多いです。"
                            ),
                        ]
                    ))
                ),
            ]
        ),
    ]
)

// MARK: - Expert/Professional Course 3 - Advanced Networking and Filesystem
let expertCourse3 = Course(
    level: .expert,
    title: "ネットワーク設定とファイルシステム管理",
    subtitle: "ネットワークとストレージの実務管理",
    description: "ネットワーク設定、パーティション管理、ログ管理を学ぶ",
    emoji: "🌐",
    estimatedMinutes: 150,
    chapters: [
        Chapter(
            number: 11,
            title: "ネットワーク設定とトラブルシューティング",
            summary: "ip, ifconfig, ping, hostname などを使いこなす",
            lessons: [
                Lesson(
                    title: "ネットワークの基本概念",
                    emoji: "🌐",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "Linux ネットワーク設定を理解する",
                        sections: [
                            ConceptSection(
                                heading: "ネットワークインターフェース",
                                body: "Linux では、各ネットワークインターフェース（NIC）に IP アドレス、サブネットマスク、ゲートウェイなどの設定が必要です。\n\n• eth0, eth1: 有線ネットワークインターフェース（Ethernet）\n• lo: ループバックインターフェース（localhost, 127.0.0.1）\n• IPv4: 従来のインターネットプロトコル（例: 192.168.1.100）\n• IPv6: 次世代プロトコル（例: fe80::1）\n\nネットワーク診断では、IP アドレス、ルーティング情報、開放ポートなどを確認します。",
                                codeSample: "ip addr show\n# 全ネットワークインターフェースと IP アドレス確認\nip route show\n# ルーティング情報確認",
                                tip: "ip コマンドが最新の推奨方式。ifconfig は古いコマンドで、いくつかのディストリビューションでは非推奨"
                            ),
                            ConceptSection(
                                heading: "ネットワーク診断コマンド",
                                body: "• ping: ホストの疎通確認（ICMP エコー）\n• traceroute: ネットワーク経路の可視化\n• netstat/ss: ネットワークソケットの接続状態確認\n• nslookup/dig: DNS 名前解決確認\n• curl/wget: HTTP 通信テスト\n• iptables/ufw: ファイアウォール設定\n\n自サーバーに SSH で接続できない場合：\n1. ping でネットワーク接続確認\n2. netstat で SSH ポート確認\n3. ファイアウォール設定確認",
                                codeSample: "ping -c 4 8.8.8.8\ntraceroute example.com\nnetstat -tuln | grep LISTEN",
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "ネットワークインターフェース確認",
                    emoji: "🖧",
                    estimatedMinutes: 10,
                    content: .quest(QuestLesson(
                        scenario: "サーバーのネットワーク設定を確認する必要があります。",
                        prompt: "システムのネットワークインターフェースと IP アドレスを確認するコマンドは？",
                        hint: "ip addr show または ip a",
                        answer: "ip",
                        options: [
                            CommandOption(label: "ip addr show", command: "ip", icon: "globe"),
                            CommandOption(label: "ifconfig", command: "ifconfig", icon: "network"),
                            CommandOption(label: "hostname", command: "hostname", icon: "host.rectangle"),
                        ],
                        simulatedOutput: "1: lo: <LOOPBACK> mtu 65536\n2: eth0: <BROADCAST,MULTICAST,UP> mtu 1500\n    inet 192.168.1.100/24",
                        successMessage: "✅ ネットワーク設定が確認できました"
                    ))
                ),
                Lesson(
                    title: "ネットワークトラブルシューティング",
                    emoji: "🔌",
                    estimatedMinutes: 15,
                    content: .scenario(ScenarioLesson(
                        setup: "リモートサーバーのネットワーク接続を診断します。",
                        goal: "ping, traceroute, netstat でネットワーク診断",
                        steps: [
                            ScenarioStep(
                                prompt: "8.8.8.8（Google DNS）への通信を確認します。",
                                hint: "ping -c 4 8.8.8.8",
                                answer: "ping",
                                options: [
                                    CommandOption(label: "ping", command: "ping", icon: "radio.fill"),
                                    CommandOption(label: "traceroute", command: "traceroute", icon: "arrow.uturn.right"),
                                    CommandOption(label: "nc", command: "nc", icon: "network"),
                                ],
                                simulatedOutput: "PING 8.8.8.8 (8.8.8.8) 56(84) bytes\nfrom 8.8.8.8: icmp_seq=1 ttl=119 time=20.5 ms\n4 packets received, 0% packet loss"
                            ),
                            ScenarioStep(
                                prompt: "特定のホストへのルート経路を確認します。",
                                hint: "traceroute example.com",
                                answer: "traceroute",
                                options: [
                                    CommandOption(label: "traceroute", command: "traceroute", icon: "arrow.uturn.right"),
                                    CommandOption(label: "ping", command: "ping", icon: "radio.fill"),
                                    CommandOption(label: "route", command: "route", icon: "arrow.left.arrow.right"),
                                ],
                                simulatedOutput: "traceroute to example.com (93.184.216.34)\n 1  gateway.local (192.168.1.1)  1.23 ms\n 2  isp-router (203.0.113.1)  5.45 ms"
                            ),
                            ScenarioStep(
                                prompt: "ネットワークソケットの接続状態を確認します。",
                                hint: "netstat -tuln",
                                answer: "netstat",
                                options: [
                                    CommandOption(label: "netstat", command: "netstat", icon: "chart.bar"),
                                    CommandOption(label: "ss", command: "ss", icon: "square.grid.2x2"),
                                    CommandOption(label: "lsof", command: "lsof", icon: "list.bullet"),
                                ],
                                simulatedOutput: "LISTEN 0 128 0.0.0.0:22 0.0.0.0:*\nLISTEN 0 511 0.0.0.0:80 0.0.0.0:*"
                            ),
                        ],
                        finaleMessage: "✅ ネットワーク診断のマスター！"
                    ))
                ),
            ]
        ),
        Chapter(
            number: 12,
            title: "ストレージとログ管理",
            summary: "df, du, mount, journalctl を使いこなす",
            lessons: [
                Lesson(
                    title: "ディスクとログ管理の基礎",
                    emoji: "📝",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "ストレージとログでシステムを監視管理する",
                        sections: [
                            ConceptSection(
                                heading: "ディスク使用量の管理",
                                body: "Linux システムでは、ディスク容量が満杯になるとシステム停止につながる深刻な障害になります。定期的な監視と不要なファイルの削除が重要です。\n\n• df: ファイルシステムの容量表示（全体的な状況）\n• du: ディレクトリのサイズ表示（詳細な容量確認）\n• mount: ファイルシステムのマウント状態確認\n\nディスクを圧迫している要因：\n• ログファイルの肥大化\n• キャッシュの蓄積\n• 古いバックアップファイル\n• テンポラリファイル",
                                codeSample: "df -h\n# 全ファイルシステムの容量確認（人間が読みやすいフォーマット）\ndu -sh /var/log\n# /var/log ディレクトリのサイズ確認",
                                tip: "-h オプションは \"human-readable\" の意で、容量を GB、MB で表示します"
                            ),
                            ConceptSection(
                                heading: "ログ管理とシステム監視",
                                body: "• journalctl: systemd ジャーナルの確認（最新のディストリビューション）\n• tail -f: ログファイルのリアルタイム監視\n• logrotate: ログファイルの自動ローテーション（古いログを圧縮・削除）\n• /var/log: システムログの標準保存場所\n\nログ分析の例：\n• エラーログ: アプリケーションの問題検出\n• アクセスログ: セキュリティ監視\n• システムログ: 起動シーケンス、デバイス情報\n\nLogrotate により、ログファイルが自動的に古い順に削除され、容量爆発を防ぎます。",
                                codeSample: "journalctl -u nginx\n# nginx サービスのジャーナル確認\ntail -f /var/log/syslog\n# システムログをリアルタイム監視",
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "ディスク容量の管理",
                    emoji: "💾",
                    estimatedMinutes: 12,
                    content: .scenario(ScenarioLesson(
                        setup: "ディスク容量を監視し、不要なファイルを削除します。",
                        goal: "df, du で段階的にディスク使用量を分析",
                        steps: [
                            ScenarioStep(
                                prompt: "すべてのファイルシステムのディスク使用率を確認します。",
                                hint: "df -h",
                                answer: "df",
                                options: [
                                    CommandOption(label: "df", command: "df", icon: "harddrive"),
                                    CommandOption(label: "du", command: "du", icon: "chart.pie"),
                                    CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                ],
                                simulatedOutput: "Filesystem      Size  Used Avail Use% Mounted on\n/dev/sda1       100G   50G   50G  50% /"
                            ),
                            ScenarioStep(
                                prompt: "ホームディレクトリの中で最も容量を使っているディレクトリを探します。",
                                hint: "du -sh ~/*",
                                answer: "du",
                                options: [
                                    CommandOption(label: "du", command: "du", icon: "chart.pie"),
                                    CommandOption(label: "find", command: "find", icon: "magnifyingglass"),
                                    CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                ],
                                simulatedOutput: "20G\t./Downloads\n5.2G\t./Documents\n1.5G\t./Pictures"
                            ),
                            ScenarioStep(
                                prompt: "古いログファイルを確認し、削除対象を特定します。",
                                hint: "find /var/log -type f -mtime +30",
                                answer: "find",
                                options: [
                                    CommandOption(label: "find", command: "find", icon: "magnifyingglass"),
                                    CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                    CommandOption(label: "tail", command: "tail", icon: "text.alignleft"),
                                ],
                                simulatedOutput: "/var/log/auth.log.1\n/var/log/syslog.1\n/var/log/nginx/access.log.2"
                            ),
                        ],
                        finaleMessage: "✅ ディスク管理のエキスパート！"
                    ))
                ),
                Lesson(
                    title: "ログ管理とシステムログ",
                    emoji: "📝",
                    estimatedMinutes: 12,
                    content: .scenario(ScenarioLesson(
                        setup: "システムログを監視し、エラーを特定します。",
                        goal: "journalctl, tail でログを分析",
                        steps: [
                            ScenarioStep(
                                prompt: "システムジャーナルの最新エントリを表示します。",
                                hint: "journalctl -n 20",
                                answer: "journalctl",
                                options: [
                                    CommandOption(label: "journalctl", command: "journalctl", icon: "doc.text.magnifyingglass"),
                                    CommandOption(label: "tail", command: "tail", icon: "text.alignleft"),
                                    CommandOption(label: "dmesg", command: "dmesg", icon: "speaker.wave.2"),
                                ],
                                simulatedOutput: "May 11 10:23:45 server kernel: [1234.567] CPU0: Package temperature WARNING\nMay 11 10:24:01 server systemd[1]: Started Session c1"
                            ),
                            ScenarioStep(
                                prompt: "特定のサービス（nginx）のログのみを表示します。",
                                hint: "journalctl -u nginx -n 10",
                                answer: "journalctl",
                                options: [
                                    CommandOption(label: "journalctl", command: "journalctl", icon: "doc.text.magnifyingglass"),
                                    CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
                                    CommandOption(label: "tail", command: "tail", icon: "text.alignleft"),
                                ],
                                simulatedOutput: "May 11 10:25:30 server nginx[1234]: Connection from 192.168.1.50 port 54321\nMay 11 10:25:35 server nginx[1234]: HTTP/1.1 200 OK"
                            ),
                            ScenarioStep(
                                prompt: "今日のエラーレベルのログのみを表示します。",
                                hint: "journalctl -p err -S today",
                                answer: "journalctl",
                                options: [
                                    CommandOption(label: "journalctl", command: "journalctl", icon: "doc.text.magnifyingglass"),
                                    CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
                                    CommandOption(label: "tail", command: "tail", icon: "text.alignleft"),
                                ],
                                simulatedOutput: "May 11 11:45:23 server sshd[5678]: Invalid user admin from 192.168.1.100\nMay 11 12:10:11 server kernel: Out of memory"
                            ),
                        ],
                        finaleMessage: "✅ ログ分析のプロになりました！"
                    ))
                ),
            ]
        ),
    ]
)

// MARK: - Expert/Professional Course 4 - Process Management and Performance
let expertCourse4 = Course(
    level: .expert,
    title: "プロセス管理とシステムパフォーマンス",
    subtitle: "プロセス制御と監視を極める",
    description: "ps, top, kill, bg, fg によるプロセス管理とパフォーマンス監視を学ぶ",
    emoji: "⚡",
    estimatedMinutes: 120,
    chapters: [
        Chapter(
            number: 13,
            title: "プロセスの確認と制御",
            summary: "ps, top, kill でプロセスを管理",
            lessons: [
                Lesson(
                    title: "プロセス管理の基礎",
                    emoji: "⚙️",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "Linux のプロセスと実行管理",
                        sections: [
                            ConceptSection(
                                heading: "プロセスとは",
                                body: "プロセスは、実行中のプログラムのインスタンスです。各プロセスには：\n\n• PID（プロセスID）: プロセスを一意に識別する数値\n• PPID（親プロセスID）: プロセスを起動した親プロセスの ID\n• UID/GID: プロセスを実行しているユーザーとグループ\n• 状態: Running（実行中）、Sleeping（待機中）、Zombie（終了待ち）など\n\nシステム上では多数のプロセスが同時実行され、CPU がタイムスライスで各プロセスに機会を提供（マルチタスキング）します。",
                                codeSample: "ps aux\n# 全プロセスをリスト表示\ntop\n# CPU、メモリ使用率でリアルタイム監視",
                                tip: "初期化プロセス（PID 1）がシステムの最初のプロセスで、他の全プロセスの祖先です"
                            ),
                            ConceptSection(
                                heading: "プロセス管理コマンド",
                                body: "• ps: プロセスのスナップショット表示\n• top: リアルタイムプロセス監視\n• kill: プロセスにシグナルを送信\n• bg/fg: バックグラウンド/フォアグラウンドで実行\n• jobs: シェルのジョブリスト表示\n\nシグナルの種類：\n• SIGTERM（-15）: 正常終了要求（プロセスがキャッチ可能）\n• SIGKILL（-9）: 強制終了（プロセスがキャッチ不可）\n• SIGSTOP（-19）: 一時停止\n• SIGCONT（-18）: 再開\n\n手順：まず SIGTERM で正常終了を試み、応答なければ SIGKILL で強制終了します。",
                                codeSample: "kill -15 1234\n# PID 1234 に終了シグナル\nkillall java\n# プロセス名を指定して全インスタンス終了",
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "実行中のプロセス確認",
                    emoji: "🏃",
                    estimatedMinutes: 10,
                    content: .quest(QuestLesson(
                        scenario: "システムで実行中のプロセスを確認する必要があります。",
                        prompt: "全プロセスを詳細表示するコマンドは？",
                        hint: "ps aux で全プロセスをリスト表示",
                        answer: "ps",
                        options: [
                            CommandOption(label: "ps aux", command: "ps", icon: "rectangle.stack"),
                            CommandOption(label: "top", command: "top", icon: "chart.bar.fill"),
                            CommandOption(label: "jobs", command: "jobs", icon: "briefcase.fill"),
                        ],
                        simulatedOutput: "USER  PID %CPU %MEM VSZ RSS COMMAND\nroot  1   0.0  0.1 225504 9616 /sbin/init\nuser 1234 0.5  2.3 1234567 89012 python script.py",
                        successMessage: "✅ プロセス一覧が確認できました"
                    ))
                ),
                Lesson(
                    title: "プロセス管理の実務シナリオ",
                    emoji: "🛑",
                    estimatedMinutes: 14,
                    content: .scenario(ScenarioLesson(
                        setup: "暴走したプロセスを特定し、適切に終了します。",
                        goal: "ps, kill で段階的にプロセスを制御",
                        steps: [
                            ScenarioStep(
                                prompt: "特定のユーザーが実行しているプロセスをリスト表示します。",
                                hint: "ps -u username",
                                answer: "ps",
                                options: [
                                    CommandOption(label: "ps", command: "ps", icon: "rectangle.stack"),
                                    CommandOption(label: "top", command: "top", icon: "chart.bar.fill"),
                                    CommandOption(label: "pgrep", command: "pgrep", icon: "magnifyingglass"),
                                ],
                                simulatedOutput: "PID TTY STAT TIME COMMAND\n1234 ? S 0:05 /usr/bin/python script.py\n1235 ? R 5:23 stress-test-app"
                            ),
                            ScenarioStep(
                                prompt: "stress-test-app（PID 1235）を検索します。",
                                hint: "pgrep -f stress-test-app",
                                answer: "pgrep",
                                options: [
                                    CommandOption(label: "pgrep", command: "pgrep", icon: "magnifyingglass"),
                                    CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
                                    CommandOption(label: "pidof", command: "pidof", icon: "number"),
                                ],
                                simulatedOutput: "1235"
                            ),
                            ScenarioStep(
                                prompt: "プロセス 1235 に終了シグナルを送ります。",
                                hint: "kill -15 1235",
                                answer: "kill",
                                options: [
                                    CommandOption(label: "kill", command: "kill", icon: "xmark.circle"),
                                    CommandOption(label: "killall", command: "killall", icon: "xmark.circle.fill"),
                                    CommandOption(label: "pkill", command: "pkill", icon: "xmark"),
                                ],
                                simulatedOutput: "user@linux:~$ kill -15 1235"
                            ),
                        ],
                        finaleMessage: "✅ プロセス制御のエキスパート！"
                    ))
                ),
                Lesson(
                    title: "プロセス管理の深掘りクイズ",
                    emoji: "💭",
                    estimatedMinutes: 12,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "ps aux で STAT 列が「Z」のプロセスが多数表示されている。これは何を示すか？",
                                choices: [
                                    "ゾンビプロセス：プロセス自体は終了しているが、親プロセスが wait() を呼んでいないためプロセステーブルに残っている",
                                    "一時停止中のプロセス",
                                    "スリープ中のプロセス",
                                    "システムクリティカルなプロセス"
                                ],
                                correctIndex: 0,
                                explanation: "ゾンビプロセス（defunct）はプロセスが終了した後も、親プロセスが wait() システムコールで終了ステータスを回収するまでプロセステーブルに残ります。ゾンビ自体はリソースをほとんど消費しませんが、PID を占有します。大量のゾンビは親プロセスのバグを示し、解決策は親プロセスを再起動することです（親が終了すると init/systemd がゾンビを回収します）。"
                            ),
                            QuizQuestion(
                                question: "プロセスに kill -15（SIGTERM）を送ったが反応がなかった。次の行動として正しい順序は？",
                                choices: [
                                    "まず数秒待ち、それでも終了しなければ kill -9（SIGKILL）を送る",
                                    "即座に kill -9 を送る（-15 が効かない場合は -9 しかない）",
                                    "プロセスを無視する（自然に終了するまで待つ）",
                                    "サーバーを再起動する"
                                ],
                                correctIndex: 0,
                                explanation: "SIGTERM はプロセスに「終了してください」と伝えるシグナルで、プロセスはシグナルをキャッチして後処理（ファイルのクローズ、ロックの解放など）を行えます。ただし無視したりキャッチ不能な状態のプロセスには効きません。SIGKILL はカーネルレベルで強制終了するため必ず効きますが、後処理ができないためファイル破損のリスクがあります。まず SIGTERM、それから SIGKILL が適切な手順です。"
                            ),
                            QuizQuestion(
                                question: "nice -n 10 ./heavy-task.sh を実行した。このコマンドの効果は？",
                                choices: [
                                    "heavy-task.sh を優先度を下げて実行（他プロセスにCPU時間を譲りやすくなる）",
                                    "heavy-task.sh を最高優先度で実行",
                                    "10 分後に heavy-task.sh を実行",
                                    "heavy-task.sh を 10 回実行"
                                ],
                                correctIndex: 0,
                                explanation: "nice コマンドはプロセスの優先度（nice値）を設定します。nice値の範囲は -20（最高優先度）〜 19（最低優先度）で、デフォルトは 0 です。nice -n 10 は通常より低い優先度で実行するため、システムの他の作業（WebサーバーなどI/O待ちが多いプロセス）へのCPU影響を減らせます。バックグラウンドのバックアップや圧縮処理に有効です。renice コマンドで実行中のプロセスの優先度を変更できます。"
                            ),
                        ]
                    ))
                ),
            ]
        ),
    ]
)

// MARK: - Public Curriculum Array
var comprehensiveAllCourses: [Course] {
    [basicsCourse, standardCourse, advancedCourse, expertCourse1, expertCourse2, expertCourse3, expertCourse4]
}
