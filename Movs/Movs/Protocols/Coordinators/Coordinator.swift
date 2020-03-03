//
//  Coordinator.swift
//  Movs
//
//  Created by c.cruz.agra.lopes on 03/03/20.
//  Copyright © 2020 Carolina Lopes. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {

    // MARK: - Variables

    var childCoordinators: [Coordinator] { get set }

    // MARK: - Methods

    func start()
    func removeChild(_ child: Coordinator)
}

extension Coordinator {

    func removeChild(_ child: Coordinator) {
        self.childCoordinators.removeAll(where: {$0 === child})
    }
}
