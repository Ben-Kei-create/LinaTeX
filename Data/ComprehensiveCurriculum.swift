import SwiftUI

// MARK: - Comprehensive Curriculum Extensions
// Adds substantial quiz and scenario content to flesh out the full curriculum

// Extended Basics Course with comprehensive quizzes and scenarios
let enhancedBasicsCourse = Course(
    level: .basics,
    title: "Linuxの基本",
    subtitle: "ターミナルの世界へようこそ",
    description: "Linuxの基礎から始めます。ターミナル操作、ファイルシステム、基本コマンドを習得します。",
    emoji: "🐧",
    estimatedMinutes: 90,
    chapters: [
        Chapter(
            number: 3,
            title: "ファイル操作マスター",
            summary: "cp, mv, rm を組み合わせて実践的なファイル管理",
            lessons: [
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
                Lesson(
                    title: "基本コマンド確認テスト",
                    emoji: "✅",
                    estimatedMinutes: 10,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "ホームディレクトリに移動するコマンドは？",
                                choices: ["cd ~", "ls ~", "pwd", "mkdir ~"],
                                correctIndex: 0,
                                explanation: "cd ~ でホームディレクトリに移動します。cd だけでもOK。"
                            ),
                            QuizQuestion(
                                question: "ファイル data.txt を data_copy.txt にコピーするコマンドは？",
                                choices: ["cp data.txt data_copy.txt", "mv data.txt data_copy.txt", "cat data.txt > data_copy.txt", "ln data.txt data_copy.txt"],
                                correctIndex: 0,
                                explanation: "cp で既存ファイルをコピーします。mv は移動（リネーム）です。"
                            ),
                            QuizQuestion(
                                question: "現在のディレクトリのファイル数を確認するコマンドは？",
                                choices: ["ls | wc -l", "find . -type f | wc -l", "stat .", "count"],
                                correctIndex: 0,
                                explanation: "ls をパイプして wc -l で行数カウント。より正確には find を使う方法もあります。"
                            ),
                        ]
                    ))
                ),
            ]
        ),
    ]
)

// Extended Standard Course with more practical scenarios
let enhancedStandardCourse = Course(
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
                    title: "grep 実践クイズ",
                    emoji: "🧪",
                    estimatedMinutes: 8,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "ファイルから大文字小文字を区別せず検索するオプションは？",
                                choices: ["-i", "-r", "-n", "-v"],
                                correctIndex: 0,
                                explanation: "grep -i で大文字小文字を区別しません。case-insensitive の i です。"
                            ),
                            QuizQuestion(
                                question: "grep -r は何を意味する？",
                                choices: ["Recursive - 再帰的に検索", "Reverse - 逆順", "Replace - 置換", "Remove - 削除"],
                                correctIndex: 0,
                                explanation: "grep -r でディレクトリ内を再帰的に検索します。複数ファイルから一度に検索可能。"
                            ),
                            QuizQuestion(
                                question: "パターンにマッチしない行を表示するオプションは？",
                                choices: ["-v", "-i", "-r", "-n"],
                                correctIndex: 0,
                                explanation: "grep -v で逆マッチ（invert）します。マッチしない行を表示。"
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
                    estimatedMinutes: 8,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "パイプ（|）の役割は？",
                                choices: ["前のコマンドの出力を次のコマンドの入力に", "コマンドを複数実行", "条件分岐", "別ファイルにリダイレクト"],
                                correctIndex: 0,
                                explanation: "パイプは前のコマンドの標準出力を次のコマンドの標準入力に繋ぎます。コマンド連携の基本。"
                            ),
                            QuizQuestion(
                                question: "sed 's/old/new/g' file.txt の g フラグは何？",
                                choices: ["Global - 1行内の全て置換", "Group - グループ化", "Generate - 生成", "Grep - 検索"],
                                correctIndex: 0,
                                explanation: "g フラグは global。1行内の全てのマッチを置換します。g なしは1行につき1回だけ。"
                            ),
                            QuizQuestion(
                                question: "grep コマンドでファイルの行番号も表示するオプションは？",
                                choices: ["-n", "-l", "-c", "-h"],
                                correctIndex: 0,
                                explanation: "grep -n で行番号を表示します。-l はファイル名のみ、-c は件数のみ表示。"
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
                    title: "権限管理クイズ",
                    emoji: "🔑",
                    estimatedMinutes: 8,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "755 という権限の意味は？",
                                choices: ["所有者:読み書き実行、グループ:読み実行、他:読み実行", "所有者:読み書き、グループ:読み、他:読み実行", "所有者:読み、グループ:読み実行、他:読み", "所有者:読み実行、グループ:読み、他:読み実行"],
                                correctIndex: 0,
                                explanation: "755 = rwxr-xr-x。所有者が全権、グループと他が読み実行。実行可能ファイル向け。"
                            ),
                            QuizQuestion(
                                question: "644 という権限の意味は？",
                                choices: ["所有者:読み書き、グループ:読み、他:読み", "所有者:読み写き実行、グループ:読み実行、他:実行", "所有者:読み、グループ:読み書き、他:読み", "所有者:読み書き、グループ:読み実行、他:読み実行"],
                                correctIndex: 0,
                                explanation: "644 = rw-r--r--。所有者が読み書き、グループと他が読み専用。テキストファイル向け。"
                            ),
                            QuizQuestion(
                                question: "chmod u+x file.txt は何をする？",
                                choices: ["所有者に実行権限を追加", "全員に実行権限を追加", "所有者から実行権限を削除", "実行権限を644に設定"],
                                correctIndex: 0,
                                explanation: "u は所有者（user）。+x で実行権限を追加。シンボリック表記（644より直感的）。"
                            ),
                        ]
                    ))
                ),
            ]
        ),
    ]
)

// Extended Advanced Course
let enhancedAdvancedCourse = Course(
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
                    estimatedMinutes: 8,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "#!/bin/bash は何を意味する？",
                                choices: ["Shebang - このファイルを bash で実行することを指定", "コメント", "bash のバージョン指定", "環境変数設定"],
                                correctIndex: 0,
                                explanation: "Shebang（シェバング）。スクリプトの最初の行に書き、どのインタプリタで実行するかを指定。"
                            ),
                            QuizQuestion(
                                question: "bash スクリプトを実行するコマンドは？",
                                choices: ["bash script.sh", "./script.sh", "sh script.sh", "全て可能"],
                                correctIndex: 3,
                                explanation: "bash script.sh、./script.sh、sh script.sh どれでも実行可能。シェバング指定時は ./script.sh がベスト。"
                            ),
                            QuizQuestion(
                                question: "スクリプトに変数を渡すには？",
                                choices: ["./script.sh arg1 arg2", "VAR=value ./script.sh", "export VAR=value", "全て可能"],
                                correctIndex: 3,
                                explanation: "位置引数、環境変数、export で変数設定可能。スクリプト内で $1, $2 で参照。"
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
                    estimatedMinutes: 8,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "SSH の主な用途は？",
                                choices: ["安全に遠いサーバーにログイン・操作", "メールプロトコル", "Webページ取得", "パッケージ管理"],
                                correctIndex: 0,
                                explanation: "SSH (Secure Shell) でリモートサーバーに安全に接続。暗号化通信で盗聴・改ざん防止。"
                            ),
                            QuizQuestion(
                                question: "curl コマンドの主な用途は？",
                                choices: ["URLからデータを取得、API との通信", "ファイル検索", "テキスト置換", "ディレクトリ移動"],
                                correctIndex: 0,
                                explanation: "curl で HTTP/HTTPS 通信。Web API の呼び出し、Webページのダウンロードに使用。"
                            ),
                            QuizQuestion(
                                question: "SSH キー認証の利点は？",
                                choices: ["パスワード入力不要で安全、スクリプト自動化が可能", "速度が速い", "パスワードより長い", "全て"],
                                correctIndex: 0,
                                explanation: "SSH 鍵認証でパスワード不要。自動化スクリプトから安全に接続可能。本番環境ではほぼ必須。"
                            ),
                        ]
                    ))
                ),
            ]
        ),
    ]
)

// MARK: - Final comprehensive curriculum combining all courses
var comprehensiveAllCourses: [Course] {
    [enhancedBasicsCourse, enhancedStandardCourse, enhancedAdvancedCourse]
}
