// actorへのreentracyの対処例
// awaitの前後でactorの状態が変わりうるため、Taskをキャッシュして重複ダウンロードを防ぐ

actor ImageDownloader {

    private enum CacheEntry {
        case inProgress(Task<Image, Error>)
        case ready(Image)
    }

    private var cache: [URL: CacheEntry] = [:]

    func image(from url: URL) async throws -> Image? {
        if let cached = cache[url] {
            switch cached {
            case .ready(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            }
        }

        let task = Task {
            try await downloadImage(from: url)
        }

        cache[url] = .inProgress(task)

        do {
            let image = try await task.value
            cache[url] = .ready(image)
            return image
        } catch {
            cache[url] = nil
            throw error
        }
    }
}