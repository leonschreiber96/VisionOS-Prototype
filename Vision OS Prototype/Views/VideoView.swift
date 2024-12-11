import SwiftUI
import AVKit

struct VideoView: View {
    @State private var player: AVPlayer = AVPlayer(url: Bundle.main.url(forResource: "justcam", withExtension: "mp4")!)
    @State private var isPlaying: Bool = true

    var body: some View {
        ZStack {
            // Video Player
            VideoPlayer(player: player)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            player.play() // Startet die Wiedergabe beim Öffnen der Ansicht
        }
    }
    // Aktionen für die Buttons
    private func togglePlayPause() {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    private func rewind() {
        let currentTime = player.currentTime()
        let newTime = CMTimeSubtract(currentTime, CMTimeMake(value: 10, timescale: 1))
        player.seek(to: newTime)
    }
    private func forward() {
        let currentTime = player.currentTime()
        let newTime = CMTimeAdd(currentTime, CMTimeMake(value: 10, timescale: 1))
        player.seek(to: newTime)
    }
}
#Preview(windowStyle: .automatic) {
    VideoView()
}
