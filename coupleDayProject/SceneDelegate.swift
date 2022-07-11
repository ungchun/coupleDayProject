//
//  SceneDelegate.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/08.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    let isDark = UserDefaults.standard.bool(forKey: "darkModeState")
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // MARK: 시작(root) 뷰컨 설정
        guard let windowScene = (scene as? UIWindowScene) else { return }
//        let rootViewcontroller = realm.isEmpty ? UINavigationController(rootViewController: BeginViewController()) : UINavigationController(rootViewController: ContainerViewController())
        let rootViewcontroller = LoadingViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewcontroller
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        guard let _ = (scene as? UIWindowScene) else { return }
        if let window = UIApplication.shared.windows.first {
            print("window.overrideUserInterfaceStyle \(window.overrideUserInterfaceStyle)")
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = isDark == true ? .dark : .light
            } else {
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

