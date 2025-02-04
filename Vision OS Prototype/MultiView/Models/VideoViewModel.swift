/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The class responsible for containing all the properties needed to display the video.
*/

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
    private var automaticPlayPauseOngoing: Bool = false
    private var playPauseSignallingAllowed: Bool = false
    
//    private func printi(text: String) {
//        print("[VIDEO]", self.identifier.uuidString.prefix(5), text)
//    }
    
    @MainActor
    init(video: Video) {
        let playerController = AVPlayerViewController()
        
        // Enable the multiview experience, along with the default recommended set.
        playerController.experienceController.allowedExperiences = .recommended(including: [.multiview])

        self.video = video
        self.viewController = playerController
        self.player = .init(playerItem: video.playerItem)
        self.viewController.player = player
        
//        self.printi(text: "Init")
        
        self.playPauseHandler = self.player.publisher(for: \.timeControlStatus).sink { [weak self] status in
            guard self != nil else { return }
            
            if self!.automaticPlayPauseOngoing { return }
            else if !self!.playPauseSignallingAllowed {
                self!.playPauseSignallingAllowed = true
                return
            }
            
//            self?.printi(text: "User set playback state for \(self?.video.title ?? "unknown video") to \(["paused", "waitingToPlay", "playing"][status.rawValue])")
            if status == .paused { StreamScrubbingNotificationCenter.shared.notifyPlayPause(sender: self!.identifier, newState: .pause) }
            else if status == .playing { StreamScrubbingNotificationCenter.shared.notifyPlayPause(sender: self!.identifier, newState: .play) }
        }
        
        StreamScrubbingNotificationCenter.shared.registerPlayPauseHandler(for: self.identifier, observer: self.playPauseVideo)
    }
    
    deinit {
        StreamScrubbingNotificationCenter.shared.deRegisterPlayPauseHandler(for: self.identifier)
        StreamScrubbingNotificationCenter.shared.deRegisterScrubHandler(for: self.identifier)
    }
    
    @MainActor
    func pauseVideoAndResetPlaybackCursor() async {
//        printi(text: "Resetting playback cursor and pausing video \(self.video.title)")
        self.automaticPlayPauseOngoing = true
        self.playPauseSignallingAllowed = false
        player.pause()
        await player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
        self.automaticPlayPauseOngoing = false
//        printi(text: "FINISHED playback cursor and pausing video \(self.video.title)")
    }

    @MainActor
    func resetPlaybackCursorAndPlayVideo() async {
//        printi(text: "Resetting playback cursor and playing video \(self.video.title)")
        self.automaticPlayPauseOngoing = true
        self.playPauseSignallingAllowed = false
        await player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
        player.play()
        self.automaticPlayPauseOngoing = false
//        printi(text: "FINISHED playback cursor and playing video \(self.video.title)")
    }
    
    @MainActor func scrub(to targetTimestamp: TimeInterval) async {
        self.automaticPlayPauseOngoing = true
        self.playPauseSignallingAllowed = false
        await player.seek(to: CMTime(seconds: targetTimestamp, preferredTimescale: 1000000), toleranceBefore: .zero, toleranceAfter: .zero)
        self.automaticPlayPauseOngoing = false
    }
    
    @MainActor func playPauseVideo(newState: PlayingState) {
//        printi(text: "Automatically set playback state for \(self.video.title) to \(newState)")
        self.automaticPlayPauseOngoing = true
        self.playPauseSignallingAllowed = false
        
        if newState == .pause { self.player.pause() }
        else if newState == .play { self.player.play() }
        
        self.automaticPlayPauseOngoing = false
//        printi(text: "FINISHED SETTING \(self.video.title) to \(newState) \(self.player.rate)")
    }
}
