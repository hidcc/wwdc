// WWDC21: Discover concurrency in SwiftUI
// @MainActorで保護されたObservableObject

import Foundation

// --- なぜ@MainActorが必要か ---
// SwiftUIのランループ: イベント受信 → モデル更新 → 画面描画 のサイクルで動く
// @Publishedの値が変わると、SwiftUIはスナップショットを撮って比較する
// もしバックグラウンドスレッドからデータを変えると、
// スナップショットとの比較がおかしくなり、画面がバグる（data race）
//
// @MainActorをつけると、このクラスのプロパティやメソッドは
// 必ずメインスレッドで実行されることがコンパイラに保証される

@MainActor
class Photos: ObservableObject {
    @Published private(set) var items: [SpacePhoto] = []

    // 写真一覧を更新する
    func updateItems() async {
        let fetched = await fetchPhotos()
        // @MainActorなので、ここは必ずメインスレッドで実行される
        // → @Publishedの更新が安全
        items = fetched

        // NASA APIがレート制限の場合、サンプルデータにフォールバック
        if items.isEmpty {
            print("⚠️ API returned no results, using sample data")
            items = SpacePhoto.sampleData
        }
    }

    // 複数の写真を取得する
    func fetchPhotos() async -> [SpacePhoto] {
        var downloaded: [SpacePhoto] = []
        for date in randomPhotoDates() {
            let url = SpacePhoto.requestURL(for: date)
            if let photo = await fetchPhoto(from: url) {
                downloaded.append(photo)
            }
        }
        return downloaded
    }

    // 1枚の写真を取得する
    func fetchPhoto(from url: URL) async -> SpacePhoto? {
        do {
            // awaitで待っている間、メインアクターは他の仕事（画面描画など）ができる
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted({
                let f = DateFormatter()
                f.dateFormat = "yyyy-MM-dd"
                return f
            }())
            return try decoder.decode(SpacePhoto.self, from: data)
        } catch {
            print("⚠️ fetch failed for \(url): \(error)")
            return nil
        }
    }

    // デモ用: ランダムな日付を生成
    private func randomPhotoDates() -> [Date] {
        let calendar = Calendar.current
        return (1...10).compactMap { daysAgo in
            calendar.date(byAdding: .day, value: -daysAgo, to: Date())
        }
    }
}

// NASA APOD APIのURL生成
extension SpacePhoto {
    static func requestURL(for date: Date) -> URL {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        // 実際にはAPI Keyが必要
        return URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=\(dateString)")!
    }
}
