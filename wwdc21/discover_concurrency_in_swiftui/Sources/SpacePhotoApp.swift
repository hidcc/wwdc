// WWDC21: Discover concurrency in SwiftUI
// アプリのエントリーポイント

import SwiftUI

@main
struct SpacePhotoApp: App {
    var body: some Scene {
        WindowGroup {
            CatalogView()
        }
    }
}
