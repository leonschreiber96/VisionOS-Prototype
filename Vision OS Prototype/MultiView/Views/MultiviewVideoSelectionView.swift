
import AVKit
import SwiftUI

/// UI for displaying a list of available video streams and selecting the ones to be displayed in the MultiView experience.
struct MultiviewVideoSelectionView: View {
    public let multiviewStateModel: MultiviewStateViewModel
    public let fromMultiviewContentSelection: Bool

    var body: some View {
        ScrollView([.horizontal]) {
            HStack(spacing: 28.0) {
                ForEach(multiviewStateModel.videoViewModels, id: \.video) { videoViewModel in
                    Button {
                        Task {
                            await multiviewStateModel.selectVideoForPlayback(
                                videoViewModel: videoViewModel,
                                inMultiview: fromMultiviewContentSelection
                            )
                        }
                    } label: {
                        VideoItemSelectionView(
                            videoModel: videoViewModel,
                            inMultiviewContentSelection: fromMultiviewContentSelection
                        )
                        .padding(.vertical, 5)
                    }
                    .buttonBorderShape(.roundedRectangle(radius: 25.0))
                }
            }
            .padding(20)
        }
        .scrollIndicators(.hidden)
        .padding(.leading, 5.0)
        .frame(minHeight: 320.0)
    }
}
