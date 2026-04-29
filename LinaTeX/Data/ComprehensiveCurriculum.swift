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

// MARK: - Five hour curriculum

private func baseCourse(_ level: CourseLevel) -> Course {
    allCourses.first { $0.level == level }!
}

private func renumbered(_ chapters: [Chapter], startingAt start: Int) -> [Chapter] {
    chapters.enumerated().map { index, chapter in
        Chapter(
            number: start + index,
            title: chapter.title,
            summary: chapter.summary,
            lessons: chapter.lessons
        )
    }
}

let fieldResponseCourse = Course(
    level: .advanced,
    title: "超実践トラブル対応",
    subtitle: "ミニ障害を一連の操作で解決する",
    description: "調査、バックアップ、編集、再起動、確認、後片付けまでを、現場に近い小さなトラブル対応として通しで練習します。",
    emoji: "",
    estimatedMinutes: 100,
    chapters: [
        Chapter(
            number: 1,
            title: "まず状況をつかむ",
            summary: "500エラーが起きた検証環境で、場所、ファイル、ログを順に確認する",
            lessons: [
                Lesson(
                    title: "Webアプリが500を返す",
                    emoji: "",
                    estimatedMinutes: 18,
                    content: .scenario(ScenarioLesson(
                        setup: "検証環境のトップページで 500 エラーが出ています。原因を決めつけず、まず作業場所とログを確認してください。\n\n状況:\n- アプリは /srv/linatex にあります\n- ログは logs/app.log です\n- 設定ファイルは config/app.env です",
                        goal: "安全に状況確認を進め、設定変更前のバックアップまで完了する",
                        steps: [
                            ScenarioStep(
                                prompt: "アプリのディレクトリへ移動してください",
                                hint: "cd /srv/linatex",
                                answer: "cd /srv/linatex",
                                options: [
                                    CommandOption(label: "cd app", command: "cd /srv/linatex", icon: "arrow.right"),
                                    CommandOption(label: "ls app", command: "ls /srv/linatex", icon: "folder"),
                                    CommandOption(label: "pwd", command: "pwd", icon: "location")
                                ],
                                simulatedOutput: "$ cd /srv/linatex\n$ pwd\n/srv/linatex"
                            ),
                            ScenarioStep(
                                prompt: "ディレクトリの中身を、隠しファイルと権限も含めて確認してください",
                                hint: "ls -la",
                                answer: "ls -la",
                                options: [
                                    CommandOption(label: "list detail", command: "ls -la", icon: "list.bullet"),
                                    CommandOption(label: "move", command: "mv -la", icon: "xmark"),
                                    CommandOption(label: "read", command: "cat -la", icon: "xmark")
                                ],
                                simulatedOutput: "$ ls -la\ndrwxr-xr-x  config\ndrwxr-xr-x  logs\ndrwxr-xr-x  bin\n-rw-r--r--  README.md"
                            ),
                            ScenarioStep(
                                prompt: "最新ログの末尾40行を確認してください",
                                hint: "tail -n 40 logs/app.log",
                                answer: "tail -n 40 logs/app.log",
                                options: [
                                    CommandOption(label: "latest logs", command: "tail -n 40 logs/app.log", icon: "text.alignleft"),
                                    CommandOption(label: "delete logs", command: "rm logs/app.log", icon: "xmark"),
                                    CommandOption(label: "copy logs", command: "cp logs/app.log", icon: "xmark")
                                ],
                                simulatedOutput: "$ tail -n 40 logs/app.log\n[INFO] boot\n[ERROR] APP_PORT is empty\n[ERROR] failed to bind server"
                            ),
                            ScenarioStep(
                                prompt: "ERROR の行だけを抜き出してください",
                                hint: "grep ERROR logs/app.log",
                                answer: "grep ERROR logs/app.log",
                                options: [
                                    CommandOption(label: "grep error", command: "grep ERROR logs/app.log", icon: "magnifyingglass"),
                                    CommandOption(label: "find error", command: "find ERROR logs/app.log", icon: "xmark"),
                                    CommandOption(label: "count all", command: "wc -l logs/app.log", icon: "number")
                                ],
                                simulatedOutput: "$ grep ERROR logs/app.log\n[ERROR] APP_PORT is empty\n[ERROR] failed to bind server"
                            ),
                            ScenarioStep(
                                prompt: "設定を触る前に config/app.env のバックアップを作成してください",
                                hint: "cp config/app.env config/app.env.bak",
                                answer: "cp config/app.env config/app.env.bak",
                                options: [
                                    CommandOption(label: "backup env", command: "cp config/app.env config/app.env.bak", icon: "doc.on.doc"),
                                    CommandOption(label: "remove env", command: "rm config/app.env", icon: "xmark"),
                                    CommandOption(label: "move env", command: "mv config/app.env config/app.env.bak", icon: "xmark")
                                ],
                                simulatedOutput: "$ cp config/app.env config/app.env.bak\n$ ls config\napp.env  app.env.bak"
                            )
                        ],
                        finaleMessage: "調査とバックアップが完了しました。ここから安全に修正できます。"
                    ))
                ),
                Lesson(
                    title: "Vimで最小限の編集をする",
                    emoji: "",
                    estimatedMinutes: 10,
                    content: .concept(ConceptLesson(
                        headline: "現場で困らないVimの最小操作",
                        sections: [
                            ConceptSection(
                                heading: "なぜVimを少しだけ覚えるのか",
                                body: "サーバーにはGUIエディタがないことが多く、設定ファイルを直接直す場面があります。Vimを完璧に覚える必要はありません。開く、編集する、保存する、抜ける、の4つだけでまず十分です。",
                                codeSample: "vim config/app.env",
                                tip: "編集前に cp でバックアップを作ってから開くと安心です。"
                            ),
                            ConceptSection(
                                heading: "最小操作",
                                body: "i で入力モード、Esc で通常モード、:wq で保存して終了、:q! で保存せず終了です。迷ったら Esc を押して通常モードへ戻ります。",
                                codeSample: "i\nEsc\n:wq\n:q!",
                                tip: "Vimの中では、LinuxコマンドではなくVimの操作になります。"
                            )
                        ]
                    ))
                )
            ]
        ),
        Chapter(
            number: 2,
            title: "設定を直して復旧する",
            summary: "バックアップ済みの設定を編集し、再起動とヘルスチェックで復旧確認する",
            lessons: [
                Lesson(
                    title: "空のポート設定を直す",
                    emoji: "",
                    estimatedMinutes: 20,
                    content: .scenario(ScenarioLesson(
                        setup: "ログから APP_PORT が空であることが分かりました。config/app.env を編集して APP_PORT=8080 を入れ、再起動して確認します。\n\n前提:\n- バックアップは作成済み\n- 再起動スクリプトは bin/restart.sh\n- ヘルスチェックは http://localhost:8080/health",
                        goal: "設定編集から復旧確認までを、順番を崩さずに実行する",
                        steps: [
                            ScenarioStep(
                                prompt: "設定ファイル config/app.env を Vim で開いてください",
                                hint: "vim config/app.env",
                                answer: "vim config/app.env",
                                options: [
                                    CommandOption(label: "edit env", command: "vim config/app.env", icon: "square.and.pencil"),
                                    CommandOption(label: "show env", command: "cat config/app.env", icon: "doc.text"),
                                    CommandOption(label: "remove env", command: "rm config/app.env", icon: "xmark")
                                ],
                                simulatedOutput: "$ vim config/app.env\n# APP_PORT=8080 に修正して保存しました"
                            ),
                            ScenarioStep(
                                prompt: "APP_PORT の設定が入っているか確認してください",
                                hint: "grep APP_PORT config/app.env",
                                answer: "grep APP_PORT config/app.env",
                                options: [
                                    CommandOption(label: "check port", command: "grep APP_PORT config/app.env", icon: "magnifyingglass"),
                                    CommandOption(label: "count port", command: "wc -l config/app.env", icon: "number"),
                                    CommandOption(label: "move port", command: "mv APP_PORT config/app.env", icon: "xmark")
                                ],
                                simulatedOutput: "$ grep APP_PORT config/app.env\nAPP_PORT=8080"
                            ),
                            ScenarioStep(
                                prompt: "再起動スクリプトに実行権限を付けてください",
                                hint: "chmod +x bin/restart.sh",
                                answer: "chmod +x bin/restart.sh",
                                options: [
                                    CommandOption(label: "add execute", command: "chmod +x bin/restart.sh", icon: "lock.open"),
                                    CommandOption(label: "read only", command: "chmod 444 bin/restart.sh", icon: "lock"),
                                    CommandOption(label: "delete script", command: "rm bin/restart.sh", icon: "xmark")
                                ],
                                simulatedOutput: "$ chmod +x bin/restart.sh\n$ ls -la bin/restart.sh\n-rwxr-xr-x  bin/restart.sh"
                            ),
                            ScenarioStep(
                                prompt: "再起動スクリプトを実行してください",
                                hint: "bash bin/restart.sh",
                                answer: "bash bin/restart.sh",
                                options: [
                                    CommandOption(label: "restart", command: "bash bin/restart.sh", icon: "arrow.clockwise"),
                                    CommandOption(label: "backup", command: "cp bin/restart.sh", icon: "xmark"),
                                    CommandOption(label: "inspect", command: "cat bin/restart.sh", icon: "doc.text")
                                ],
                                simulatedOutput: "$ bash bin/restart.sh\nstopping linatex...\nstarting linatex...\nstatus: running"
                            ),
                            ScenarioStep(
                                prompt: "ヘルスチェックURLへアクセスして、復旧したか確認してください",
                                hint: "curl -I http://localhost:8080/health",
                                answer: "curl -I http://localhost:8080/health",
                                options: [
                                    CommandOption(label: "health check", command: "curl -I http://localhost:8080/health", icon: "network"),
                                    CommandOption(label: "open vim", command: "vim http://localhost:8080/health", icon: "xmark"),
                                    CommandOption(label: "remove health", command: "rm http://localhost:8080/health", icon: "xmark")
                                ],
                                simulatedOutput: "$ curl -I http://localhost:8080/health\nHTTP/1.1 200 OK\nContent-Type: application/json"
                            )
                        ],
                        finaleMessage: "設定修正、再起動、ヘルスチェックまで完了しました。"
                    ))
                ),
                Lesson(
                    title: "復旧作業の順番を確認",
                    emoji: "",
                    estimatedMinutes: 8,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "設定ファイルを編集する前に、まず行うべきことは？",
                                choices: ["バックアップを作る", "rm で消す", "すぐ再起動する", "権限を777にする"],
                                correctIndex: 0,
                                explanation: "設定変更は戻せる状態にしてから行います。cp で .bak を作るだけでも復旧の安全度が上がります。"
                            ),
                            QuizQuestion(
                                question: "Vimで保存して終了する操作は？",
                                choices: [":wq", ":q!", "Ctrl+C", "rm"],
                                correctIndex: 0,
                                explanation: ":wq は write and quit、保存して終了です。保存せずに抜けたいときは :q! を使います。"
                            ),
                            QuizQuestion(
                                question: "再起動後に最後に確認すべきことは？",
                                choices: ["ヘルスチェックやログで正常化を確認する", "ターミナルを閉じる", "バックアップを先に削除する", "設定ファイルを空にする"],
                                correctIndex: 0,
                                explanation: "再起動はゴールではありません。curl やログで、利用者に見える状態が戻ったか確認します。"
                            )
                        ]
                    ))
                )
            ]
        ),
        Chapter(
            number: 3,
            title: "容量トラブルを片付ける",
            summary: "ログ肥大化でバックアップが失敗した状況を、安全に調査して整理する",
            lessons: [
                Lesson(
                    title: "ログ肥大化でバックアップ失敗",
                    emoji: "",
                    estimatedMinutes: 18,
                    content: .scenario(ScenarioLesson(
                        setup: "夜間バックアップが失敗しました。原因はログディレクトリの肥大化かもしれません。\n\n状況:\n- 対象は /srv/linatex\n- ログは logs ディレクトリにあります\n- 古いデバッグログ logs/debug-old.log は削除対象です",
                        goal: "容量を確認し、必要なログを退避してから不要ファイルを削除する",
                        steps: [
                            ScenarioStep(
                                prompt: "ディスク容量を人間が読みやすい形式で確認してください",
                                hint: "df -h",
                                answer: "df -h",
                                options: [
                                    CommandOption(label: "disk free", command: "df -h", icon: "internaldrive"),
                                    CommandOption(label: "delete free", command: "rm -h", icon: "xmark"),
                                    CommandOption(label: "move free", command: "mv -h", icon: "xmark")
                                ],
                                simulatedOutput: "$ df -h\nFilesystem  Size  Used Avail Use%\n/dev/root    40G   37G  3.0G  93%"
                            ),
                            ScenarioStep(
                                prompt: "logs ディレクトリの合計サイズを確認してください",
                                hint: "du -sh logs",
                                answer: "du -sh logs",
                                options: [
                                    CommandOption(label: "logs size", command: "du -sh logs", icon: "chart.bar"),
                                    CommandOption(label: "logs list", command: "ls -sh", icon: "list.bullet"),
                                    CommandOption(label: "logs remove", command: "rm -sh logs", icon: "xmark")
                                ],
                                simulatedOutput: "$ du -sh logs\n2.8G logs"
                            ),
                            ScenarioStep(
                                prompt: "logs 配下のファイルを検索してください",
                                hint: "find logs -type f",
                                answer: "find logs -type f",
                                options: [
                                    CommandOption(label: "find files", command: "find logs -type f", icon: "magnifyingglass"),
                                    CommandOption(label: "grep files", command: "grep logs -type f", icon: "xmark"),
                                    CommandOption(label: "touch files", command: "touch logs -type f", icon: "xmark")
                                ],
                                simulatedOutput: "$ find logs -type f\nlogs/app.log\nlogs/access.log\nlogs/debug-old.log"
                            ),
                            ScenarioStep(
                                prompt: "logs ディレクトリをアーカイブにまとめてください",
                                hint: "tar -czf logs_20260429.tar.gz logs",
                                answer: "tar -czf logs_20260429.tar.gz logs",
                                options: [
                                    CommandOption(label: "archive logs", command: "tar -czf logs_20260429.tar.gz logs", icon: "archivebox"),
                                    CommandOption(label: "delete logs", command: "rm -czf logs_20260429.tar.gz logs", icon: "xmark"),
                                    CommandOption(label: "move logs", command: "mv -czf logs_20260429.tar.gz logs", icon: "xmark")
                                ],
                                simulatedOutput: "$ tar -czf logs_20260429.tar.gz logs\n$ ls\nlogs  logs_20260429.tar.gz"
                            ),
                            ScenarioStep(
                                prompt: "不要な古いデバッグログ logs/debug-old.log を削除してください",
                                hint: "rm logs/debug-old.log",
                                answer: "rm logs/debug-old.log",
                                options: [
                                    CommandOption(label: "remove old log", command: "rm logs/debug-old.log", icon: "trash"),
                                    CommandOption(label: "remove all", command: "rm -rf logs", icon: "xmark"),
                                    CommandOption(label: "rename old log", command: "mv logs/debug-old.log", icon: "xmark")
                                ],
                                simulatedOutput: "$ rm logs/debug-old.log\n$ find logs -type f\nlogs/app.log\nlogs/access.log"
                            )
                        ],
                        finaleMessage: "容量確認、退避、不要ログ削除まで完了しました。"
                    ))
                )
            ]
        ),
        Chapter(
            number: 4,
            title: "総合ミニ障害対応",
            summary: "リモート接続からログ調査、設定修正、復旧確認までを通しで行う",
            lessons: [
                Lesson(
                    title: "夜間アラートを収束させる",
                    emoji: "",
                    estimatedMinutes: 24,
                    content: .scenario(ScenarioLesson(
                        setup: "夜間に『APIが不安定』というアラートが出ました。慌てて変更せず、リモート接続、ログ確認、設定修正、再起動、外形確認までを順に進めます。\n\n対象:\n- サーバー: ops@web-01.internal\n- アプリ: /srv/linatex\n- ログ: logs/app.log\n- 設定: config/app.env\n- 確認URL: https://linatex.example.com/health",
                        goal: "実務に近い一連の復旧手順を完走する",
                        steps: [
                            ScenarioStep(
                                prompt: "対象サーバーへSSH接続してください",
                                hint: "ssh ops@web-01.internal",
                                answer: "ssh ops@web-01.internal",
                                options: [
                                    CommandOption(label: "ssh server", command: "ssh ops@web-01.internal", icon: "network"),
                                    CommandOption(label: "curl server", command: "curl ops@web-01.internal", icon: "xmark"),
                                    CommandOption(label: "copy server", command: "cp ops@web-01.internal", icon: "xmark")
                                ],
                                simulatedOutput: "$ ssh ops@web-01.internal\nops@web-01:~$"
                            ),
                            ScenarioStep(
                                prompt: "アプリのディレクトリへ移動してください",
                                hint: "cd /srv/linatex",
                                answer: "cd /srv/linatex",
                                options: [
                                    CommandOption(label: "cd app", command: "cd /srv/linatex", icon: "arrow.right"),
                                    CommandOption(label: "ls app", command: "ls /srv/linatex", icon: "folder"),
                                    CommandOption(label: "pwd", command: "pwd", icon: "location")
                                ],
                                simulatedOutput: "$ cd /srv/linatex\n$ pwd\n/srv/linatex"
                            ),
                            ScenarioStep(
                                prompt: "ログから ERROR 行を確認してください",
                                hint: "grep ERROR logs/app.log",
                                answer: "grep ERROR logs/app.log",
                                options: [
                                    CommandOption(label: "grep error", command: "grep ERROR logs/app.log", icon: "magnifyingglass"),
                                    CommandOption(label: "tail all", command: "tail logs/app.log", icon: "text.alignleft"),
                                    CommandOption(label: "remove log", command: "rm logs/app.log", icon: "xmark")
                                ],
                                simulatedOutput: "$ grep ERROR logs/app.log\n[ERROR] upstream timeout\n[ERROR] missing RETRY_LIMIT"
                            ),
                            ScenarioStep(
                                prompt: "設定ファイルを編集する前にバックアップしてください",
                                hint: "cp config/app.env config/app.env.bak",
                                answer: "cp config/app.env config/app.env.bak",
                                options: [
                                    CommandOption(label: "backup env", command: "cp config/app.env config/app.env.bak", icon: "doc.on.doc"),
                                    CommandOption(label: "remove env", command: "rm config/app.env", icon: "xmark"),
                                    CommandOption(label: "move env", command: "mv config/app.env config/app.env.bak", icon: "xmark")
                                ],
                                simulatedOutput: "$ cp config/app.env config/app.env.bak"
                            ),
                            ScenarioStep(
                                prompt: "config/app.env を Vim で開き、RETRY_LIMIT=3 を追加してください",
                                hint: "vim config/app.env",
                                answer: "vim config/app.env",
                                options: [
                                    CommandOption(label: "edit env", command: "vim config/app.env", icon: "square.and.pencil"),
                                    CommandOption(label: "show env", command: "cat config/app.env", icon: "doc.text"),
                                    CommandOption(label: "delete env", command: "rm config/app.env", icon: "xmark")
                                ],
                                simulatedOutput: "$ vim config/app.env\n# RETRY_LIMIT=3 を追加して保存しました"
                            ),
                            ScenarioStep(
                                prompt: "アプリを再起動してください",
                                hint: "bash bin/restart.sh",
                                answer: "bash bin/restart.sh",
                                options: [
                                    CommandOption(label: "restart", command: "bash bin/restart.sh", icon: "arrow.clockwise"),
                                    CommandOption(label: "archive", command: "tar bin/restart.sh", icon: "xmark"),
                                    CommandOption(label: "delete", command: "rm bin/restart.sh", icon: "xmark")
                                ],
                                simulatedOutput: "$ bash bin/restart.sh\nstatus: running"
                            ),
                            ScenarioStep(
                                prompt: "外形監視用のURLで正常応答を確認してください",
                                hint: "curl -I https://linatex.example.com/health",
                                answer: "curl -I https://linatex.example.com/health",
                                options: [
                                    CommandOption(label: "check public", command: "curl -I https://linatex.example.com/health", icon: "network"),
                                    CommandOption(label: "edit public", command: "vim https://linatex.example.com/health", icon: "xmark"),
                                    CommandOption(label: "delete public", command: "rm https://linatex.example.com/health", icon: "xmark")
                                ],
                                simulatedOutput: "$ curl -I https://linatex.example.com/health\nHTTP/2 200\ncache-control: no-cache"
                            )
                        ],
                        finaleMessage: "夜間アラート対応を一通り完了しました。調査、保全、修正、確認の流れが実務の型です。"
                    ))
                )
            ]
        )
    ]
)

var comprehensiveAllCourses: [Course] {
    let basics = baseCourse(.basics)
    let standard = baseCourse(.standard)
    let advanced = baseCourse(.advanced)

    return [
        Course(
            level: .basics,
            title: "Linux基礎",
            subtitle: "場所、ファイル、移動を体で覚える",
            description: "pwd, ls, cd, mkdir, touch, cat, cp, mv, rm を、対象選択とセットで反復します。",
            emoji: "",
            estimatedMinutes: 75,
            chapters: renumbered(basics.chapters + enhancedBasicsCourse.chapters, startingAt: 1)
        ),
        Course(
            level: .standard,
            title: "実務ファイル操作",
            subtitle: "ログ、検索、権限、チーム作業",
            description: "grep, sed, wc, chmod, chown を、個別の現場シチュエーションで使います。",
            emoji: "",
            estimatedMinutes: 105,
            chapters: renumbered(
                standard.chapters + enhancedStandardCourse.chapters + [
                    Chapter(
                        number: 0,
                        title: "現場シチュエーション",
                        summary: "同じコマンドを別の状況で使い直す",
                        lessons: Array(practicalRealWorldLessons.prefix(2))
                    )
                ],
                startingAt: 1
            )
        ),
        Course(
            level: .advanced,
            title: "中堅実務",
            subtitle: "自動化、監視、デプロイ、通信",
            description: "bash, ssh, curl, jq, ps, top, kill, apt を、運用の流れとして身につけます。",
            emoji: "",
            estimatedMinutes: 120,
            chapters: renumbered(
                advanced.chapters + enhancedAdvancedCourse.chapters + [
                    Chapter(
                        number: 0,
                        title: "運用トラブル対応",
                        summary: "プロセス、パッケージ、総合知識を実務問題で確認",
                        lessons: Array(practicalRealWorldLessons.dropFirst(2)) + [systemAdminQuiz]
                    )
                ],
                startingAt: 1
            )
        ),
        fieldResponseCourse,
    ]
}
