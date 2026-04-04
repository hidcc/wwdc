// @MainActor　メインスレッド専用のactor
// task{}　半構造化タスク

@MainActor
class MyDelegate: UICollectionViewDelegate {
    var thumbnailTasks: [IndexPath: Task<Void, Never>] = [:]
    
    func collectionView(_ view: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt item: IndexPath) {
        let ids = getThumbnailIDs(for: item)
        thumbnailTasks[item] = Task {
            defer { thumbnailTasks[item] = nil }
            let thumbnails = await fetchThumbnails(for: ids)
            display(thumbnails, in: cell)
        }
    }
    
    func collectionView(_ view: UICollectionView, didEndDisplay cell: UICollectionViewCell, forItemAt item: IndexPath) {
        thumbnailTasks[item]?.cancel()
    }
}