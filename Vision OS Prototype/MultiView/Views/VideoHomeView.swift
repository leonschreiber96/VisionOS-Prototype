/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The main view of the app.
*/

import AVKit
import SwiftUI

struct VideoHomeView: View {
    @Environment(CustomSceneDelegate.self) var sceneDelegate
    @Environment(AppModel.self) private var model
    @ObservedObject var multiviewStateModel: MultiviewStateViewModel
    
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
    }
}
