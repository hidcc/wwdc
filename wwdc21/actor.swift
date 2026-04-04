// data raceを防ぐために使用される
// awaitで受け取る
// 一度に1つの同期的なコードブロックを実行する。

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