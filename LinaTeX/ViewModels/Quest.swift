import SwiftUI

struct Quest: Identifiable {
    let id: Int
    let emoji: String
    let title: String
    let description: String
    let hint: String
    let answer: String
    let commandOptions: [CommandOption]
    let successMessage: String
    let outputSimulation: String
    let accentColor: Color

    struct CommandOption: Identifiable {
        let id = UUID()
        let label: String
        let command: String
        let icon: String
    }
}

let allQuests: [Quest] = [
    Quest(
        id: 1,
        emoji: "📍",
        title: "今いる場所を確認しよう",
        description: "Linuxでは「今どこにいるか」がとても大切。\n現在のディレクトリを確認するコマンドは？",
        hint: "Print Working Directory の略だよ",
        answer: "pwd",
        commandOptions: [
            Quest.CommandOption(label: "pwd", command: "pwd", icon: "mappin.circle.fill"),
            Quest.CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
            Quest.CommandOption(label: "cd", command: "cd", icon: "chevron.right"),
        ],
        successMessage: "完璧！今いる場所が確認できたね 🗺️",
        outputSimulation: "/home/user",
        accentColor: .cyan
    ),
    Quest(
        id: 2,
        emoji: "📂",
        title: "ファイル一覧を見てみよう",
        description: "このフォルダに何が入ってるか見てみよう。\nファイルやフォルダを一覧表示するコマンドは？",
        hint: "List の略。ls と打つだけ！",
        answer: "ls",
        commandOptions: [
            Quest.CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
            Quest.CommandOption(label: "pwd", command: "pwd", icon: "mappin.circle.fill"),
            Quest.CommandOption(label: "cat", command: "cat", icon: "doc.text"),
        ],
        successMessage: "いいね！ファイルが全部見えたね 👀",
        outputSimulation: "Desktop  Documents  Downloads  Pictures",
        accentColor: .green
    ),
    Quest(
        id: 3,
        emoji: "🗂️",
        title: "新しいフォルダを作ろう",
        description: "プロジェクト用のフォルダを作りたい！\n新しいディレクトリを作成するコマンドは？",
        hint: "Make Directory の略だよ",
        answer: "mkdir",
        commandOptions: [
            Quest.CommandOption(label: "touch", command: "touch", icon: "doc.badge.plus"),
            Quest.CommandOption(label: "mkdir", command: "mkdir", icon: "folder.badge.plus"),
            Quest.CommandOption(label: "cp", command: "cp", icon: "doc.on.doc"),
        ],
        successMessage: "フォルダ作成成功！ 🎉",
        outputSimulation: "",
        accentColor: .yellow
    ),
    Quest(
        id: 4,
        emoji: "📄",
        title: "新しいファイルを作ろう",
        description: "空のファイルを新規作成したい。\nファイルを作るコマンドはどれ？",
        hint: "touch = 触れる。ファイルに「触れて」作る感覚",
        answer: "touch",
        commandOptions: [
            Quest.CommandOption(label: "mkdir", command: "mkdir", icon: "folder.badge.plus"),
            Quest.CommandOption(label: "touch", command: "touch", icon: "doc.badge.plus"),
            Quest.CommandOption(label: "echo", command: "echo", icon: "quote.bubble"),
        ],
        successMessage: "ファイル作成完了！✨",
        outputSimulation: "",
        accentColor: .orange
    ),
    Quest(
        id: 5,
        emoji: "👀",
        title: "ファイルの中身を見よう",
        description: "ファイルの中に何が書いてあるか見たい！\n中身を表示するコマンドは？",
        hint: "猫（cat）みたいに中身を「にゃー」と出す",
        answer: "cat",
        commandOptions: [
            Quest.CommandOption(label: "cat", command: "cat", icon: "doc.text"),
            Quest.CommandOption(label: "ls", command: "ls", icon: "list.bullet"),
            Quest.CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
        ],
        successMessage: "ファイルの中身が読めたね 📖",
        outputSimulation: "Hello, Linux! This is my first file.",
        accentColor: .purple
    ),
    Quest(
        id: 6,
        emoji: "🚀",
        title: "ディレクトリを移動しよう",
        description: "別のフォルダに移動したい！\nディレクトリを移動するコマンドは？",
        hint: "Change Directory の略。cd /path で移動",
        answer: "cd",
        commandOptions: [
            Quest.CommandOption(label: "cd", command: "cd", icon: "chevron.right"),
            Quest.CommandOption(label: "mv", command: "mv", icon: "arrow.right.doc.fill"),
            Quest.CommandOption(label: "pwd", command: "pwd", icon: "mappin.circle.fill"),
        ],
        successMessage: "移動完了！新しい場所に到着 🗺️",
        outputSimulation: "",
        accentColor: .mint
    ),
    Quest(
        id: 7,
        emoji: "📋",
        title: "ファイルをコピーしよう",
        description: "大切なファイルをバックアップしたい！\nファイルをコピーするコマンドは？",
        hint: "Copy の略。cp 元ファイル コピー先",
        answer: "cp",
        commandOptions: [
            Quest.CommandOption(label: "mv", command: "mv", icon: "arrow.right.doc.fill"),
            Quest.CommandOption(label: "cp", command: "cp", icon: "doc.on.doc.fill"),
            Quest.CommandOption(label: "rm", command: "rm", icon: "trash"),
        ],
        successMessage: "コピー完了！バックアップできたね 💾",
        outputSimulation: "",
        accentColor: .blue
    ),
    Quest(
        id: 8,
        emoji: "✂️",
        title: "ファイルを移動しよう",
        description: "ファイルを別の場所に移したい！（名前変更にも使えるよ）\n移動するコマンドは？",
        hint: "Move の略。cp と似てるけど元は消える",
        answer: "mv",
        commandOptions: [
            Quest.CommandOption(label: "cp", command: "cp", icon: "doc.on.doc.fill"),
            Quest.CommandOption(label: "mv", command: "mv", icon: "arrow.right.doc.fill"),
            Quest.CommandOption(label: "rm", command: "rm", icon: "trash"),
        ],
        successMessage: "移動成功！ファイルが引越したよ 📦",
        outputSimulation: "",
        accentColor: .indigo
    ),
    Quest(
        id: 9,
        emoji: "🗑️",
        title: "ファイルを削除しよう",
        description: "不要なファイルを消したい。\n⚠️ 削除したら元に戻せないので注意！\n削除するコマンドは？",
        hint: "Remove の略。取り消し不可なので慎重に！",
        answer: "rm",
        commandOptions: [
            Quest.CommandOption(label: "rm", command: "rm", icon: "trash.fill"),
            Quest.CommandOption(label: "mv", command: "mv", icon: "arrow.right.doc.fill"),
            Quest.CommandOption(label: "cp", command: "cp", icon: "doc.on.doc.fill"),
        ],
        successMessage: "削除完了！でも慎重にね ⚠️",
        outputSimulation: "",
        accentColor: .red
    ),
    Quest(
        id: 10,
        emoji: "🔍",
        title: "テキストを検索しよう",
        description: "ファイルの中から特定の文字を探したい！\n文字列を検索するコマンドは？",
        hint: "grep = Global Regular Expression Print",
        answer: "grep",
        commandOptions: [
            Quest.CommandOption(label: "find", command: "find", icon: "magnifyingglass.circle"),
            Quest.CommandOption(label: "cat", command: "cat", icon: "doc.text"),
            Quest.CommandOption(label: "grep", command: "grep", icon: "magnifyingglass"),
        ],
        successMessage: "検索マスター！grep は超強力だよ 🔍",
        outputSimulation: "Hello, Linux!",
        accentColor: .teal
    ),
]
