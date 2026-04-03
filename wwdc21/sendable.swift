//Sendable と書くことで安全にコピーできるという証明になる

struct Book: Sendable {
    var title: String
    var authors: [Author]
}