//TaskGroupを使用することで動的な数の並列実行ができる。

func fetchThumbnails(for ids: [String]) async throws -> [String: UIImage] {
    var thumbnails: [String: UIImage] = [:]
    try await withThrowingTaskGroup(of: Void.self) { group in
        for id in ids {
            group.async {
                thumbnails[id] = try await fetchOneThumbnail(withID: id)
            }
        }
    }
    return thumbnails
}