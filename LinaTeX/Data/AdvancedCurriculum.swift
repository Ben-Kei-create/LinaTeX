import SwiftUI

// MARK: - Extended curriculum with more content for Standard and Advanced

let extendedStandardCourse = Course(
    level: .standard,
    title: "テキスト処理と権限",
    subtitle: "grep, sed, chmod をマスター",
    description: "ファイル操作の応用、テキスト検索・処理、権限管理を学びます。",
    emoji: "⚙️",
    estimatedMinutes: 90,
    chapters: [
        Chapter(
            number: 4,
            title: "テキストを検索・操作する",
            summary: "grep, sed で強力なテキスト処理",
            lessons: [
                Lesson(
                    title: "grep - テキストを検索",
                    emoji: "🔍",
                    estimatedMinutes: 10,
                    content: .quest(QuestLesson(
                        scenario: "大量のテキストから特定の単語を探したい。",
                        prompt: "ファイルから文字列を検索するコマンドは？",
                        hint: "Global Regular Expression Print の略。",
                        answer: "grep",
                        options: [
                            CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
                            CommandOption(label: "find", command: "find", icon: "magnifyingglass.circle"),
                            CommandOption(label: "sed", command: "sed", icon: "pencil.and.outline"),
                        ],
                        simulatedOutput: "user@linux:~$ grep 'Linux' README.md\nLinux is powerful\nLinux is free",
                        successMessage: "✅ grep で検索できました！"
                    ))
                ),
                Lesson(
                    title: "パイプと連携処理",
                    emoji: "⛓️",
                    estimatedMinutes: 12,
                    content: .scenario(ScenarioLesson(
                        setup: "複数のコマンドを組み合わせて、ログファイルから情報を抽出します。",
                        goal: "cat → grep → wc を使用",
                        steps: [
                            ScenarioStep(
                                prompt: "app.log ファイルの内容を表示します。",
                                hint: "cat app.log",
                                answer: "cat",
                                options: [
                                    CommandOption(label: "cat", command: "cat", icon: "doc.text"),
                                    CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                    CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
                                ],
                                simulatedOutput: "[ERROR] Connection failed\n[INFO] Service started\n[ERROR] Timeout"
                            ),
                            ScenarioStep(
                                prompt: "ERROR を含む行だけを抽出します。",
                                hint: "cat app.log | grep ERROR",
                                answer: "grep",
                                options: [
                                    CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
                                    CommandOption(label: "sed", command: "sed", icon: "pencil.and.outline"),
                                    CommandOption(label: "awk", command: "awk", icon: "square.and.pencil"),
                                ],
                                simulatedOutput: "[ERROR] Connection failed\n[ERROR] Timeout"
                            ),
                            ScenarioStep(
                                prompt: "ERROR の行数をカウントします。",
                                hint: "cat app.log | grep ERROR | wc -l",
                                answer: "wc",
                                options: [
                                    CommandOption(label: "wc", command: "wc", icon: "sum"),
                                    CommandOption(label: "sort", command: "sort", icon: "arrow.up.arrow.down"),
                                    CommandOption(label: "uniq", command: "uniq", icon: "square.stack"),
                                ],
                                simulatedOutput: "2"
                            ),
                        ],
                        finaleMessage: "✅ パイプで複数のコマンドを組み合わせるマスターになりました！"
                    ))
                ),
                Lesson(
                    title: "sed で置換",
                    emoji: "✏️",
                    estimatedMinutes: 12,
                    content: .concept(ConceptLesson(
                        headline: "sed で強力なテキスト置換",
                        sections: [
                            ConceptSection(
                                heading: "sed とは",
                                body: "Stream Editor（ストリームエディタ）。\nファイルを編集するのではなく、標準出力にエディット結果を表示します。\n\n基本形：sed 's/置換前/置換後/' ファイル名",
                                codeSample: "sed 's/old/new/' file.txt\nsed 's/old/new/g' file.txt  # 全て置換",
                                tip: "g フラグをつけると、1行内の全ての置換が対象になります"
                            ),
                            ConceptSection(
                                heading: "実践例",
                                body: "# URLを置換\nsed 's|http://|https://|g' urls.txt\n\n# 空白行を削除\nsed '/^$/d' file.txt",
                                codeSample: nil,
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "テキスト処理クイズ",
                    emoji: "❓",
                    estimatedMinutes: 8,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "grep コマンドで 'error' を含む行を検索するコマンドは？",
                                choices: [
                                    "find 'error'",
                                    "grep 'error' file.txt",
                                    "sed 'error' file.txt",
                                    "cat 'error'"
                                ],
                                correctIndex: 1,
                                explanation: "grep は文字列検索の王様です。ファイルから特定の文字列を含む行を抽出します。"
                            ),
                            QuizQuestion(
                                question: "パイプ | の役割は？",
                                choices: [
                                    "ファイルを開く",
                                    "前のコマンド出力を次のコマンド入力にする",
                                    "複数のファイルを結合する",
                                    "コマンドをコメントアウトする"
                                ],
                                correctIndex: 1,
                                explanation: "パイプは UNIX の最大の特徴。小さく完成したツールを組み合わせて大きな仕事をします。"
                            ),
                            QuizQuestion(
                                question: "sed 's/old/new/g' の g フラグは何を意味する？",
                                choices: [
                                    "グローバル - 1行内の全て置換",
                                    "グループ - 複数ファイル処理",
                                    "ガイド - ガイド表示",
                                    "グリーン - 成功時のみ"
                                ],
                                correctIndex: 0,
                                explanation: "g = Global。g なしだと 1 行目の最初の1つだけ置換します。"
                            ),
                        ]
                    ))
                ),
            ]
        ),

        Chapter(
            number: 5,
            title: "ファイル権限を管理する",
            summary: "chmod で安全性を確保",
            lessons: [
                Lesson(
                    title: "chmod - 権限を変更",
                    emoji: "🔐",
                    estimatedMinutes: 10,
                    content: .quest(QuestLesson(
                        scenario: "作ったシェルスクリプトを実行可能にしたい。",
                        prompt: "ファイルの権限を変更するコマンドは？",
                        hint: "Change Mode の略。chmod +x script.sh で実行可能に。",
                        answer: "chmod",
                        options: [
                            CommandOption(label: "chmod", command: "chmod", icon: "lock.fill"),
                            CommandOption(label: "chown", command: "chown", icon: "person.fill"),
                            CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                        ],
                        simulatedOutput: "",
                        successMessage: "✅ 権限を変更しました！"
                    ))
                ),
                Lesson(
                    title: "権限の読み方と実務",
                    emoji: "📖",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "rwx の意味と実務での使い分け",
                        sections: [
                            ConceptSection(
                                heading: "権限表記",
                                body: "-rwxr-xr-x\n\n• r (read:4) = 読む\n• w (write:2) = 書く\n• x (execute:1) = 実行\n\n最初の3文字: 所有者\n次の3文字: グループ\n最後の3文字: その他のユーザー",
                                codeSample: "-rwxr-xr-x  755 owner group",
                                tip: "数値指定：7=rwx, 5=r-x, 4=r--, 0=---"
                            ),
                            ConceptSection(
                                heading: "実務での使い分け",
                                body: "755: 実行ファイル（実行可能、他は読むだけ）\n644: 通常のテキストファイル（書き込みは所有者のみ）\n600: パスワードファイル（所有者のみアクセス可）\n777: 全員フルアクセス（セキュリティリスク）",
                                codeSample: "chmod 755 script.sh\nchmod 644 config.txt\nchmod 600 secrets.key",
                                tip: "Web サーバーのルート (/) は通常 755。個人ファイルは 600 がセキュア"
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "権限シナリオ",
                    emoji: "🏗️",
                    estimatedMinutes: 12,
                    content: .scenario(ScenarioLesson(
                        setup: "共有サーバー上でファイルの権限を正しく設定します。",
                        goal: "段階的に権限を設定",
                        steps: [
                            ScenarioStep(
                                prompt: "backup.sh を作成しました。まず実行可能にします。",
                                hint: "chmod +x backup.sh",
                                answer: "chmod",
                                options: [
                                    CommandOption(label: "chmod", command: "chmod", icon: "lock.fill"),
                                    CommandOption(label: "chown", command: "chown", icon: "person.fill"),
                                    CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                ],
                                simulatedOutput: ""
                            ),
                            ScenarioStep(
                                prompt: "config.conf は機密ファイル。所有者だけがアクセスできるようにします。",
                                hint: "chmod 600 config.conf",
                                answer: "chmod",
                                options: [
                                    CommandOption(label: "chmod", command: "chmod", icon: "lock.fill"),
                                    CommandOption(label: "chown", command: "chown", icon: "person.fill"),
                                    CommandOption(label: "rm", command: "rm", icon: "trash"),
                                ],
                                simulatedOutput: ""
                            ),
                            ScenarioStep(
                                prompt: "public.txt は公開ファイル。全員が読めるようにします。",
                                hint: "chmod 644 public.txt",
                                answer: "chmod",
                                options: [
                                    CommandOption(label: "chmod", command: "chmod", icon: "lock.fill"),
                                    CommandOption(label: "cat", command: "cat", icon: "doc.text"),
                                    CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                ],
                                simulatedOutput: ""
                            ),
                        ],
                        finaleMessage: "✅ ファイル権限のプロになりました！"
                    ))
                ),
            ]
        ),
    ]
)

let extendedAdvancedCourse = Course(
    level: .advanced,
    title: "シェルスクリプト入門",
    subtitle: "自動化と実務に向けて",
    description: "シェルスクリプト、パッケージ管理、ネットワークコマンドを学びます。",
    emoji: "🚀",
    estimatedMinutes: 120,
    chapters: [
        Chapter(
            number: 6,
            title: "シェルスクリプトで自動化",
            summary: "複数のコマンドをスクリプト化",
            lessons: [
                Lesson(
                    title: "シェルスクリプトとは",
                    emoji: "📝",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "コマンドを自動実行する",
                        sections: [
                            ConceptSection(
                                heading: "スクリプトの力",
                                body: "毎日同じコマンドを何度も打つのは無駄。\nシェルスクリプトに書いておけば、1コマンドで全て実行できます。\n\nBackup、ログ処理、定期メンテナンス、デプロイなど、実務でよく使います。",
                                codeSample: "#!/bin/bash\necho 'Backup started'\ntar -czf backup.tar.gz /home/user\necho 'Backup done'",
                                tip: "最初の行 #!/bin/bash はシェバング（shebang）。このファイルが Bash スクリプトだと宣言"
                            ),
                            ConceptSection(
                                heading: "変数とループ",
                                body: "# 変数の使用\nBACKUP_DIR=\"/backup\"\necho $BACKUP_DIR\n\n# ループで複数処理\nfor file in *.txt; do\n  echo \"Processing $file\"\ndone",
                                codeSample: nil,
                                tip: "変数は $ で参照します。強力な自動化ツール"
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "初めてのスクリプト実行",
                    emoji: "🎯",
                    estimatedMinutes: 15,
                    content: .scenario(ScenarioLesson(
                        setup: "簡単なバックアップスクリプトを作成・実行します。",
                        goal: "スクリプト作成 → 実行可能化 → 実行",
                        steps: [
                            ScenarioStep(
                                prompt: "テキストエディタでスクリプトファイルを作成します。",
                                hint: "touch backup.sh で空ファイルを作成。nano backup.sh で編集",
                                answer: "touch",
                                options: [
                                    CommandOption(label: "touch", command: "touch", icon: "doc.badge.plus"),
                                    CommandOption(label: "echo", command: "echo", icon: "quote.bubble"),
                                    CommandOption(label: "cat", command: "cat", icon: "doc.text"),
                                ],
                                simulatedOutput: ""
                            ),
                            ScenarioStep(
                                prompt: "スクリプトを実行可能にします。",
                                hint: "chmod +x backup.sh",
                                answer: "chmod",
                                options: [
                                    CommandOption(label: "chmod", command: "chmod", icon: "lock.fill"),
                                    CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                    CommandOption(label: "cat", command: "cat", icon: "doc.text"),
                                ],
                                simulatedOutput: ""
                            ),
                            ScenarioStep(
                                prompt: "スクリプトを実行します。",
                                hint: "bash backup.sh または ./backup.sh",
                                answer: "bash",
                                options: [
                                    CommandOption(label: "bash", command: "bash", icon: "terminal.fill"),
                                    CommandOption(label: "cat", command: "cat", icon: "doc.text"),
                                    CommandOption(label: "sh", command: "sh", icon: "terminal.fill"),
                                ],
                                simulatedOutput: "Backup completed successfully!"
                            ),
                        ],
                        finaleMessage: "✅ シェルスクリプトの基本をマスターしました！"
                    ))
                ),
            ]
        ),

        Chapter(
            number: 7,
            title: "ネットワークと遠隔操作",
            summary: "ssh, curl でサーバーを操作",
            lessons: [
                Lesson(
                    title: "ssh - リモートログイン",
                    emoji: "🌐",
                    estimatedMinutes: 12,
                    content: .concept(ConceptLesson(
                        headline: "遠いサーバーを操作する",
                        sections: [
                            ConceptSection(
                                heading: "SSH とは",
                                body: "Secure Shell (SSH) は、ネットワークを通じて安全に遠いコンピュータにログインできます。\n\n基本：ssh user@hostname\n\nクラウドサーバー、VPS、社内サーバーを操作するのに必須です。",
                                codeSample: "ssh user@example.com\nssh -p 2222 user@192.168.1.100\nssh -i ~/.ssh/id_rsa user@server.com",
                                tip: "本番サーバーはほぼ必ず SSH で操作。Linux エンジニア必須スキル"
                            ),
                            ConceptSection(
                                heading: "鍵認証とパスワード認証",
                                body: "# パスワード認証（簡単だが安全度低い）\nssh user@host\n\n# 鍵認証（安全度高い、実務推奨）\nssh -i ~/.ssh/id_rsa user@host",
                                codeSample: nil,
                                tip: "公開鍵をサーバーに登録すれば、パスワード不要で自動ログイン"
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "curl - Webからデータ取得",
                    emoji: "📡",
                    estimatedMinutes: 10,
                    content: .quest(QuestLesson(
                        scenario: "Webサイトの内容をダウンロード＆処理したい。",
                        prompt: "URLからデータを取得するコマンドは？",
                        hint: "curl https://example.com",
                        answer: "curl",
                        options: [
                            CommandOption(label: "curl", command: "curl", icon: "network"),
                            CommandOption(label: "wget", command: "wget", icon: "arrow.down.doc"),
                            CommandOption(label: "ssh", command: "ssh", icon: "link"),
                        ],
                        simulatedOutput: "<!DOCTYPE html>\n<html>...",
                        successMessage: "✅ データを取得しました！"
                    ))
                ),
                Lesson(
                    title: "ネットワーク診断",
                    emoji: "🔧",
                    estimatedMinutes: 8,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "ssh でリモートサーバーにログインするコマンドは？",
                                choices: [
                                    "ssh connect user@host",
                                    "ssh user@host",
                                    "remote user@host",
                                    "connect -u user@host"
                                ],
                                correctIndex: 1,
                                explanation: "ssh は Secure Shell。user@host でログインします。"
                            ),
                            QuizQuestion(
                                question: "curl でWebサイトのHTMLを取得するには？",
                                choices: [
                                    "curl download https://example.com",
                                    "curl https://example.com",
                                    "curl -web https://example.com",
                                    "get https://example.com"
                                ],
                                correctIndex: 1,
                                explanation: "curl は基本コマンド。フラグなしでHTMLを出力します。"
                            ),
                            QuizQuestion(
                                question: "ssh で非標準ポート（2222）に接続するには？",
                                choices: [
                                    "ssh -p 2222 user@host",
                                    "ssh :2222 user@host",
                                    "ssh port 2222 user@host",
                                    "ssh --port=2222 user@host"
                                ],
                                correctIndex: 0,
                                explanation: "-p オプションでポートを指定します。セキュリティため非標準ポート使用は一般的"
                            ),
                        ]
                    ))
                ),
            ]
        ),
    ]
)

// Update allCourses
var updatedAllCourses: [Course] {
    [allCourses[0], extendedStandardCourse, extendedAdvancedCourse]
}
