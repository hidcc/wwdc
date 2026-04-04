//Sendable 行コンテキスト間で安全に渡せる

struct Book: Sendable {
    var title: String
    var authors: [Author]
}