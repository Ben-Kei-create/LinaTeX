import Foundation

// MARK: - Full Curriculum

let allCourses: [Course] = [
    // MARK: - BASICS COURSE
    Course(
        level: .basics,
        title: "Linuxの基本",
        subtitle: "ターミナルの世界へようこそ",
        description: "Linuxの基礎から始めます。ターミナル操作、ファイルシステム、基本コマンドを習得します。",
        emoji: "🐧",
        estimatedMinutes: 90,
        chapters: [
            // Chapter 1: Introduction
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
                    Lesson(
                        title: "pwd - 今ここはどこ？",
                        emoji: "📍",
                        estimatedMinutes: 8,
                        content: .quest(QuestLesson(
                            scenario: "Linuxのファイルシステムはツリー構造です。あなたは今、どこにいるでしょう？",
                            prompt: "現在のディレクトリ（フォルダ）の位置を確認するコマンドは？",
                            hint: "Print Working Directory の略です。pwd と打ってみましょう。",
                            answer: "pwd",
                            options: [
                                CommandOption(label: "pwd", command: "pwd", icon: "mappin.circle.fill"),
                                CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                CommandOption(label: "cd", command: "cd", icon: "chevron.right"),
                            ],
                            simulatedOutput: "/home/user",
                            successMessage: "✅ 完璧！あなたは /home/user にいます"
                        ))
                    ),
                ]
            ),

            // Chapter 2: Navigation and Files
            Chapter(
                number: 2,
                title: "ファイルシステムを探検する",
                summary: "ls, cd コマンドを使ってファイルシステムを歩き回ります",
                lessons: [
                    Lesson(
                        title: "ls - ファイル一覧を見る",
                        emoji: "📂",
                        estimatedMinutes: 8,
                        content: .quest(QuestLesson(
                            scenario: "現在のフォルダに何が入っているか見たい。",
                            prompt: "ファイルやフォルダの一覧を表示するコマンドは？",
                            hint: "List の略です。ls と打つだけ。",
                            answer: "ls",
                            options: [
                                CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                CommandOption(label: "pwd", command: "pwd", icon: "mappin.circle.fill"),
                                CommandOption(label: "cat", command: "cat", icon: "doc.text"),
                            ],
                            simulatedOutput: "Desktop  Documents  Downloads  Pictures  Videos",
                            successMessage: "✅ いいね！フォルダの中身が見えました"
                        ))
                    ),
                    Lesson(
                        title: "cd - ディレクトリを移動する",
                        emoji: "🚀",
                        estimatedMinutes: 8,
                        content: .quest(QuestLesson(
                            scenario: "Desktop フォルダに移動したい。",
                            prompt: "ディレクトリを移動するコマンドは？",
                            hint: "Change Directory の略。cd Desktop で Desktop に移動します。",
                            answer: "cd",
                            options: [
                                CommandOption(label: "cd", command: "cd", icon: "chevron.right"),
                                CommandOption(label: "mv", command: "mv", icon: "arrow.right.doc.fill"),
                                CommandOption(label: "pwd", command: "pwd", icon: "mappin.circle.fill"),
                            ],
                            simulatedOutput: "",
                            successMessage: "✅ 移動完了！Desktop に到着しました"
                        ))
                    ),
                    Lesson(
                        title: "パスの理解",
                        emoji: "🗺️",
                        estimatedMinutes: 7,
                        content: .concept(ConceptLesson(
                            headline: "絶対パスと相対パス",
                            sections: [
                                ConceptSection(
                                    heading: "2つのパス指定方法",
                                    body: "絶対パス: / から始まる完全なパス\n/home/user/Documents\n\n相対パス: 現在地からの相対的なパス\nDocuments （現在が /home/user の場合）\n../ （1つ上のフォルダ）",
                                    codeSample: "cd /home/user/Documents  # 絶対パス\ncd Documents              # 相対パス（/home/user にいる場合）",
                                    tip: "~ はホームディレクトリのショートカット。cd ~ でいつでも家に帰れます"
                                )
                            ]
                        ))
                    ),
                ]
            ),

            // Chapter 3: Creating and Managing Files
            Chapter(
                number: 3,
                title: "ファイルを作る・見る・操作する",
                summary: "mkdir, touch, cat, cp, mv, rm コマンドでファイル操作をマスター",
                lessons: [
                    Lesson(
                        title: "mkdir - フォルダを作成",
                        emoji: "🗂️",
                        estimatedMinutes: 6,
                        content: .quest(QuestLesson(
                            scenario: "プロジェクト用のフォルダを作りたい。",
                            prompt: "新しいディレクトリを作成するコマンドは？",
                            hint: "Make Directory の略です。",
                            answer: "mkdir",
                            options: [
                                CommandOption(label: "mkdir", command: "mkdir", icon: "folder.badge.plus"),
                                CommandOption(label: "touch", command: "touch", icon: "doc.badge.plus"),
                                CommandOption(label: "cp", command: "cp", icon: "doc.on.doc"),
                            ],
                            simulatedOutput: "",
                            successMessage: "✅ フォルダを作成しました！"
                        ))
                    ),
                    Lesson(
                        title: "touch - ファイルを作成",
                        emoji: "📄",
                        estimatedMinutes: 6,
                        content: .quest(QuestLesson(
                            scenario: "空のファイルを作りたい。",
                            prompt: "ファイルを作成するコマンドは？",
                            hint: "touch = ファイルに「触れて」作成。touch myfile.txt",
                            answer: "touch",
                            options: [
                                CommandOption(label: "touch", command: "touch", icon: "doc.badge.plus"),
                                CommandOption(label: "mkdir", command: "mkdir", icon: "folder.badge.plus"),
                                CommandOption(label: "echo", command: "echo", icon: "quote.bubble"),
                            ],
                            simulatedOutput: "",
                            successMessage: "✅ ファイルを作成しました！"
                        ))
                    ),
                    Lesson(
                        title: "cat - ファイルの中身を見る",
                        emoji: "👀",
                        estimatedMinutes: 7,
                        content: .quest(QuestLesson(
                            scenario: "テキストファイルの中身を確認したい。",
                            prompt: "ファイルの内容を表示するコマンドは？",
                            hint: "concatenate (連結) の略。cat filename.txt",
                            answer: "cat",
                            options: [
                                CommandOption(label: "cat", command: "cat", icon: "doc.text"),
                                CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                CommandOption(label: "echo", command: "echo", icon: "quote.bubble"),
                            ],
                            simulatedOutput: "Hello, Linux!\nThis is my first file.",
                            successMessage: "✅ ファイルの中身が読めました！"
                        ))
                    ),
                    Lesson(
                        title: "cp - ファイルをコピー",
                        emoji: "📋",
                        estimatedMinutes: 7,
                        content: .quest(QuestLesson(
                            scenario: "大事なファイルをバックアップしたい。",
                            prompt: "ファイルをコピーするコマンドは？",
                            hint: "Copy の略。cp 元ファイル コピー先",
                            answer: "cp",
                            options: [
                                CommandOption(label: "cp", command: "cp", icon: "doc.on.doc"),
                                CommandOption(label: "mv", command: "mv", icon: "arrow.right.doc.fill"),
                                CommandOption(label: "rm", command: "rm", icon: "trash"),
                            ],
                            simulatedOutput: "",
                            successMessage: "✅ ファイルをコピーしました！"
                        ))
                    ),
                    Lesson(
                        title: "mv - ファイルを移動・改名",
                        emoji: "✂️",
                        estimatedMinutes: 7,
                        content: .quest(QuestLesson(
                            scenario: "ファイルを別のフォルダに移したい。または改名したい。",
                            prompt: "ファイルを移動・改名するコマンドは？",
                            hint: "Move の略。mv 元ファイル 移動先",
                            answer: "mv",
                            options: [
                                CommandOption(label: "mv", command: "mv", icon: "arrow.right.doc.fill"),
                                CommandOption(label: "cp", command: "cp", icon: "doc.on.doc"),
                                CommandOption(label: "rm", command: "rm", icon: "trash"),
                            ],
                            simulatedOutput: "",
                            successMessage: "✅ ファイルを移動しました！"
                        ))
                    ),
                    Lesson(
                        title: "rm - ファイルを削除",
                        emoji: "🗑️",
                        estimatedMinutes: 7,
                        content: .quest(QuestLesson(
                            scenario: "不要なファイルを削除したい。⚠️ 削除したら戻せません！",
                            prompt: "ファイルを削除するコマンドは？",
                            hint: "Remove の略。rm filename.txt   ⚠️ 慎重に！",
                            answer: "rm",
                            options: [
                                CommandOption(label: "rm", command: "rm", icon: "trash.fill"),
                                CommandOption(label: "mv", command: "mv", icon: "arrow.right.doc.fill"),
                                CommandOption(label: "cp", command: "cp", icon: "doc.on.doc"),
                            ],
                            simulatedOutput: "",
                            successMessage: "✅ ファイルを削除しました。（二度と戻りません）"
                        ))
                    ),
                ]
            ),
        ]
    ),

    // MARK: - STANDARD COURSE (Skeleton with samples)
    Course(
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
                        title: "パイプ | - コマンドをつなぐ",
                        emoji: "⛓️",
                        estimatedMinutes: 10,
                        content: .concept(ConceptLesson(
                            headline: "複数のコマンドを組み合わせる力",
                            sections: [
                                ConceptSection(
                                    heading: "パイプの威力",
                                    body: "パイプ | は、前のコマンドの出力を次のコマンドの入力にします。\n\nこれにより、複数のコマンドを組み合わせて強力な処理ができます。",
                                    codeSample: "cat file.txt | grep 'error' | wc -l\n↓\nfile.txt の内容 → grep で 'error' を含む行 → wc -l で行数",
                                    tip: "Linuxの哲学：1つのコマンドは1つのことをうまくやる。パイプで組み合わせて大きな仕事をする"
                                )
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
                            scenario: "スクリプトを実行可能にしたい。",
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
                        title: "権限の読み方",
                        emoji: "📖",
                        estimatedMinutes: 8,
                        content: .concept(ConceptLesson(
                            headline: "rwx の意味を理解する",
                            sections: [
                                ConceptSection(
                                    heading: "3桁の権限",
                                    body: "-rwxr-xr-x\n\nr (read) = 読む\nw (write) = 書く\nx (execute) = 実行\n\n最初の3文字: 所有者\n次の3文字: グループ\n最後の3文字: その他",
                                    codeSample: "-rwxr-xr-x\nowner:rwx, group:r-x, others:r-x",
                                    tip: "chmod 755 で rwxr-xr-x になります（755はよく使う）"
                                )
                            ]
                        ))
                    ),
                ]
            ),
        ]
    ),

    // MARK: - ADVANCED COURSE (Skeleton with samples)
    Course(
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
                                    body: "毎日同じコマンドを何度も打つのは無駄。\nシェルスクリプトに書いておけば、1コマンドで全て実行できます。\n\n例：バックアップ、ログ処理、定期メンテナンス",
                                    codeSample: "#!/bin/bash\necho 'Hello, World!'\nls -la\ndate",
                                    tip: "最初の行 #!/bin/bash はシェバング（shebang）。このファイルが Bash スクリプトだと宣言"
                                )
                            ]
                        ))
                    ),
                    Lesson(
                        title: "初めてのスクリプト",
                        emoji: "🎯",
                        estimatedMinutes: 15,
                        content: .scenario(ScenarioLesson(
                            setup: "バックアップスクリプトを作成して実行します。",
                            goal: "スクリプトを作成 → 実行可能に → 実行する",
                            steps: [
                                ScenarioStep(
                                    prompt: "テキストエディタでスクリプトファイルを作成。vim または nano を使います。",
                                    hint: "touch backup.sh で空ファイルを作成、nano backup.sh で編集",
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
                                    hint: "./backup.sh で実行",
                                    answer: "bash",
                                    options: [
                                        CommandOption(label: "bash", command: "bash", icon: "terminal.fill"),
                                        CommandOption(label: "cat", command: "cat", icon: "doc.text"),
                                        CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
                                    ],
                                    simulatedOutput: "Backup completed!"
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
                                    body: "Secure Shell (SSH) は、ネットワークを通じて安全に遠いコンピュータにログインできます。\n\n使い方：ssh user@hostname\n\nクラウドサーバー、VPS、社内サーバーを操作できます。",
                                    codeSample: "ssh user@example.com\nssh -p 2222 user@192.168.1.100",
                                    tip: "本番サーバーはほぼ必ず SSH で操作します。Linux エンジニア必須スキル"
                                )
                            ]
                        ))
                    ),
                    Lesson(
                        title: "curl - Webからデータ取得",
                        emoji: "📡",
                        estimatedMinutes: 10,
                        content: .quest(QuestLesson(
                            scenario: "Webサイトの内容をダウンロードしたい。",
                            prompt: "URLからデータを取得するコマンドは？",
                            hint: "curl https://example.com",
                            answer: "curl",
                            options: [
                                CommandOption(label: "curl", command: "curl", icon: "network"),
                                CommandOption(label: "wget", command: "wget", icon: "arrow.down.doc"),
                                CommandOption(label: "ssh", command: "ssh", icon: "link"),
                            ],
                            simulatedOutput: "<!DOCTYPE html>\n<html>\n  <head>...",
                            successMessage: "✅ データを取得しました！"
                        ))
                    ),
                ]
            ),
        ]
    ),
]
