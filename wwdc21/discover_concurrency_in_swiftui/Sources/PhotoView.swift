// WWDC21: Discover concurrency in SwiftUI
// AsyncImageとSavePhotoButton

import SwiftUI

// --- 写真1枚を表示するビュー ---
struct PhotoView: View {
    var photo: SpacePhoto

    var body: some View {
        VStack {
            // AsyncImage: URLを渡すだけでネット上の画像を非同期で読み込む
            // - 読み込み中はplaceholderが表示される
            // - エラー時はplaceholderのまま（クラッシュしない）
            AsyncImage(url: photo.url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView() // 読み込み中のクルクル
            }
            .frame(minWidth: 0, minHeight: 400)

            HStack {
                VStack(alignment: .leading) {
                    Text(photo.title)
                        .font(.headline)
                    Text(photo.description)
                        .font(.caption)
                        .lineLimit(3)
                }

                Spacer()

                SavePhotoButton(photo: photo)
            }
            .padding()
        }
    }
}

// --- 保存ボタン ---
// ボタンのactionはasyncではないので、Task { } で囲んで非同期処理を実行する
struct SavePhotoButton: View {
    var photo: SpacePhoto
    @State private var isSaving = false

    var body: some View {
        Button {
            // Task { } でボタンのアクション内から非同期処理を呼び出す
            // .taskと違い、ボタンの場合は手動でTask を作る必要がある
            Task {
                isSaving = true
                await photo.save()
                isSaving = false
            }
        } label: {
            Text("Save")
                .opacity(isSaving ? 0 : 1)
                .overlay {
                    if isSaving {
                        ProgressView() // 保存中はクルクル表示
                    }
                }
        }
        .disabled(isSaving) // 保存中はボタンを無効化（二重タップ防止）
        .buttonStyle(.bordered)
    }
}
