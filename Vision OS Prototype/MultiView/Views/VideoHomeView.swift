/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The main view of the app.
*/

import AVKit
import SwiftUI

struct VideoHomeView: View {
    @Environment(CustomSceneDelegate.self) var sceneDelegate
    @State var multiviewStateModel: MultiviewStateViewModel = .init(videos: defaultVideos)

    var body: some View {
        VStack(spacing: 25) {
            Text("Select Your Preferred Live Stream")
                .font(.extraLargeTitle)
                .padding(.top, 20)

            embeddedExperience
                .frame(minHeight: 400)

            MultiviewVideoSelectionView(
                multiviewStateModel: multiviewStateModel,
                fromMultiviewContentSelection: false
            )
            .frame(width: 925)
        }
        .frame(minHeight: multiviewStateModel.supportsEmbeddedPlaybackExperience ? 1000 : 400)
        .padding(.vertical, 50)
        .task {
            // This task is executed when the View is created:
            // Assign our MultiviewVideoSelectionView as the content selection view for the MultiView experience
            AVMultiviewManager.setContentSelectionView(
                MultiviewVideoSelectionView(
                    multiviewStateModel: multiviewStateModel,
                    fromMultiviewContentSelection: true
                )
                .padding(.top, 65.0)
            )
        }
        .onChange(of: sceneDelegate.scene, initial: true) {
            multiviewStateModel.scene = sceneDelegate.scene
        }
    }

    @ViewBuilder
    var embeddedExperience: some View {
        if multiviewStateModel.supportsEmbeddedPlaybackExperience {
            if let embeddedVideo = multiviewStateModel.embeddedVideo {
                // When displaying an embedded video, identify it based on the item
                // so that `UIViewControllerRepresentable` can provide the new
                // view controller in `makeUIViewController`.
                ItemVideoPlayer(videoModel: embeddedVideo)
                    .id(embeddedVideo.video.id)
            }
            else {
                HStack {
                    ContentUnavailableView(
                        "No Video Selected",
                        systemImage: "film",
                        description: Text("Select a video below to start watching.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(.black)
            }
        }
    }
}
