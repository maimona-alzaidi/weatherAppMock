//
//  SceneDelegate.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 19/09/1447 AH.
//
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

        func scene(_ scene: UIScene,
                   willConnectTo session: UISceneSession,
                   options connectionOptions: UIScene.ConnectionOptions) {

            guard let windowScene = (scene as? UIWindowScene) else { return }

            let window = UIWindow(windowScene: windowScene)
            let viewModel = WeatherViewModel()
            let weatherViewController = WeatherViewController(viewModel: viewModel)
            let navigationController = UINavigationController(rootViewController: weatherViewController)
         
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.prefersLargeTitles = false
            navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

            if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = .clear
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
            }

            window.rootViewController = navigationController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
