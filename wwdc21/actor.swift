// data raceを防ぐために使用される
// awaitで受け取る
// 一度に一つの処理しか実行を許可しない

actor Counter {
    var value = 0

    func increment() -> Int {
        value = value + 1
        return value
    }
}

let counter = Counter()

Task.detached {
    print(await counter.increment())
}

Task.detached {
    print(await counter.increment())
}