/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The main view of the app.
*/

import AVKit
import SwiftUI

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
        .onDisappear {
            model.showingLiveStream = false
        }
        .onAppear {
            model.showingLiveStream = true
        }
    }
}
