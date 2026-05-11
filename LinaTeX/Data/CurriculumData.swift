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
    // Basics quiz
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
                    question: "ファイル important.doc を削除するコマンドは？",
                    choices: ["rm important.doc", "mv important.doc /trash", "rmdir important.doc", "delete important.doc"],
                    correctIndex: 0,
                    explanation: "rm でファイルを削除します。削除後は復旧できないため、-i オプションで確認することをお勧めします。"
                ),
                QuizQuestion(
                    question: "ファイルの名前を old_name.txt から new_name.txt に変更するコマンドは？",
                    choices: ["mv old_name.txt new_name.txt", "cp old_name.txt new_name.txt", "rename old_name.txt new_name.txt", "rn old_name.txt new_name.txt"],
                    correctIndex: 0,
                    explanation: "mv でファイルをリネーム（移動）します。同じディレクトリ内での mv は名前変更になります。"
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
            summary: "Linuxとは何か、ターミナルとは何か、基本的な概念を学びます",
            lessons: [
                Lesson(
                    title: "Linuxって何？",
                    emoji: "🤔",
                    estimatedMinutes: 5,
                    content: .concept(ConceptLesson(
                        headline: "Linuxは自由で強力なOS",
                        sections: [
                            ConceptSection(
                                heading: "Linuxとは",
                                body: "Linuxはオープンソースのオペレーティングシステムです。Windows や macOS と同じく、コンピュータを制御するソフトウェアです。\n\n特徴：\n• 無料で利用可能\n• ソースコード公開\n• 世界中で開発・改良\n• サーバーから組み込みまで幅広く使用",
                                codeSample: nil,
                                tip: "Linuxはカーネル（中核部分）の名前で、Linuxカーネル + GNU ツール = GNU/Linux と呼びます"
                            ),
                            ConceptSection(
                                heading: "なぜLinuxを学ぶのか",
                                body: "• Web サーバー（Apache, Nginx）はLinux上で動く\n• クラウド（AWS, GCP）はLinux\n• 開発環境で使われることが多い\n• 組み込みデバイス（スマートフォンなど）で使われている",
                                codeSample: nil,
                                tip: nil
                            )
                        ]
                    ))
                ),
                Lesson(
                    title: "ターミナルとシェル",
                    emoji: "⌨️",
                    estimatedMinutes: 5,
                    content: .concept(ConceptLesson(
                        headline: "ターミナルはLinuxとの会話窓口",
                        sections: [
                            ConceptSection(
                                heading: "ターミナルとは",
                                body: "ターミナルは、キーボードでコマンドを入力し、コンピュータに指示を出すプログラムです。\n\nGUIで「ファイルをダブルクリック」する代わりに、ターミナルでは「ls コマンド」でファイルを見ます。",
                                codeSample: nil,
                                tip: "ターミナルは「真の力」です。複数の操作を一度にできたり、自動化したり、リモートサーバーを操作できます"
                            ),
                            ConceptSection(
                                heading: "プロンプトの読み方",
                                body: "user@linux:~$ ← これがプロンプト\n\n• user: ログインしているユーザー名\n• linux: コンピュータの名前\n• ~: 現在のディレクトリ（~はホームディレクトリ）\n• $: コマンド入力待機中（#だと管理者権限）",
                                codeSample: "user@linux:~$ _",
                                tip: nil
                            )
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
                        simulatedOutput: "",
                        successMessage: "✅ src フォルダに移動しました。pwd で確認してみてください！"
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
                    title: "権限管理クイズ",
                    emoji: "🎯",
                    estimatedMinutes: 8,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "useradd -m の -m オプションは何をする？",
                                choices: ["ホームディレクトリを作成", "ユーザーをマスク", "メイングループを指定", "メールボックスを作成"],
                                correctIndex: 0,
                                explanation: "-m（mkdir）でホームディレクトリを作成。デフォルトは /home/username"
                            ),
                            QuizQuestion(
                                question: "usermod -aG の G オプションは？",
                                choices: ["追加グループを指定（グループにユーザーを追加）", "グループを作成", "グループを削除", "ゲストアクセスを許可"],
                                correctIndex: 0,
                                explanation: "-G で追加グループ。-a を付けると既存グループに追加（-G のみだと上書き）"
                            ),
                            QuizQuestion(
                                question: "sudo 権限を持つには？",
                                choices: ["ユーザーを sudo グループに追加", "UID を 0 に変更", "chmod で実行権限を追加", "su で昇格"],
                                correctIndex: 0,
                                explanation: "sudo グループのメンバーが sudo コマンドを実行可能。/etc/sudoers で詳細設定も可能"
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
                    title: "systemctl 管理クイズ",
                    emoji: "🎓",
                    estimatedMinutes: 8,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "systemctl enable の役割は？",
                                choices: ["システム起動時にサービスを自動開始するよう登録", "サービスを即座に開始", "サービスの設定ファイルを編集", "ログを表示"],
                                correctIndex: 0,
                                explanation: "enable で起動時の自動実行を有効化。disable で無効化。start は即座に開始。"
                            ),
                            QuizQuestion(
                                question: "systemctl reload と restart の違いは？",
                                choices: ["reload は設定を再読み込み（プロセス継続）、restart はプロセス再起動", "同じ", "reload は設定を削除", "restart は新規インストール"],
                                correctIndex: 0,
                                explanation: "reload: 設定ファイル再読み込み（ダウンタイムなし）。restart: プロセス再起動（ダウンタイムあり）"
                            ),
                            QuizQuestion(
                                question: "systemctl list-units --type=service は？",
                                choices: ["全サービスのリストと状態を表示", "ユーザーのサービスのみ表示", "システムサービスのコピーを作成", "サービスを検索"],
                                correctIndex: 0,
                                explanation: "全サービスと状態を表示。--all でロードされていないユニットも表示。"
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
                    title: "プロセス管理クイズ",
                    emoji: "💭",
                    estimatedMinutes: 8,
                    content: .quiz(QuizLesson(
                        questions: [
                            QuizQuestion(
                                question: "kill -9 と kill -15 の違いは？",
                                choices: ["-15 は SIGTERM（正常終了）、-9 は SIGKILL（強制終了）", "同じシグナル", "-9 は アーカイブ作成", "-15 は 削除"],
                                correctIndex: 0,
                                explanation: "kill -15（SIGTERM）は プロセスに正常終了するよう要求。kill -9（SIGKILL）は 強制終了（キャッチ不可）"
                            ),
                            QuizQuestion(
                                question: "top コマンドで CPU 使用率でソートするキーは？",
                                choices: ["P キー", "M キー", "C キー", "S キー"],
                                correctIndex: 0,
                                explanation: "top 実行中に P キーで CPU 使用率、M キーでメモリ使用率でソート。"
                            ),
                            QuizQuestion(
                                question: "ps aux の STAT 列で R は何を表す？",
                                choices: ["Running（実行中）", "Resident（常駐）", "Read-only（読み込み専用）", "Restarting（再起動中）"],
                                correctIndex: 0,
                                explanation: "R: 実行中, S: スリープ中, Z: ゾンビプロセス, T: 停止中"
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
