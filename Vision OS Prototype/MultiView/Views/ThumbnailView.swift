import AVKit
import SwiftUI

/// `ThumbnailView` is a SwiftUI view that asynchronously generates and displays a thumbnail for a video.
///
/// This view attempts to extract a frame from the middle of the video as a representative thumbnail. If the
/// thumbnail generation is successful, it displays the extracted image. Otherwise, it falls back to a placeholder
/// with a film icon on a black background. A loading indicator is shown while the thumbnail is being generated.
///
/// ## Features:
/// - Uses `AVAssetImageGenerator` to extract a frame from the middle of the video.
/// - Displays a placeholder image if the generation fails.
/// - Runs the thumbnail generation asynchronously to avoid blocking the UI.
/// - Prevents redundant thumbnail generation if an image is already available.
///
/// ## Usage:
/// ```swift
/// ThumbnailView(url: videoURL)
/// ```
/// where `videoURL` is the URL of the video for which the thumbnail is to be generated.
///
/// ## Dependencies:
/// - `AVKit` for video asset handling.
/// - `SwiftUI` for UI rendering.
struct ThumbnailView: View {
    let url: URL
    @State var imageResult: Result<CGImage, Error>?

    @ViewBuilder
    var filmThumbnail: some View {
        // During image generation, or if it fails,
        // display the film SF Symbols on a black background.
        Color.black

        Image(systemName: "film")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.secondary)
            .font(.largeTitle)
            .padding(20.0)
    }

    var body: some View {
        ZStack {
            switch imageResult {
            case .success(let image):
                Image(uiImage: UIImage(cgImage: image))
                    // Allow the image to resize to fit the container.
                    .resizable()
                    // Fit the image so it reflects the orientation
                    // and size of the video.
                    .aspectRatio(contentMode: .fit)
            case .failure:
                filmThumbnail
            case .none:
                filmThumbnail
                ProgressView()
            }
        }
        .task {
            // Prevent generating an image if you already have one.
            guard imageResult == nil else { return }

            await generateThumbnail()
        }
    }
}

extension ThumbnailView {
    func generateThumbnail() async {
        let asset: AVAsset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.maximumSize = CGSize(width: 300, height: 300 * (16 / 9))

        guard let duration = try? await asset.load(.duration) else { return }
        let seconds = duration.seconds / 2
        let halfway: CMTime = .init(seconds: seconds, preferredTimescale: 1)
        do {
            imageResult = .success(try await generator.image(at: halfway).image)
        } catch {
            imageResult = .failure(error)
        }
    }
}

#Preview {
    ThumbnailView(
        url: Bundle.main.url(forResource: "commentwithaudio", withExtension: "mov")!,
        imageResult: nil
    )
}
