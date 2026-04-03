//2つのスレッドが同時に同じ可変データにアクセスして発生するデータ競合の例

class Counter {
    var value = 0

    func increment() -> Int {
        value = value + 1
        return value
    }
}

let counter = Counter()

Task.detached {
    print(counter.increment()) // data race
}

Task.detached {
    print(counter.increment()) // data race
}