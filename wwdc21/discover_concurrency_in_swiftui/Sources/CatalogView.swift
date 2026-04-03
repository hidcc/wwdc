// WWDC21: Discover concurrency in SwiftUI
// .task / .refreshable / AsyncImage の使い方

import SwiftUI

// --- メインの一覧画面 ---
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
            // .refreshable: 引っ張って更新（pull-to-refresh）
            // async closureなので、処理が終わったら自動でインジケータが消える
            .refreshable {
                await photos.updateItems()
            }
        }
        // .task: 画面が表示されたらデータ取得を開始
        // - onAppearと同じタイミングで呼ばれる
        // - 画面が消えたら自動でタスクがキャンセルされる
        // - ムダなネットワーク通信を防げる
        .task {
            await photos.updateItems()
        }
    }
}
