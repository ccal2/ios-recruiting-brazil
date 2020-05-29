//
//  AppCoordinator.swift
//  Movs
//
//  Created by c.cruz.agra.lopes on 03/03/20.
//  Copyright © 2020 Carolina Lopes. All rights reserved.
//

import UIKit

class AppCoordinator: NSObject {

    // MARK: - Variables

    // MARK: TabCoordinator protocol

    let tabBarController: UITabBarController
    var childCoordinators: [Coordinator]

    // MARK: - Methods

    // MARK: Initializers

    override init() {
        self.tabBarController = UITabBarController()
        self.childCoordinators = []

        super.init()
    }
}

// MARK: - TabCoordinator

extension AppCoordinator: TabCoordinator {

    func start() {

        // Popular Movies' tab

        let popularNavController = UINavigationController()
        popularNavController.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "list.bullet"), tag: 0)
        popularNavController.navigationBar.tintColor = .systemIndigo
        popularNavController.navigationBar.prefersLargeTitles = true
        popularNavController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.systemIndigo]
        popularNavController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemIndigo]

        let popularCoordinator = PopularMoviesCoordinator(navigationController: popularNavController)
        popularCoordinator.delegate = self

        popularCoordinator.start()

        // Favorite Movies' tab

        let favoriteNavController = UINavigationController()
        favoriteNavController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 0)
        favoriteNavController.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        favoriteNavController.navigationBar.tintColor = .systemIndigo
        favoriteNavController.navigationBar.prefersLargeTitles = true
        favoriteNavController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.systemIndigo]
        favoriteNavController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemIndigo]

        let favoriteCoordinator = FavoriteMoviesCoordinator(navigationController: favoriteNavController)
        favoriteCoordinator.delegate = self

        favoriteCoordinator.start()

        // Tabs setup

        self.tabBarController.viewControllers = [popularNavController, favoriteNavController]
        self.tabBarController.tabBar.tintColor = .systemIndigo

        self.childCoordinators = [popularCoordinator, favoriteCoordinator]
    }
}
