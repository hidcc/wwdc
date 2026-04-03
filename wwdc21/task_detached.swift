// Task.detachedにすることで親タスクのコンテキスト（actor, priority等）を継承せず、完全に独立したタスクとして実行される

@MainActor
class MyDelegate: UICollectionViewDelegate {
    var thumbnailTasks: [IndexPath: Task<Void, Never>] = [:]
    
    func collectionView(_ view: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt item: IndexPath) {
        let ids = getThumbnailIDs(for: item)
        thumbnailTasks[item] = Task {
            defer { thumbnailTasks[item] = nil }
            let thumbnails = await fetchThumbnails(for: ids)
            Task.detached(priority: .background) {
                writeToLocalCache(thumbnails)
            }
            display(thumbnails, in: cell)
        }
    }
}