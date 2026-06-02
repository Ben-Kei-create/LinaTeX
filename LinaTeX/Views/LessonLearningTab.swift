import SwiftUI

// MARK: - Lesson Learning Tab View

struct LessonLearningTabView: View {
    let lesson: Lesson
    let course: Course

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(course.level.modernSoft)
                        .frame(width: 36, height: 36)
                    Image(systemName: "book.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(course.level.modernColor)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("学習資料")
                        .font(ModernFont.headlineMedium)
                        .foregroundColor(ModernTheme.textPrimary)
                    Text("まずは内容を読んで理解しましょう")
                        .font(ModernFont.bodySmall)
                        .foregroundColor(ModernTheme.textSecondary)
                }
                Spacer()
            }
            .padding(.horizontal, 20)

            switch lesson.content {
            case .concept(let concept):
                ConceptLessonView(concept: concept, course: course)

            case .scenario(let scenario):
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(ModernTheme.success.opacity(0.12))
                                    .frame(width: 34, height: 34)
                                Image(systemName: "terminal.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(ModernTheme.success)
                            }
                            Text("使うコマンド")
                                .font(ModernFont.headlineSmall)
                                .foregroundColor(ModernTheme.textPrimary)
                            Spacer()
                        }

                        CommandReferenceList(
                            commands: uniqueLearningCommands(scenario.steps.map(\.answer)),
                            color: course.level.modernColor
                        )
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ModernTheme.bgCard)
                    )
                    .shadow(color: ModernTheme.shadowColor, radius: 8, x: 0, y: 2)
                }
                .padding(.horizontal, 20)

            case .quest(let quest):
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(ModernTheme.success.opacity(0.12))
                                    .frame(width: 34, height: 34)
                                Image(systemName: "terminal.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(ModernTheme.success)
                            }
                            Text("今回のコマンド")
                                .font(ModernFont.headlineSmall)
                                .foregroundColor(ModernTheme.textPrimary)
                            Spacer()
                        }

                        CommandReferenceList(
                            commands: uniqueLearningCommands([quest.answer]),
                            color: course.level.modernColor
                        )
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ModernTheme.bgCard)
                    )
                    .shadow(color: ModernTheme.shadowColor, radius: 8, x: 0, y: 2)
                }
                .padding(.horizontal, 20)

            case .quiz(let quiz):
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(course.level.modernColor.opacity(0.12))
                                    .frame(width: 34, height: 34)
                                Image(systemName: "questionmark.circle.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(course.level.modernColor)
                            }
                            Text("クイズについて")
                                .font(ModernFont.headlineSmall)
                                .foregroundColor(ModernTheme.textPrimary)
                            Spacer()
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            Text("全\(quiz.questions.count)問のクイズが出題されます。各問題を丁寧に読んで、正しい選択肢を選んでください。")
                                .font(ModernFont.bodyMedium)
                                .foregroundColor(ModernTheme.textPrimary)
                                .lineSpacing(6)

                            HStack(spacing: 10) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(ModernTheme.warning)
                                Text("間違えてもその場で解説が確認できます")
                                    .font(ModernFont.bodySmall)
                                    .foregroundColor(ModernTheme.textSecondary)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(ModernTheme.warningSoft.opacity(0.5))
                            )
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ModernTheme.bgCard)
                    )
                    .shadow(color: ModernTheme.shadowColor, radius: 8, x: 0, y: 2)
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Command Learning References

private struct CommandLearningPoint {
    let command: String
    let title: String
    let description: String
}

private func uniqueLearningCommands(_ commands: [String]) -> [String] {
    var seen: Set<String> = []
    var result: [String] = []

    for command in commands.map(commandLearningKey) where !command.isEmpty {
        if !seen.contains(command) {
            seen.insert(command)
            result.append(command)
        }
    }

    return result
}

private func commandLearningKey(_ rawCommand: String) -> String {
    let normalized = normalizedCommandLine(rawCommand)
    if normalized.hasPrefix("./") {
        return "./script"
    }
    return normalized.split(separator: " ").first.map(String.init) ?? normalized
}

private func commandLearningPoint(for command: String) -> CommandLearningPoint {
    switch command {
    case "pwd":
        return CommandLearningPoint(command: command, title: "現在地を確認", description: "いま作業しているディレクトリのパスを表示します。")
    case "ls":
        return CommandLearningPoint(command: command, title: "一覧を表示", description: "ファイルやフォルダの名前を確認します。")
    case "cd":
        return CommandLearningPoint(command: command, title: "場所を移動", description: "作業するディレクトリを切り替えます。")
    case "cp":
        return CommandLearningPoint(command: command, title: "コピー", description: "元のファイルを残したまま、別名や別の場所へ複製します。")
    case "mv":
        return CommandLearningPoint(command: command, title: "移動・名前変更", description: "ファイルを別の場所へ移す、または名前を変えるときに使います。")
    case "rm":
        return CommandLearningPoint(command: command, title: "削除", description: "不要になったファイルを消します。対象を慎重に確認してから使います。")
    case "cat":
        return CommandLearningPoint(command: command, title: "内容を表示", description: "短いテキストファイルの中身をターミナルへ出力します。")
    case "grep":
        return CommandLearningPoint(command: command, title: "検索", description: "テキストの中から条件に合う行を探します。")
    case "wc":
        return CommandLearningPoint(command: command, title: "数える", description: "行数、単語数、バイト数などを集計します。")
    case "chmod":
        return CommandLearningPoint(command: command, title: "権限を変更", description: "ファイルを読める人、書ける人、実行できる人を設定します。")
    case "touch":
        return CommandLearningPoint(command: command, title: "ファイルを作成", description: "空のファイルを作る、または更新時刻を変更します。")
    case "./script":
        return CommandLearningPoint(command: "./script", title: "スクリプトを実行", description: "実行権限のあるスクリプトを現在の場所から起動します。")
    case "ssh":
        return CommandLearningPoint(command: command, title: "遠隔接続", description: "リモートサーバーへ安全にログインして操作します。")
    case "curl":
        return CommandLearningPoint(command: command, title: "データ取得", description: "URLやAPIからデータを取得します。")
    case "jq":
        return CommandLearningPoint(command: command, title: "JSON整形", description: "JSONデータを読みやすく整形したり、必要な値を取り出したりします。")
    default:
        return CommandLearningPoint(command: command, title: "コマンドの役割", description: "問題の目的に合わせて、入力するコマンドを選びます。")
    }
}

private struct CommandReferenceList: View {
    let commands: [String]
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(commands, id: \.self) { command in
                CommandReferenceRow(point: commandLearningPoint(for: command), color: color)
            }
        }
    }
}

private struct CommandReferenceRow: View {
    let point: CommandLearningPoint
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(point.command)
                .font(ModernFont.codeMedium)
                .foregroundColor(color)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.10))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(point.title)
                    .font(ModernFont.bodyEmphasizedSmall)
                    .foregroundColor(ModernTheme.textPrimary)
                Text(point.description)
                    .font(ModernFont.bodySmall)
                    .foregroundColor(ModernTheme.textSecondary)
                    .lineSpacing(3)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
