// ObservableObjectは自分のデータが変わったことをView に通知する役割
// @Published の通知を発行する側

/// The current collection of space photos.
class Photos: ObservableObject {
    @Published private(set) var items: [SpacePhoto] = []

    /// Updates `items` to a new, random list of photos.
    func updateItems() async {
        let fetched = fetchPhotos()
        items = fetched
    }

    /// Fetches a new, random list of photos.
    func fetchPhotos() -> [SpacePhoto] {
        let downloaded: [SpacePhoto] = []
        for _ in randomPhotoDates() {
        }
        return downloaded
    }
}