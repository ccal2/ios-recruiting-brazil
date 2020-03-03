//
//  PopularMoviesCoordinator.swift
//  Movs
//
//  Created by c.cruz.agra.lopes on 03/03/20.
//  Copyright © 2020 Carolina Lopes. All rights reserved.
//

import UIKit

class PopularMoviesCoordinator: NSObject {

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

extension PopularMoviesCoordinator: NavigationCoordinator {

    func start() {
        let popularMoviesVC = PopularMoviesViewController()
        // TODO: popularMoviesVC.delegate = self

        self.navigationController.pushViewController(popularMoviesVC, animated: true)
    }
}

// MARK: - FlowRootDelegate

extension PopularMoviesCoordinator: FlowRootDelegate {

    func didMoveToParent() {
        self.delegate?.removeChild(self)
    }
}
