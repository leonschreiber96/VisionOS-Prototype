import UIKit

/// Scene delegate for managing the app's UI scene lifecycle.
@Observable
class CustomSceneDelegate: NSObject, UIWindowSceneDelegate {
    /// Holds a reference to the current scene.
    var scene: UIScene? = nil

    func sceneWillEnterForeground(_ scene: UIScene) {
        self.scene = scene
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        self.scene = scene
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        self.scene = nil
    }
}

/// Application delegate for configuring scene connections.
class CustomApplicationDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(
            name: nil,
            sessionRole: connectingSceneSession.role)

        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = CustomSceneDelegate.self
        }

        return configuration
    }
}
