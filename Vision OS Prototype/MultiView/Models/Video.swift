import AVFoundation
import AVKit
import Foundation
import UIKit

/**
 Represents a playable video with a url, title and associated `AVPlayerItem`.
 
 To keep the scope of this project manageable, we used locally saved example videos instead of web-based livestreams. A url to a web resource could theoretically be used
 instead with the same result.
 */
struct Video: Identifiable, Hashable {
    /// The unique id of the video. Corresponds to its url for simplicity reasons, since these should normally be unique.
    /// This is needed for use in SwiftUI functions such as `ForEach` to uniquely identify the videos.
    var id: String { url.absoluteString }
    /// Resource url of the video. Can point to local file or web based resource.
    let url: URL
    /// A title for the video that can be displayed in the UI to describe it to the user
    let title: String
    /// Media player object associated with the video. Used for controlling playback (play/pause, scrub)
    var playerItem: AVPlayerItem { return AVPlayerItem(url: url) }
}

/// The prerecorded videos we use for this tech demo.
let defaultVideos: [Video] = [
    .init(
        url: Bundle.main.url(forResource: "commentwithaudio", withExtension: "mov")!,
        title: "Commentators"
    ),
    .init(
        url: Bundle.main.url(forResource: "justcam", withExtension: "mov")!,
        title: "Player View"
    ),
    .init(
        url: Bundle.main.url(forResource: "justboard", withExtension: "mov")!,
        title: "Game View"
    )
]
