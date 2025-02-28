import AVKit
import SwiftUI

/// `VideoHomeView` serves as the main screen for selecting and managing live video streams.
///
/// This view provides a user interface for selecting a preferred live stream from a predefined set of videos.
/// It integrates with the `MultiviewVideoSelectionView` to allow users to choose multiple streams.
/// Additionally, it manages the visibility of the live stream state in the `AppModel`.
///
/// ## Features:
/// - Displays a title and a selection interface for live streams.
/// - Handles the lifecycle of the view to update `showingLiveStream` in `AppModel`.
/// - Registers itself as the content selection view for `AVMultiviewManager`.
///
/// ## Usage:
/// Add `VideoHomeView()` to the SwiftUI hierarchy where the live stream selection should be presented.
struct VideoHomeView: View {
    @Environment(CustomSceneDelegate.self) var sceneDelegate
    @StateObject var multiviewStateModel: MultiviewStateViewModel = .init(videos: defaultVideos)
    @Environment(AppModel.self) private var model

    var body: some View {
        VStack(spacing: 25) {
            Text("Select Your Preferred Live Stream")
                .font(.extraLargeTitle)
                .padding(.top, 20)

            MultiviewVideoSelectionView(
                multiviewStateModel: multiviewStateModel,
                fromMultiviewContentSelection: false
            )
            .frame(width: 925)
            .onDisappear {
                model.showingLiveStream = false
            }
            .onAppear {
                model.showingLiveStream = true
            }
        }
        .padding(.vertical, 50)
        .task {
            // Register `MultiviewVideoSelectionView` as the content selection view for the MultiView experience.
            AVMultiviewManager.setContentSelectionView(
                MultiviewVideoSelectionView(
                    multiviewStateModel: multiviewStateModel,
                    fromMultiviewContentSelection: true
                )
                .padding(.top, 65.0)
            )
        }
        .onChange(of: sceneDelegate.scene, initial: true) {
            // Update the scene in `MultiviewStateViewModel` when the scene changes.
            multiviewStateModel.scene = sceneDelegate.scene
        }
        .onDisappear {
            model.showingLiveStream = false
        }
        .onAppear {
            model.showingLiveStream = true
        }
    }
}
