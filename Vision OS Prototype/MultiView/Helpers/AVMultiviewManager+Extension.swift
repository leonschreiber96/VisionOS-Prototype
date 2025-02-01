import AVKit
import SwiftUI

// Extension for the AVMultiViewManager system SDK class that lets us set the content selection view for a MultiView experience.
// The content selection view is required to present a user interface to select additional video content to display (or deselect already playing)
// See: https://developer.apple.com/documentation/avkit/avmultiviewmanager
extension AVMultiviewManager {
    /// Set the content selection view that belongs to this `AVMUltivViewManager` and will be presented to the user when they want to (de)select content for the MultiView experience.
    static func setContentSelectionView<Content: View>(_ rootView: Content) {
        let hostingController = UIHostingController(rootView: rootView)
        let contentSelectionViewController = AVContentSelectionViewController()
        contentSelectionViewController.preferredContentSize = .init(width: 1200, height: 340.0)

        // Add the `hostingController` and its view to the empty `contentSelectionViewController`.
        contentSelectionViewController.addChild(hostingController)
        contentSelectionViewController.view.addSubview(hostingController.view)

        // Notify the `hostingController` that the move is complete.
        hostingController.didMove(toParent: contentSelectionViewController)

        // Set the constraints so that the `hostingController` matches the size of the `contentSelectionViewController`.
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentSelectionViewController.view.leadingAnchor.constraint(equalTo: hostingController.view.leadingAnchor),
            contentSelectionViewController.view.trailingAnchor.constraint(equalTo: hostingController.view.trailingAnchor),
            contentSelectionViewController.view.topAnchor.constraint(equalTo: hostingController.view.topAnchor),
            contentSelectionViewController.view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor)
        ])

        AVMultiviewManager.default.contentSelectionViewController = contentSelectionViewController
    }
}
