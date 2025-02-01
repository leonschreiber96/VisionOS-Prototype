import SwiftUI

/// Contains the UI for a single item in the MultiView video selection prompt
struct VideoItemSelectionView: View {
    let videoModel: VideoViewModel
    let inMultiviewContentSelection: Bool

    // Give all video preview images the same dimensions with a 16:9 aspect ratio (should be suitable for most content)
    private let height: CGFloat = 130.0
    private var aspectRatio: CGFloat { 16.0 / 9 }
    private var width: CGFloat { aspectRatio * height }

    /// Returns the appropriate icon to display on a video thumbnail, depending on whether it's already playing or can still be added.
    var overlaySystemIconName: String? {
        guard inMultiviewContentSelection else { return nil }
        return videoModel.isAddedToMultiview ? "checkmark.circle.fill" : "plus.circle"
    }

    var body: some View {
        VStack(alignment: .leading) {
            ThumbnailView(url: videoModel.video.url)
                .aspectRatio(aspectRatio, contentMode: .fit)
                .clipShape(.rect(cornerRadius: 15.0))
                .frame(width: width, height: height)
                .overlay(alignment: .bottomLeading) {
                    if let overlaySystemIconName {
                        Image(systemName: overlaySystemIconName)
                            .foregroundColor(.white)
                            .font(.system(size: 28.0))
                            .padding(8.0)
                    }
                }

            Text(videoModel.video.title)
                .foregroundStyle(.primary)
                .padding(.top, 5.0)
                .padding(.bottom, 5.0)
        }
        .frame(width: width)
        .lineLimit(1)
    }
}

#Preview {
    let item = defaultVideos.first!
    VideoItemSelectionView(videoModel: VideoViewModel(video: item), inMultiviewContentSelection: true)
    .border(.red.opacity(0.25))
    .padding(50)
    .glassBackgroundEffect()
}
