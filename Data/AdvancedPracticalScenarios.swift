import SwiftUI

// MARK: - Advanced Practical Scenarios for STANDARD & ADVANCED levels

let advancedPracticalCourses = [
    // STANDARD Level
    Course(
        level: .standard,
        title: "開発環境のセットアップ",
        subtitle: "実際のプロジェクト開発に必要なスキル",
        description: "Gitを使ったバージョン管理、パッケージ管理など実務的なスキル",
        emoji: "⚙️",
        estimatedMinutes: 90,
        chapters: [
            Chapter(
                number: 1,
                title: "ファイルシステムの権限管理",
                summary: "セキュリティと実行権限の設定",
                lessons: [
                    Lesson(
                        title: "スクリプトに実行権限を付与",
                        emoji: "🔐",
                        estimatedMinutes: 20,
                        content: .scenario(ScenarioLesson(
                            setup: "deploy.sh というシェルスクリプトをデプロイに使用したいです\n\n要件:\n- deploy.sh の権限を確認\n- 実行権限（x）を追加\n- オーナーの変更（root に）\n- 権限を確認",
                            goal: "chmod と chown で適切なファイル権限を管理する",
                            steps: [
                                ScenarioStep(
                                    prompt: "ステップ1: deploy.sh の現在の権限を確認してください",
                                    hint: "ls -l コマンドで詳細情報を表示します",
                                    answer: "ls -l deploy.sh",
                                    options: [
                                        CommandOption(label: "ls -l deploy.sh", command: "ls -l deploy.sh", icon: "checkmark"),
                                        CommandOption(label: "stat deploy.sh", command: "stat deploy.sh", icon: "checkmark"),
                                        CommandOption(label: "file deploy.sh", command: "file deploy.sh", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ ls -l deploy.sh\n-rw-r--r-- 1 user user 512 Apr 23 10:00 deploy.sh\n$ ",
                                ),
                                ScenarioStep(
                                    prompt: "ステップ2: deploy.sh に実行権限を追加してください",
                                    hint: "chmod +x コマンドを使用します",
                                    answer: "chmod +x deploy.sh",
                                    options: [
                                        CommandOption(label: "chmod +x deploy.sh", command: "chmod +x deploy.sh", icon: "checkmark"),
                                        CommandOption(label: "chmod 755 deploy.sh", command: "chmod 755 deploy.sh", icon: "checkmark"),
                                        CommandOption(label: "chmod x deploy.sh", command: "chmod x deploy.sh", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ chmod +x deploy.sh\n$ ",
                                ),
                                ScenarioStep(
                                    prompt: "ステップ3: 権限が正しく変更されたか確認してください",
                                    hint: "ls -l で x（実行権限）が表示されているか確認します",
                                    answer: "ls -l deploy.sh",
                                    options: [
                                        CommandOption(label: "ls -l deploy.sh", command: "ls -l deploy.sh", icon: "checkmark"),
                                        CommandOption(label: "chmod -l deploy.sh", command: "chmod -l deploy.sh", icon: "xmark"),
                                        CommandOption(label: "stat deploy.sh", command: "stat deploy.sh", icon: "checkmark")
                                    ],
                                    simulatedOutput: "$ ls -l deploy.sh\n-rwxr-xr-x 1 user user 512 Apr 23 10:00 deploy.sh\n$ ",
                                ),
                                ScenarioStep(
                                    prompt: "ステップ4: スクリプトを実行してテストしてください",
                                    hint: "./ で現在のディレクトリのファイルを実行します",
                                    answer: "./deploy.sh",
                                    options: [
                                        CommandOption(label: "./deploy.sh", command: "./deploy.sh", icon: "checkmark"),
                                        CommandOption(label: "bash deploy.sh", command: "bash deploy.sh", icon: "checkmark"),
                                        CommandOption(label: "run deploy.sh", command: "run deploy.sh", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ ./deploy.sh\nDeploying application...\n✓ Deployment successful\n$ ",
                                )
                            ],
                            finaleMessage: "✓ 権限管理をマスターしました！セキュアなシステム運用ができます"
                        ))
                    )
                ]
            ),
            Chapter(
                number: 2,
                title: "プロセス管理とリソース監視",
                summary: "実行中のプロセスの制御と確認",
                lessons: [
                    Lesson(
                        title: "バックグラウンドジョブの管理",
                        emoji: "⚡",
                        estimatedMinutes: 25,
                        content: .scenario(ScenarioLesson(
                            setup: "長時間かかるバッチ処理スクリプト（backup.sh）が実行中です\n\nやること:\n- 現在のプロセスを確認\n- バックアップスクリプトを検索\n- プロセスID（PID）を特定\n- メモリ使用量を確認",
                            goal: "ps と grep でプロセス管理を学習する",
                            steps: [
                                ScenarioStep(
                                    prompt: "ステップ1: 現在実行中の全プロセスを確認してください",
                                    hint: "ps aux コマンドで詳細情報を表示します",
                                    answer: "ps aux",
                                    options: [
                                        CommandOption(label: "ps aux", command: "ps aux", icon: "checkmark"),
                                        CommandOption(label: "ps -ef", command: "ps -ef", icon: "checkmark"),
                                        CommandOption(label: "top", command: "top", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ ps aux\nUSER PID %CPU %MEM COMMAND\nuser 1234 25.5 15.2 backup.sh\n$ ",
                                ),
                                ScenarioStep(
                                    prompt: "ステップ2: backup.sh プロセスだけを抽出してください",
                                    hint: "ps aux と grep をパイプで接続します",
                                    answer: "ps aux | grep backup.sh",
                                    options: [
                                        CommandOption(label: "ps aux | grep backup.sh", command: "ps aux | grep backup.sh", icon: "checkmark"),
                                        CommandOption(label: "grep backup.sh ps aux", command: "grep backup.sh ps aux", icon: "xmark"),
                                        CommandOption(label: "find backup.sh", command: "find backup.sh", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ ps aux | grep backup.sh\nuser 1234 25.5 15.2 /bin/bash backup.sh\n$ ",
                                ),
                                ScenarioStep(
                                    prompt: "ステップ3: backup.sh のプロセスID（PID）を確認しました（1234）。詳細情報を表示してください",
                                    hint: "ps -p PID -o オプションで詳細指定できます",
                                    answer: "ps -p 1234 -o pid,user,%cpu,%mem,cmd",
                                    options: [
                                        CommandOption(label: "ps -p 1234 -o pid,user,%cpu,%mem,cmd", command: "ps -p 1234 -o pid,user,%cpu,%mem,cmd", icon: "checkmark"),
                                        CommandOption(label: "top -p 1234", command: "top -p 1234", icon: "checkmark"),
                                        CommandOption(label: "ps 1234", command: "ps 1234", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ ps -p 1234 -o pid,user,%cpu,%mem,cmd\nPID USER %CPU %MEM CMD\n1234 user 25.5 15.2 /bin/bash backup.sh\n$ ",
                                )
                            ],
                            finaleMessage: "✓ プロセス管理ができました！本番環境での問題診断が可能です"
                        ))
                    )
                ]
            )
        ]
    ),

    // ADVANCED Level
    Course(
        level: .advanced,
        title: "Linux システム管理と最適化",
        subtitle: "企業レベルのシステム運用",
        description: "大規模システムの運用、セキュリティ管理、パフォーマンスチューニング",
        emoji: "🛡️",
        estimatedMinutes: 120,
        chapters: [
            Chapter(
                number: 1,
                title: "ディスク容量とファイルシステム",
                summary: "ディスク使用量の分析と最適化",
                lessons: [
                    Lesson(
                        title: "大容量ファイルを検出して管理",
                        emoji: "💾",
                        estimatedMinutes: 30,
                        content: .scenario(ScenarioLesson(
                            setup: "システムのディスク容量が不足しています\n\nタスク:\n- ディスク使用状況を確認\n- ホームディレクトリの使用量を確認\n- 100MB以上の大ファイルを検出\n- 古いログファイルを削除",
                            goal: "df, du, find コマンドでディスク管理を学習",
                            steps: [
                                ScenarioStep(
                                    prompt: "ステップ1: システム全体のディスク使用状況を確認してください",
                                    hint: "df -h コマンドで人間が読みやすい形式で表示します",
                                    answer: "df -h",
                                    options: [
                                        CommandOption(label: "df -h", command: "df -h", icon: "checkmark"),
                                        CommandOption(label: "du -h", command: "du -h", icon: "xmark"),
                                        CommandOption(label: "disk -h", command: "disk -h", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ df -h\nFilesystem Size Used Avail Use%\n/ 100G 85G 15G 85%\n$ ",
                                ),
                                ScenarioStep(
                                    prompt: "ステップ2: ホームディレクトリ（~）の使用量を確認してください",
                                    hint: "du -sh コマンドで合計を表示します",
                                    answer: "du -sh ~",
                                    options: [
                                        CommandOption(label: "du -sh ~", command: "du -sh ~", icon: "checkmark"),
                                        CommandOption(label: "du -sh /home", command: "du -sh /home", icon: "checkmark"),
                                        CommandOption(label: "du ~ -h", command: "du ~ -h", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ du -sh ~\n45G /home/user\n$ ",
                                ),
                                ScenarioStep(
                                    prompt: "ステップ3: ホームディレクトリ配下で100MB以上のファイルを検出してください",
                                    hint: "find -size +100M コマンドを使用します",
                                    answer: "find ~ -size +100M -type f",
                                    options: [
                                        CommandOption(label: "find ~ -size +100M -type f", command: "find ~ -size +100M -type f", icon: "checkmark"),
                                        CommandOption(label: "find ~ -size >100M", command: "find ~ -size >100M", icon: "xmark"),
                                        CommandOption(label: "ls -S ~ | head", command: "ls -S ~ | head", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ find ~ -size +100M -type f\n/home/user/videos/movie.mp4 (500M)\n/home/user/backup.tar.gz (200M)\n$ ",
                                ),
                                ScenarioStep(
                                    prompt: "ステップ4: /var/log ディレクトリの容量を確認してください",
                                    hint: "du -sh で合計容量を表示します",
                                    answer: "du -sh /var/log",
                                    options: [
                                        CommandOption(label: "du -sh /var/log", command: "du -sh /var/log", icon: "checkmark"),
                                        CommandOption(label: "du -h /var/log | sort -h | tail", command: "du -h /var/log | sort -h | tail", icon: "checkmark"),
                                        CommandOption(label: "ls -lh /var/log", command: "ls -lh /var/log", icon: "xmark")
                                    ],
                                    simulatedOutput: "$ du -sh /var/log\n8.5G /var/log\n$ ",
                                )
                            ],
                            finaleMessage: "✓ ディスク管理の達人です！本番環境のトラブル解決ができます"
                        ))
                    )
                ]
            )
        ]
    )
]
