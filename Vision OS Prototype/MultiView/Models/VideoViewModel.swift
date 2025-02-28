import AVKit
import Combine

@Observable
class VideoViewModel {
    let video: Video
    let viewController: AVPlayerViewController
    var isAddedToMultiview: Bool = false
    
    let identifier: UUID = UUID()
    
    private let player: AVPlayer
    private var playPauseHandler: Cancellable?
    
    
    /**
     These 2 fields are to prevent the following problem:
     - When a user pauses one of the videos, its `playPauseHandler` reacts to this and sends a message to all the other video players to pause as well
     - When the other players pause, their `playPauseHandler`s fire as well, not knowing that the command did not come from the user, but was automatically executed
     - This is then picked up by all other players again, leading to an infinite loop of players notifying each other about being paused
     Therefore, these 2 lock variables make sure that play/pausing only fires the `playPauseHandler` when the user initiated it, not when the play/pause function was called from somewhere else in the code.
     */
    private var automaticPlayPauseOngoing: Bool = false
    private var playPauseSignallingAllowed: Bool = false
    
    @MainActor
    init(video: Video) {
        let playerController = AVPlayerViewController()
        
        // Enable the multiview experience, along with the default recommended set.
        playerController.experienceController.allowedExperiences = .recommended(including: [.multiview])
        
        self.video = video
        self.viewController = playerController
        self.player = .init(playerItem: video.playerItem)
        self.viewController.player = player
        
        self.playPauseHandler = self.player.publisher(for: \.timeControlStatus).sink { [weak self] status in
            guard self != nil else { return }
            
            /**
             Prevents infinite notification loops:
             - If `automaticPlayPauseOngoing` is `true`, this change was programmatically triggered, so we ignore it.
             - If `playPauseSignallingAllowed` is `false`, this is the first play/pause event after initialization, so we allow it but prevent further notifications.
            */
            if self!.automaticPlayPauseOngoing { return }
            else if !self!.playPauseSignallingAllowed {
                self!.playPauseSignallingAllowed = true
                return
            }
            
            if status == .paused { StreamScrubbingNotificationCenter.shared.notifyPlayPause(sender: self!.identifier, newState: .pause) }
            else if status == .playing { StreamScrubbingNotificationCenter.shared.notifyPlayPause(sender: self!.identifier, newState: .play) }
        }
        
        StreamScrubbingNotificationCenter.shared.registerPlayPauseHandler(for: self.identifier, observer: self.playPauseVideo)
        StreamScrubbingNotificationCenter.shared.registerScrubHandler(for: self.identifier, observer: {timeStamp in
            Task {
                await self.scrub(to: timeStamp)
            }
        })
        
        // Just use any random uuid that is not ours, so the scrub will be registered by this video and executed (this is a dirty hack)
        StreamScrubbingNotificationCenter.shared.notifyScrub(sender: UUID(), to: 20)
    }
    
    deinit {
        // Deregister handlers when the ViewModel is deallocated.
        StreamScrubbingNotificationCenter.shared.deRegisterPlayPauseHandler(for: self.identifier)
        StreamScrubbingNotificationCenter.shared.deRegisterScrubHandler(for: self.identifier)
    }
    
    /// Pauses the video and resets playback to the beginning.
    @MainActor
    func pauseVideoAndResetPlaybackCursor() async {
        self.automaticPlayPauseOngoing = true
        self.playPauseSignallingAllowed = false
        player.pause()
        await player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
        self.automaticPlayPauseOngoing = false
    }
    
    /// Resets playback to the beginning and starts playing the video.
    @MainActor
    func resetPlaybackCursorAndPlayVideo() async {
        self.automaticPlayPauseOngoing = true
        self.playPauseSignallingAllowed = false
        await player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
        player.play()
        self.automaticPlayPauseOngoing = false
    }
    
    /// Moves the playback cursor to a specific timestamp.
    @MainActor func scrub(to targetTimestamp: TimeInterval) async {
        self.automaticPlayPauseOngoing = true
        self.playPauseSignallingAllowed = false
        await player.seek(to: CMTime(seconds: targetTimestamp, preferredTimescale: 1000000), toleranceBefore: .zero, toleranceAfter: .zero)
        self.automaticPlayPauseOngoing = false
    }
    
    /// Handles external play/pause commands.
    @MainActor func playPauseVideo(newState: PlayingState) {
        self.automaticPlayPauseOngoing = true
        self.playPauseSignallingAllowed = false
        
        if newState == .pause {
            self.player.pause()
        } else if newState == .play {
            self.player.play()
        }
        
        self.automaticPlayPauseOngoing = false
    }
}
