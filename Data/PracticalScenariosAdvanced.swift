import SwiftUI

// MARK: - Practical Real-World Scenarios

let practicalScenarios = [
    // Level: BASICS
    Course(
        level: .basics,
        title: "ファイル管理の基礎",
        subtitle: "日常的なファイル操作",
        description: "実際のプロジェクトで必要なファイル操作を学習",
        emoji: "📁",
        estimatedMinutes: 45,
        chapters: [
            Chapter(
                number: 1,
                title: "プロジェクトフォルダの準備",
                summary: "新しいプロジェクトディレクトリを作成し、適切に整理する",
                lessons: [
                    Lesson(
                        title: "プロジェクトディレクトリを構築",
                        emoji: "🏗️",
                        estimatedMinutes: 15,
                        content: .scenario(ScenarioLesson(
                            setup: "新しいウェブプロジェクト『mywebsite』を開始します\n\n要件:\n- プロジェクトフォルダを作成\n- 内部に src, public, config の3つのサブフォルダを作成\n- 各フォルダにREADME.mdを配置",
                            goal: "正しいディレクトリ構造を作成して、プロジェクト開発の準備をする",
                            steps: [
                                ScenarioStep(
                                    prompt: "ステップ1: mywebsiteという名前のディレクトリを作成してください",
                                    hint: "mkdir コマンドを使用します",
                                    answer: "mkdir mywebsite",
                                    options: [
                                        CommandOption(label: "mkdir mywebsite", command: "mkdir mywebsite", icon: "folder.badge.plus"),
                                        CommandOption(label: "md mywebsite", command: "md mywebsite", icon: "xmark"),
                                        CommandOption(label: "touch mywebsite", command: "touch mywebsite", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ mkdir mywebsite\n$ ",
                                    id: UUID()
                                ),
                                ScenarioStep(
                                    prompt: "ステップ2: mywebsiteフォルダに移動してください",
                                    hint: "cd コマンドを使用します",
                                    answer: "cd mywebsite",
                                    options: [
                                        CommandOption(label: "cd mywebsite", command: "cd mywebsite", icon: "arrow.right"),
                                        CommandOption(label: "mv mywebsite", command: "mv mywebsite", icon: "xmark"),
                                        CommandOption(label: "ls mywebsite", command: "ls mywebsite", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ cd mywebsite\n$ ",
                                    id: UUID()
                                ),
                                ScenarioStep(
                                    prompt: "ステップ3: src, public, config の3つのフォルダを作成してください",
                                    hint: "複数のmkdir コマンドを一度に実行できます",
                                    answer: "mkdir src public config",
                                    options: [
                                        CommandOption(label: "mkdir src public config", command: "mkdir src public config", icon: "checkmark"),
                                        CommandOption(label: "mkdir -p src/public/config", command: "mkdir -p src/public/config", icon: "xmark"),
                                        CommandOption(label: "touch src public config", command: "touch src public config", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ mkdir src public config\n$ ",
                                    id: UUID()
                                ),
                                ScenarioStep(
                                    prompt: "ステップ4: 作成したフォルダ一覧を確認してください",
                                    hint: "ls コマンドで確認できます",
                                    answer: "ls",
                                    options: [
                                        CommandOption(label: "ls", command: "ls", icon: "arrow.right"),
                                        CommandOption(label: "ls -la", command: "ls -la", icon: "arrow.right"),
                                        CommandOption(label: "pwd", command: "pwd", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ ls\nconfig  public  src\n$ ",
                                    id: UUID()
                                ),
                                ScenarioStep(
                                    prompt: "ステップ5: src フォルダ内に index.html ファイルを作成してください",
                                    hint: "touch コマンドまたは > リダイレクションを使用できます",
                                    answer: "touch src/index.html",
                                    options: [
                                        CommandOption(label: "touch src/index.html", command: "touch src/index.html", icon: "checkmark"),
                                        CommandOption(label: "echo > src/index.html", command: "echo > src/index.html", icon: "checkmark"),
                                        CommandOption(label: "cp index.html src/", command: "cp index.html src/", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ touch src/index.html\n$ ",
                                    id: UUID()
                                )
                            ],
                            finaleMessage: "✓ プロジェクト構造の準備ができました！これで開発準備完了です"
                        ))
                    ),
                    Lesson(
                        title: "ファイルをコピーして配置",
                        emoji: "📋",
                        estimatedMinutes: 12,
                        content: .scenario(ScenarioLesson(
                            setup: "作成したプロジェクトに設定ファイルをセットアップします\n\n条件:\n- config フォルダに config.json を作成\n- public フォルダに style.css を作成\n- config.json を src フォルダにもコピー",
                            goal: "ファイルのコピーと配置を習得する",
                            steps: [
                                ScenarioStep(
                                    prompt: "ステップ1: config フォルダに config.json を作成してください",
                                    hint: "touch コマンドを使用します",
                                    answer: "touch config/config.json",
                                    options: [
                                        CommandOption(label: "touch config/config.json", command: "touch config/config.json", icon: "checkmark"),
                                        CommandOption(label: "create config/config.json", command: "create config/config.json", icon: "xmark"),
                                        CommandOption(label: "new config/config.json", command: "new config/config.json", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ touch config/config.json\n$ ",
                                    id: UUID()
                                ),
                                ScenarioStep(
                                    prompt: "ステップ2: config.json を src フォルダにコピーしてください",
                                    hint: "cp コマンドを使用します（cp ソース先）",
                                    answer: "cp config/config.json src/",
                                    options: [
                                        CommandOption(label: "cp config/config.json src/", command: "cp config/config.json src/", icon: "checkmark"),
                                        CommandOption(label: "copy config/config.json src/", command: "copy config/config.json src/", icon: "xmark"),
                                        CommandOption(label: "move config/config.json src/", command: "move config/config.json src/", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ cp config/config.json src/\n$ ",
                                    id: UUID()
                                ),
                                ScenarioStep(
                                    prompt: "ステップ3: public フォルダに style.css を作成してください",
                                    hint: "touch コマンドを使用します",
                                    answer: "touch public/style.css",
                                    options: [
                                        CommandOption(label: "touch public/style.css", command: "touch public/style.css", icon: "checkmark"),
                                        CommandOption(label: "echo > public/style.css", command: "echo > public/style.css", icon: "checkmark"),
                                        CommandOption(label: "mkdir public/style.css", command: "mkdir public/style.css", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ touch public/style.css\n$ ",
                                    id: UUID()
                                ),
                                ScenarioStep(
                                    prompt: "ステップ4: src フォルダの全ファイルを確認してください",
                                    hint: "ls コマンドにパスを指定します",
                                    answer: "ls src",
                                    options: [
                                        CommandOption(label: "ls src", command: "ls src", icon: "checkmark"),
                                        CommandOption(label: "ls -la src", command: "ls -la src", icon: "checkmark"),
                                        CommandOption(label: "cd src && ls", command: "cd src && ls", icon: "checkmark")
                                    ],
                                    simulatedOutput: "$ ls src\nconfig.json  index.html\n$ ",
                                    id: UUID()
                                )
                            ],
                            finaleMessage: "✓ ファイルの配置ができました！cp コマンドを習得しました"
                        ))
                    )
                ]
            ),
            Chapter(
                number: 2,
                title: "ファイルの検索と操作",
                summary: "大量のファイルから必要なファイルを見つけて操作",
                lessons: [
                    Lesson(
                        title: "ログファイルから情報を抽出",
                        emoji: "🔍",
                        estimatedMinutes: 18,
                        content: .scenario(ScenarioLesson(
                            setup: "プロジェクトの logs フォルダに複数のログファイルが存在します\n\nタスク:\n- app.log から 'ERROR' を含む行を抽出\n- app.log の行数をカウント\n- エラー行数をカウント",
                            goal: "grep と wc コマンドで効率的に情報を抽出する",
                            steps: [
                                ScenarioStep(
                                    prompt: "ステップ1: app.log ファイルを確認してください",
                                    hint: "cat または less コマンドで内容を表示します",
                                    answer: "cat app.log",
                                    options: [
                                        CommandOption(label: "cat app.log", command: "cat app.log", icon: "checkmark"),
                                        CommandOption(label: "less app.log", command: "less app.log", icon: "checkmark"),
                                        CommandOption(label: "head app.log", command: "head app.log", icon: "checkmark")
                                    ],
                                    simulatedOutput: "$ cat app.log\n[INFO] Server started\n[ERROR] Connection failed\n[INFO] Request received\n[ERROR] Timeout\n$ ",
                                    id: UUID()
                                ),
                                ScenarioStep(
                                    prompt: "ステップ2: app.log から 'ERROR' を含む行を抽出してください",
                                    hint: "grep コマンドを使用します",
                                    answer: "grep ERROR app.log",
                                    options: [
                                        CommandOption(label: "grep ERROR app.log", command: "grep ERROR app.log", icon: "checkmark"),
                                        CommandOption(label: "find ERROR app.log", command: "find ERROR app.log", icon: "xmark"),
                                        CommandOption(label: "search ERROR app.log", command: "search ERROR app.log", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ grep ERROR app.log\n[ERROR] Connection failed\n[ERROR] Timeout\n$ ",
                                    id: UUID()
                                ),
                                ScenarioStep(
                                    prompt: "ステップ3: app.log の総行数をカウントしてください",
                                    hint: "wc -l コマンドを使用します",
                                    answer: "wc -l app.log",
                                    options: [
                                        CommandOption(label: "wc -l app.log", command: "wc -l app.log", icon: "checkmark"),
                                        CommandOption(label: "count app.log", command: "count app.log", icon: "xmark"),
                                        CommandOption(label: "lines app.log", command: "lines app.log", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ wc -l app.log\n     4 app.log\n$ ",
                                    id: UUID()
                                ),
                                ScenarioStep(
                                    prompt: "ステップ4: ERROR の行数だけをカウントしてください（パイプを使用）",
                                    hint: "grep の出力を wc に渡します（|記号でパイプ接続）",
                                    answer: "grep ERROR app.log | wc -l",
                                    options: [
                                        CommandOption(label: "grep ERROR app.log | wc -l", command: "grep ERROR app.log | wc -l", icon: "checkmark"),
                                        CommandOption(label: "grep -c ERROR app.log", command: "grep -c ERROR app.log", icon: "checkmark"),
                                        CommandOption(label: "count grep ERROR app.log", command: "count grep ERROR app.log", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ grep ERROR app.log | wc -l\n     2\n$ ",
                                    id: UUID()
                                )
                            ],
                            finaleMessage: "✓ grep と wc でログファイル解析ができました！実務的な技能です"
                        ))
                    )
                ]
            )
        ]
    )
]
