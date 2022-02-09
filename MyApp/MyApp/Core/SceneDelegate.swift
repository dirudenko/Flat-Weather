//
//  SceneDelegate.swift
//  MyApp
//
//  Created by Dmitry on 15.12.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = BuilderService.buildRootViewController()
    self.window = window
    window.makeKeyAndVisible()
  }
}
