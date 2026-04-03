// WWDC21: Discover concurrency in SwiftUI
// セッション10019 - 宇宙写真アプリのデータモデル

import Foundation

// 宇宙写真を表す構造体
// Codable: JSONとの変換ができる
// Identifiable: SwiftUIのListやForEachで使える
struct SpacePhoto: Codable, Identifiable {
    var title: String
    var description: String
    var date: Date
    var url: URL

    // dateをIDとして使う（日付ごとに1枚の写真）
    var id: Date { date }
}

// NASA APIからのレスポンスに合わせたCodingKeys
extension SpacePhoto {
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case date
        case url = "hdurl"
    }
}

// 写真をフォトライブラリに保存する機能
extension SpacePhoto {
    func save() async {
        // 画像データをダウンロード
        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return }
        // 実際のアプリではここでPHPhotoLibraryを使って保存する
        print("\(title) を保存しました (\(data.count) bytes)")
    }
}

// NASA APIがレート制限の場合に使うサンプルデータ
// 画像はNASAのパブリックドメイン画像を使用
extension SpacePhoto {
    static let sampleData: [SpacePhoto] = [
        SpacePhoto(
            title: "The Horsehead Nebula",
            description: "One of the most identifiable nebulae in the sky, the Horsehead Nebula in Orion, is part of a large, dark, molecular cloud.",
            date: makeDate("2026-04-03"),
            url: URL(string: "https://apod.nasa.gov/apod/image/2401/Horsehead_Rigel_960.jpg")!
        ),
        SpacePhoto(
            title: "The Orion Nebula in Infrared",
            description: "Few cosmic vistas excite the imagination like The Great Nebula in Orion. Also known as M42, the nebula's glowing gas surrounds hot young stars.",
            date: makeDate("2026-04-02"),
            url: URL(string: "https://apod.nasa.gov/apod/image/2401/OrionNebula_HubbleSerrano_960.jpg")!
        ),
        SpacePhoto(
            title: "Pillars of Creation",
            description: "These dark, towering, tentacle-shaped clouds are columns of cool interstellar hydrogen gas and dust that are incubators for new stars.",
            date: makeDate("2026-04-01"),
            url: URL(string: "https://apod.nasa.gov/apod/image/2312/EagleNebula_Paladini_960.jpg")!
        ),
        SpacePhoto(
            title: "The Crab Nebula from Hubble",
            description: "This is the mess that is left when a star explodes. The Crab Nebula is the result of a supernova seen in 1054 AD.",
            date: makeDate("2026-03-31"),
            url: URL(string: "https://apod.nasa.gov/apod/image/2312/CrabNebula_Hubble_960.jpg")!
        ),
        SpacePhoto(
            title: "Saturn from Above",
            description: "This image from NASA's Cassini spacecraft shows Saturn's northern hemisphere in natural color, as seen from above the ring plane.",
            date: makeDate("2026-03-30"),
            url: URL(string: "https://apod.nasa.gov/apod/image/2312/SaturnAbove_Cassini_960.jpg")!
        ),
    ]

    private static func makeDate(_ string: String) -> Date {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.date(from: string) ?? Date()
    }
}
