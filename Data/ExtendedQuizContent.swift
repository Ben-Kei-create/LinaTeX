import SwiftUI

// MARK: - Extended Quiz and Scenario Content

// Additional lessons for Basics course with more comprehensive quizzes
let basicsAdditionalLessons = [
    // Filesystem fundamentals quiz
    Lesson(
        title: "ファイルシステム総合クイズ",
        emoji: "🗂️",
        estimatedMinutes: 10,
        content: .quiz(QuizLesson(
            questions: [
                QuizQuestion(
                    question: "絶対パスと相対パスの違いは？",
                    choices: [
                        "絶対パス: / から始まる、相対パス: 現在地から",
                        "絶対パス: 長い、相対パス: 短い",
                        "絶対パス: 英数字のみ、相対パス: 記号も可",
                        "違いはない"
                    ],
                    correctIndex: 0,
                    explanation: "絶対パスは /home/user/file.txt のように / から始まります。相対パスは ./documents/file.txt のように現在地からの相対的な位置です。"
                ),
                QuizQuestion(
                    question: "~ はどのディレクトリを指す？",
                    choices: [
                        "ホームディレクトリ",
                        "現在のディレクトリ",
                        "ルートディレクトリ",
                        "テンポラリフォルダ"
                    ],
                    correctIndex: 0,
                    explanation: "~ はユーザーのホームディレクトリを指します。/home/username と同じ意味です。"
                ),
                QuizQuestion(
                    question: ".. で参照できるのは？",
                    choices: [
                        "親ディレクトリ",
                        "兄弟ディレクトリ",
                        "子ディレクトリ",
                        "ホームディレクトリ"
                    ],
                    correctIndex: 0,
                    explanation: ".. は親ディレクトリ（1つ上の階層）を指します。. は現在のディレクトリ。"
                ),
                QuizQuestion(
                    question: "ls -la コマンドで表示される l の意味は？",
                    choices: [
                        "long format - 詳細表示",
                        "list all - 全リスト",
                        "link - シンボリックリンク",
                        "last modified - 更新日時順"
                    ],
                    correctIndex: 0,
                    explanation: "-l は long format で、ファイル詳細情報を表示。-a で隠しファイルも表示。"
                ),
            ]
        ))
    ),

    // Directory operations scenario
    Lesson(
        title: "ディレクトリ操作の実務シナリオ",
        emoji: "📂",
        estimatedMinutes: 14,
        content: .scenario(ScenarioLesson(
            setup: "新規プロジェクトのディレクトリ構造を構築します。",
            goal: "複数のディレクトリを作成し、ファイルを整理する",
            steps: [
                ScenarioStep(
                    prompt: "プロジェクトディレクトリ my-app を作成します。",
                    hint: "mkdir my-app",
                    answer: "mkdir",
                    options: [
                        CommandOption(label: "mkdir", command: "mkdir", icon: "folder.badge.plus"),
                        CommandOption(label: "md", command: "md", icon: "folder"),
                        CommandOption(label: "create", command: "create", icon: "square.and.pencil"),
                    ],
                    simulatedOutput: "user@linux:~$ mkdir my-app\nuser@linux:~$"
                ),
                ScenarioStep(
                    prompt: "my-app ディレクトリに移動します。",
                    hint: "cd my-app",
                    answer: "cd",
                    options: [
                        CommandOption(label: "cd", command: "cd", icon: "arrow.right"),
                        CommandOption(label: "chdir", command: "chdir", icon: "arrow.up.arrow.down"),
                        CommandOption(label: "go", command: "go", icon: "arrow.forward"),
                    ],
                    simulatedOutput: "user@linux:~$ cd my-app\nuser@linux:~/my-app$"
                ),
                ScenarioStep(
                    prompt: "src, tests, docs の3つのサブディレクトリを一度に作成します。",
                    hint: "mkdir src tests docs",
                    answer: "mkdir",
                    options: [
                        CommandOption(label: "mkdir", command: "mkdir", icon: "folder.badge.plus"),
                        CommandOption(label: "mkdir -p", command: "mkdir -p", icon: "folder.fill"),
                        CommandOption(label: "mkdirs", command: "mkdirs", icon: "folder.circle"),
                    ],
                    simulatedOutput: "user@linux:~/my-app$ mkdir src tests docs\nuser@linux:~/my-app$"
                ),
                ScenarioStep(
                    prompt: "現在のディレクトリ構造を確認します。",
                    hint: "ls -la",
                    answer: "ls",
                    options: [
                        CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                        CommandOption(label: "tree", command: "tree", icon: "square.stack"),
                        CommandOption(label: "find", command: "find", icon: "magnifyingglass"),
                    ],
                    simulatedOutput: "drwxr-xr-x  5 user group  4096 Jan 15 10:00 .\ndrwxr-xr-x 10 user group  4096 Jan 15 10:00 ..\ndrwxr-xr-x  2 user group  4096 Jan 15 10:00 docs\ndrwxr-xr-x  2 user group  4096 Jan 15 10:00 src\ndrwxr-xr-x  2 user group  4096 Jan 15 10:00 tests"
                ),
            ],
            finaleMessage: "✅ ディレクトリ構造の構築完了！"
        ))
    ),
]

// Additional advanced scenarios and quizzes
let standardAdditionalLessons = [
    // Regular expressions quiz
    Lesson(
        title: "正規表現クイズ",
        emoji: "📝",
        estimatedMinutes: 10,
        content: .quiz(QuizLesson(
            questions: [
                QuizQuestion(
                    question: "正規表現 .* の意味は？",
                    choices: [
                        "任意の文字が0回以上繰り返される",
                        "ドット記号のみ",
                        "改行を含まない任意の文字",
                        "単語の末尾"
                    ],
                    correctIndex: 0,
                    explanation: ". は任意の1文字、* は0回以上の繰り返しを意味します。.* は任意の文字列にマッチ。"
                ),
                QuizQuestion(
                    question: "^error で検索した場合、マッチするのは？",
                    choices: [
                        "行頭が error で始まる",
                        "どこかに error が含まれている",
                        "error で終わる",
                        "error そのもののみ"
                    ],
                    correctIndex: 0,
                    explanation: "^ は行頭を指します。^error で行の最初が error で始まるパターンをマッチ。"
                ),
                QuizQuestion(
                    question: "grep '[0-9]' は何をする？",
                    choices: [
                        "数字を含む行を検索",
                        "0から9 の文字列を検索",
                        "[0-9] という文字を検索",
                        "行番号を表示"
                    ],
                    correctIndex: 0,
                    explanation: "[0-9] は0から9までの任意の数字1文字を表します。このパターンを含む行を検出。"
                ),
            ]
        ))
    ),

    // System administration scenario
    Lesson(
        title: "システム管理者の日常業務",
        emoji: "🔧",
        estimatedMinutes: 15,
        content: .scenario(ScenarioLesson(
            setup: "サーバーのシステム状態を確認し、重要なファイルをバックアップします。",
            goal: "システム情報確認とバックアップの実行",
            steps: [
                ScenarioStep(
                    prompt: "現在のユーザー情報を確認します。",
                    hint: "whoami",
                    answer: "whoami",
                    options: [
                        CommandOption(label: "whoami", command: "whoami", icon: "person.fill"),
                        CommandOption(label: "id", command: "id", icon: "person.badge"),
                        CommandOption(label: "user", command: "user", icon: "person"),
                    ],
                    simulatedOutput: "user@linux:~$ whoami\nuser"
                ),
                ScenarioStep(
                    prompt: "ディスク使用量を確認します。",
                    hint: "df -h",
                    answer: "df",
                    options: [
                        CommandOption(label: "df", command: "df", icon: "externaldrive.fill"),
                        CommandOption(label: "du", command: "du", icon: "doc.text.fill"),
                        CommandOption(label: "disk", command: "disk", icon: "xmark.bin"),
                    ],
                    simulatedOutput: "Filesystem      Size  Used Avail Use% Mounted on\n/dev/sda1        20G  8.5G  11G  43% /\n/dev/sdb1       100G  50G   50G  50% /home"
                ),
                ScenarioStep(
                    prompt: "/etc/config.txt をバックアップします。",
                    hint: "cp /etc/config.txt /backup/config.txt",
                    answer: "cp",
                    options: [
                        CommandOption(label: "cp", command: "cp", icon: "doc.on.doc"),
                        CommandOption(label: "backup", command: "backup", icon: "archivebox"),
                        CommandOption(label: "copy", command: "copy", icon: "arrow.right"),
                    ],
                    simulatedOutput: "user@linux:~$ cp /etc/config.txt /backup/config.txt\nuser@linux:~$"
                ),
            ],
            finaleMessage: "✅ システム確認とバックアップ完了！"
        ))
    ),
]

// Advanced course additional content
let advancedAdditionalLessons = [
    // Bash scripting quiz
    Lesson(
        title: "bash スクリプト実践クイズ",
        emoji: "💻",
        estimatedMinutes: 10,
        content: .quiz(QuizLesson(
            questions: [
                QuizQuestion(
                    question: "if [ $# -eq 0 ] の意味は？",
                    choices: [
                        "引数の数が0（引数なし）かチェック",
                        "最初の引数が0かチェック",
                        "変数 # の値をチェック",
                        "ファイルの行数をチェック"
                    ],
                    correctIndex: 0,
                    explanation: "$# は引数の個数。[ $# -eq 0 ] で引数が0個（引数なし）をチェック。"
                ),
                QuizQuestion(
                    question: "$1, $2, $3 が何を表す？",
                    choices: [
                        "コマンドライン引数1番目, 2番目, 3番目",
                        "変数1, 2, 3の値",
                        "エラーコード",
                        "最後の3つのコマンド"
                    ],
                    correctIndex: 0,
                    explanation: "$1 は最初の引数、$2 は2番目の引数。./script.sh arg1 arg2 arg3 なら $1=arg1 など。"
                ),
                QuizQuestion(
                    question: "for i in {1..5} の意味は？",
                    choices: [
                        "変数iを1から5までループ",
                        "ファイル 1, 2, 3, 4, 5 をループ",
                        "1から5の出力を表示",
                        "条件iが5までチェック"
                    ],
                    correctIndex: 0,
                    explanation: "{1..5} は1から5の範囲展開。各値がiに順番に代入されてループ。"
                ),
            ]
        ))
    ),

    // Deployment scenario
    Lesson(
        title: "Webアプリケーションのデプロイ",
        emoji: "🚀",
        estimatedMinutes: 16,
        content: .scenario(ScenarioLesson(
            setup: "本番サーバーにアプリケーションをデプロイし、動作確認します。",
            goal: "SSH接続、ファイル転送、サービス起動を実行",
            steps: [
                ScenarioStep(
                    prompt: "本番サーバー prod.example.com に SSH で接続します。",
                    hint: "ssh deploy@prod.example.com",
                    answer: "ssh",
                    options: [
                        CommandOption(label: "ssh", command: "ssh", icon: "network"),
                        CommandOption(label: "scp", command: "scp", icon: "arrow.down.doc"),
                        CommandOption(label: "telnet", command: "telnet", icon: "link"),
                    ],
                    simulatedOutput: "deploy@prod.example.com's password:\ndeployment@prod:~$"
                ),
                ScenarioStep(
                    prompt: "アプリケーション用ディレクトリに移動します。",
                    hint: "cd /var/www/app",
                    answer: "cd",
                    options: [
                        CommandOption(label: "cd", command: "cd", icon: "arrow.right"),
                        CommandOption(label: "chdir", command: "chdir", icon: "arrow.up.arrow.down"),
                        CommandOption(label: "goto", command: "goto", icon: "arrow.forward"),
                    ],
                    simulatedOutput: "deployment@prod:~$ cd /var/www/app\ndeployment@prod:/var/www/app$"
                ),
                ScenarioStep(
                    prompt: "git で最新のコードをプルします。",
                    hint: "git pull origin main",
                    answer: "git",
                    options: [
                        CommandOption(label: "git", command: "git", icon: "arrow.down.circle"),
                        CommandOption(label: "pull", command: "pull", icon: "arrow.down.doc"),
                        CommandOption(label: "fetch", command: "fetch", icon: "arrow.down"),
                    ],
                    simulatedOutput: "Already up to date.\ndeployment@prod:/var/www/app$"
                ),
                ScenarioStep(
                    prompt: "アプリケーションを再起動します。",
                    hint: "systemctl restart myapp",
                    answer: "systemctl",
                    options: [
                        CommandOption(label: "systemctl", command: "systemctl", icon: "power"),
                        CommandOption(label: "service", command: "service", icon: "gear"),
                        CommandOption(label: "restart", command: "restart", icon: "arrow.counterclockwise"),
                    ],
                    simulatedOutput: "deployment@prod:/var/www/app$ sudo systemctl restart myapp\ndeployment@prod:/var/www/app$"
                ),
            ],
            finaleMessage: "✅ デプロイメント完了！本番環境は正常に動作しています"
        ))
    ),
]
