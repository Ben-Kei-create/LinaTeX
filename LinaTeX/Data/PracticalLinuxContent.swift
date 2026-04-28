import SwiftUI

// MARK: - Practical Real-World Linux Content

// Real-world scenario lessons for deeper learning
let practicalRealWorldLessons = [
    // Data processing scenario
    Lesson(
        title: "大規模ログファイルの解析",
        emoji: "📊",
        estimatedMinutes: 15,
        content: .scenario(ScenarioLesson(
            setup: "本番サーバーのログファイルから、特定のエラーを抽出・統計し、問題を特定します。",
            goal: "grep, awk, sort を組み合わせたログ解析",
            steps: [
                ScenarioStep(
                    prompt: "server.log のサイズを確認します。",
                    hint: "wc -l server.log",
                    answer: "wc",
                    options: [
                        CommandOption(label: "wc", command: "wc", icon: "sum"),
                        CommandOption(label: "stat", command: "stat", icon: "doc.text.fill"),
                        CommandOption(label: "du", command: "du", icon: "externaldrive"),
                    ],
                    simulatedOutput: "   156248 server.log"
                ),
                ScenarioStep(
                    prompt: "ERROR を含むエントリの数をカウントします。",
                    hint: "grep -c ERROR server.log",
                    answer: "grep",
                    options: [
                        CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
                        CommandOption(label: "awk", command: "awk", icon: "square.and.pencil"),
                        CommandOption(label: "sed", command: "sed", icon: "pencil"),
                    ],
                    simulatedOutput: "245"
                ),
                ScenarioStep(
                    prompt: "最も頻出のエラーメッセージを取得します（重複除去）。",
                    hint: "grep ERROR server.log | sort | uniq -c | sort -rn | head -1",
                    answer: "uniq",
                    options: [
                        CommandOption(label: "uniq", command: "uniq", icon: "square.stack"),
                        CommandOption(label: "sort", command: "sort", icon: "arrow.up.arrow.down"),
                        CommandOption(label: "group", command: "group", icon: "person.2.fill"),
                    ],
                    simulatedOutput: "    87 Connection timeout"
                ),
            ],
            finaleMessage: "✅ ログ解析のプロフェッショナルになりました！"
        ))
    ),

    // User and permission scenario
    Lesson(
        title: "マルチユーザー環境の権限管理",
        emoji: "👥",
        estimatedMinutes: 14,
        content: .scenario(ScenarioLesson(
            setup: "チーム開発環境で、複数のユーザーがプロジェクトファイルにアクセスする権限を設定します。",
            goal: "chmod と chown で適切な権限を設定",
            steps: [
                ScenarioStep(
                    prompt: "project ファイルの所有者を確認します。",
                    hint: "ls -l project",
                    answer: "ls",
                    options: [
                        CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                        CommandOption(label: "stat", command: "stat", icon: "doc.text.fill"),
                        CommandOption(label: "file", command: "file", icon: "doc"),
                    ],
                    simulatedOutput: "-rw-r--r-- 1 alice developers 2048 Jan 15 10:00 project"
                ),
                ScenarioStep(
                    prompt: "project をグループ alice_team に変更します。",
                    hint: "chown :alice_team project",
                    answer: "chown",
                    options: [
                        CommandOption(label: "chown", command: "chown", icon: "person.fill"),
                        CommandOption(label: "chgrp", command: "chgrp", icon: "person.2.fill"),
                        CommandOption(label: "chmod", command: "chmod", icon: "lock"),
                    ],
                    simulatedOutput: "user@linux:~$ chown :alice_team project\nuser@linux:~$"
                ),
                ScenarioStep(
                    prompt: "グループメンバーも書き込み可能にします（-rw-rw-r--）。",
                    hint: "chmod g+w project",
                    answer: "chmod",
                    options: [
                        CommandOption(label: "chmod", command: "chmod", icon: "lock.open"),
                        CommandOption(label: "chown", command: "chown", icon: "person.fill"),
                        CommandOption(label: "chgrp", command: "chgrp", icon: "person.2"),
                    ],
                    simulatedOutput: "user@linux:~$ chmod g+w project\nuser@linux:~$ ls -l project\n-rw-rw-r-- 1 alice alice_team 2048 Jan 15 10:00 project"
                ),
            ],
            finaleMessage: "✅ マルチユーザー環境の権限管理ができるようになりました！"
        ))
    ),

    // Processes and system monitoring
    Lesson(
        title: "システムプロセスの監視と管理",
        emoji: "⚙️",
        estimatedMinutes: 12,
        content: .scenario(ScenarioLesson(
            setup: "サーバーのプロセスを監視し、問題のあるプロセスを終了します。",
            goal: "ps, top, kill でプロセス管理を行う",
            steps: [
                ScenarioStep(
                    prompt: "実行中のプロセス一覧を表示します。",
                    hint: "ps aux",
                    answer: "ps",
                    options: [
                        CommandOption(label: "ps", command: "ps", icon: "square.fill"),
                        CommandOption(label: "top", command: "top", icon: "chart.bar.fill"),
                        CommandOption(label: "list", command: "list", icon: "list.bullet"),
                    ],
                    simulatedOutput: "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND\nroot         1  0.0  0.1  19116  1244 ?        Ss   10:00   0:00 /sbin/init\nalice     5432  2.3  5.6 512000 45000 ?        S    10:05   0:15 /usr/bin/apache2"
                ),
                ScenarioStep(
                    prompt: "CPU使用率が高いプロセスをリアルタイム表示します。",
                    hint: "top",
                    answer: "top",
                    options: [
                        CommandOption(label: "top", command: "top", icon: "chart.bar.fill"),
                        CommandOption(label: "htop", command: "htop", icon: "chart.bar"),
                        CommandOption(label: "ps", command: "ps", icon: "square.fill"),
                    ],
                    simulatedOutput: "PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND\n 2341 www-data  20   0  112000  45000  12000 S   95.0  45.0   2:30.45 apache2"
                ),
                ScenarioStep(
                    prompt: "問題のあるプロセス（PID 2341）を強制終了します。",
                    hint: "kill -9 2341",
                    answer: "kill",
                    options: [
                        CommandOption(label: "kill", command: "kill", icon: "xmark.circle"),
                        CommandOption(label: "pkill", command: "pkill", icon: "xmark.circle.fill"),
                        CommandOption(label: "stop", command: "stop", icon: "stop.fill"),
                    ],
                    simulatedOutput: "user@linux:~$ kill -9 2341\nuser@linux:~$"
                ),
            ],
            finaleMessage: "✅ システム監視と問題解決ができるようになりました！"
        ))
    ),

    // Package management and system updates
    Lesson(
        title: "パッケージ管理とシステム更新",
        emoji: "📦",
        estimatedMinutes: 11,
        content: .scenario(ScenarioLesson(
            setup: "システムの重要なパッケージを更新し、セキュリティを維持します。",
            goal: "apt-get による基本的なパッケージ管理",
            steps: [
                ScenarioStep(
                    prompt: "インストール済みパッケージ一覧を表示します。",
                    hint: "apt list --installed | head",
                    answer: "apt",
                    options: [
                        CommandOption(label: "apt", command: "apt", icon: "square.stack"),
                        CommandOption(label: "dpkg", command: "dpkg", icon: "archive"),
                        CommandOption(label: "yum", command: "yum", icon: "package"),
                    ],
                    simulatedOutput: "adduser/focal 3.118ubuntu1 all\napt/focal-updates 2.0.9ubuntu0.1 amd64\nbase-files/focal 11ubuntu5.1 amd64\nbase-passwd/focal 3.5.47 amd64"
                ),
                ScenarioStep(
                    prompt: "パッケージリストを更新します。",
                    hint: "sudo apt update",
                    answer: "apt",
                    options: [
                        CommandOption(label: "apt", command: "apt", icon: "arrow.clockwise"),
                        CommandOption(label: "refresh", command: "refresh", icon: "arrow.clockwise.circle"),
                        CommandOption(label: "update", command: "update", icon: "arrow.up"),
                    ],
                    simulatedOutput: "Get:1 http://security.ubuntu.com/ubuntu focal-security InRelease [101 kB]\nFetched 5.2 MB in 2s\nReading package lists... Done"
                ),
                ScenarioStep(
                    prompt: "セキュリティ更新を含む全パッケージをアップグレードします。",
                    hint: "sudo apt upgrade",
                    answer: "apt",
                    options: [
                        CommandOption(label: "apt", command: "apt", icon: "arrow.up"),
                        CommandOption(label: "upgrade", command: "upgrade", icon: "square.stack"),
                        CommandOption(label: "patch", command: "patch", icon: "checkmark.circle"),
                    ],
                    simulatedOutput: "Processing triggers for libc-bin (2.31-13ubuntu9)...\nDone"
                ),
            ],
            finaleMessage: "✅ パッケージ管理のマスターになりました！"
        ))
    ),
]

// Advanced knowledge quiz for system administration
let systemAdminQuiz = Lesson(
    title: "Linuxシステム管理総合クイズ",
    emoji: "🎓",
    estimatedMinutes: 12,
    content: .quiz(QuizLesson(
        questions: [
            QuizQuestion(
                question: "umask 022 の意味は？",
                choices: [
                    "新しいファイルのデフォルト権限から 022 をマスク",
                    "ファイルのパーミッションを 022 に設定",
                    "ユーザー権限を制限する",
                    "セキュリティレベルの設定"
                ],
                correctIndex: 0,
                explanation: "umask は新しいファイルのパーミッション設定時に適用される権限マスク。umask 022 だと 666-022=644 になります。"
            ),
            QuizQuestion(
                question: "/etc ディレクトリの役割は？",
                choices: [
                    "設定ファイルを保存するディレクトリ",
                    "実行可能ファイルを保存",
                    "一時ファイルを保存",
                    "ユーザーのホームディレクトリ"
                ],
                correctIndex: 0,
                explanation: "/etc はシステムの設定ファイル全般を保持。/etc/passwd, /etc/hosts, /etc/fstab など重要なファイルがあります。"
            ),
            QuizQuestion(
                question: "cron ジョブの用途は？",
                choices: [
                    "定期的なタスク（スケジュール実行）",
                    "リアルタイム処理",
                    "ファイル同期",
                    "プロセス監視"
                ],
                correctIndex: 0,
                explanation: "cron は定期的なタスク実行に使用。crontab -e で編集、自動バックアップやログローテーションなどに活用。"
            ),
            QuizQuestion(
                question: "sudo の役割は？",
                choices: [
                    "一般ユーザーが管理者権限でコマンドを実行",
                    "スーパーユーザーになる",
                    "ユーザー切り替え",
                    "パスワード変更"
                ],
                correctIndex: 0,
                explanation: "sudo は Super User DO。一般ユーザーが必要な管理者コマンドのみ実行可能に。セキュリティと利便性のバランスが取れます。"
            ),
            QuizQuestion(
                question: "inode とは何か？",
                choices: [
                    "ファイルのメタデータ（所有者、権限、サイズなど）を保持する構造",
                    "ファイルの内容そのもの",
                    "ファイル名を保存する場所",
                    "ディレクトリの別名"
                ],
                correctIndex: 0,
                explanation: "inode はファイルシステムのメタデータ。各ファイル/ディレクトリが一意の inode を持ち、i-node 番号で管理。"
            ),
        ]
    ))
)
