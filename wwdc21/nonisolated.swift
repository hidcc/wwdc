// letなどの定数はactorで隔離する必要がないので明示的にnonisolated と書く

actor LibraryAccount {
    let idNumber: Int
    var booksOnLoan: [Book] = []
}

extension LibraryAccount: Hashable {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(idNumber)
    }
}