//引っ張ってリロード

struct CatalogView: View {
    @StateObject private var photos = Photos()

    var body: some View {
        NavigationView {
            List {
                ForEach(photos.items) { item in
                    PhotoView(photo: item)
                        .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Catalog")
            .listStyle(.plain)
            .refreshable {
                await photos.updateItems()
            }
        }
        .task {
            await photos.updateItems()
        }
    }
}