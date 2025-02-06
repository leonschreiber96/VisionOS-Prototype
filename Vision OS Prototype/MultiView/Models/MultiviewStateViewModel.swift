import AVKit
import SwiftUI

/**
 :AVExperienceController.Delegate → A protocol that defines the methods to implement to respond to experience changes (i.e., when we switch to or from MultiView experience).
*/
final class MultiviewStateViewModel: ObservableObject, AVExperienceController.Delegate {
    /// The videos to display in the multiview experience.
    var videoViewModels: [VideoViewModel]

    /// The count of videos in the multiview experience. Use this to determine whether to pause the video or to set it
    /// as the embedded video when leaving the multiview experience.
    var videosInMultiview: Int { videoViewModels.count { $0.isAddedToMultiview } }
    
    var streamObject: ChessEventStream
    
    /// The scene to use as the fallback placement for instances where you don't use the embedded experience.
    var scene: UIScene?

    init(videos: [Video], stream: ChessEventStream) {
        let videoModels = videos.map { VideoViewModel(video: $0, streamObject: stream) }
        self.videoViewModels = videoModels
        self.streamObject = stream

        self.videoViewModels.forEach { videoModel in
            videoModel.viewController.experienceController.delegate = self
        }
    }
    
    deinit {
        self.videoViewModels = []
    }

    @MainActor
    func selectVideoForPlayback(videoViewModel: VideoViewModel, inMultiview: Bool) async {
        if inMultiview {
            // Deselecting the last video removes the user from the multiview experience, and returns them to the embedded playback experience.
            await videoViewModel.viewController.experienceController.transition(
                to: videoViewModel.isAddedToMultiview ? .embedded : .multiview
            )
        } else {
            if case .completed = await videoViewModel.viewController.experienceController.transition(to: .expanded) {
                await videoViewModel.resetPlaybackCursorAndPlayVideo()
            }
        }
        
//        await videoViewModel.scrub(to: streamObject.currentTimestamp)
    }
    
    @MainActor
    func findVideoViewModel(for experienceController: AVExperienceController) -> VideoViewModel? {
        videoViewModels.first { item in
            item.viewController.experienceController === experienceController
        }
    }
    
    @MainActor
    func setFallbackScene(for controller: AVExperienceController, using context: AVExperienceController.TransitionContext) {
        // The fallback placement is required for cases where the video doesn't start from the embedded state,
        // or the video needs to present on top of another scene.
        // If the video starts in the embedded state, you don't need to set the fallback placement.
        if (context.toExperience == .expanded) {
            if let scene {
                controller.configuration.expanded.fallbackPlacement = .over(scene: scene)
            } else {
                controller.configuration.expanded.fallbackPlacement = .unspecified
            }
        }
    }
    
    // MARK: - AVExperienceController.Delegate contract functions (see https://developer.apple.com/documentation/avkit/avexperiencecontroller/delegate-swift.protocol)

    @MainActor
    /// Tells the delegate when the transition context changes during a transition.
    func experienceController(_ controller: AVExperienceController, didChangeTransitionContext context: AVExperienceController.TransitionContext) {
        guard let videoViewModel = findVideoViewModel(for: controller) else {
            assertionFailure("Failed to get item for experience controller")
            return
        }

        if case .transitioning = context.status, videosInMultiview == 0 {
            // If there aren't any videos in the multiview experience,
            // update the selection state so that while the transition
            // is occurring, the UI reflects the added video.
            videoViewModel.isAddedToMultiview = context.toExperience != .embedded
        }

        guard
            case .finished(let result) = context.status,
            .completed == result
        else { return }

        videoViewModel.isAddedToMultiview = context.toExperience == .multiview

        // Play new videos that someone successfully adds to the multiview experience.
        if videoViewModel.isAddedToMultiview, videosInMultiview > 1 {
            Task { await videoViewModel.resetPlaybackCursorAndPlayVideo() }
        }

        // If the initial playback experience isn't embedded, remove the embedded video
        // from the view hierarchy when transitioning back to the embedded experience.
        if (context.toExperience == .embedded) {
            Task { await videoViewModel.pauseVideoAndResetPlaybackCursor() }
        }
    }
    
    @MainActor
    /// Tells the delegate that the system is preparing for a transition.
    func experienceController(_ controller: AVExperienceController, prepareForTransitionUsing context: AVExperienceController.TransitionContext) async {
        guard let videoModel = findVideoViewModel(for: controller) else {
            assertionFailure("Failed to get item for experience controller")
            return
        }

        if let player = videoModel.viewController.player, player.currentTime() == player.currentItem?.duration {
            await player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
            player.play()
        }

        setFallbackScene(for: controller, using: context)
    }

    @MainActor
    /// Tells the delegate when the available experiences change (we don't use this, so no function body)
    func experienceController(_ controller: AVExperienceController, didChangeAvailableExperiences availableExperiences: AVExperienceController.Experiences) { }
}
