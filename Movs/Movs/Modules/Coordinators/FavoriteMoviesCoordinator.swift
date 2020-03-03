//
//  FavoriteMoviesCoordinator.swift
//  Movs
//
//  Created by c.cruz.agra.lopes on 03/03/20.
//  Copyright © 2020 Carolina Lopes. All rights reserved.
//

import UIKit

class FavoriteMoviesCoordinator: NSObject {

    // MARK: - Variables

    // MARK: Coordinator protocol

    let navigationController: UINavigationController
    var childCoordinators: [Coordinator]

    // MARK: Delegate

    weak var delegate: Coordinator?

    // MARK: - Methods

    // MARK: Initializers

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []

        super.init()
    }
}

// MARK: - NavigationCoordinator

extension FavoriteMoviesCoordinator: NavigationCoordinator {

    func start() {
        let favoriteMoviesVC = FavoriteMoviesViewController()
        // TODO: favoriteMoviesVC.delegate = self

        self.navigationController.pushViewController(favoriteMoviesVC, animated: true)
    }
}

// MARK: - FlowRootDelegate

extension FavoriteMoviesCoordinator: FlowRootDelegate {

    func didMoveToParent() {
        self.delegate?.removeChild(self)
    }
}
