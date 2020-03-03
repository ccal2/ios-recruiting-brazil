//
//  AppDelegate.swift
//  Movs
//
//  Created by Carolina Cruz Agra Lopes on 01/12/19.
//  Copyright © 2019 Carolina Lopes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Variables

    var coordinator: AppCoordinator?

    // MARK: - App life cycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.coordinator = AppCoordinator()
        self.coordinator?.start()

        return true
    }
}
