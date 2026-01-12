//
//  LoadingAppCoordinator.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.11.2025.
//
import UIKit
import Swinject

protocol LoadingAppCoordinatorProtocol: Coordinator {
    
}

final class LoadingAppCoordinator: LoadingAppCoordinatorProtocol {
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    private let resolver: Resolver

    init(navigationController: UINavigationController,
         resolver: Resolver) {
        self.navigationController = navigationController
        self.resolver = resolver
    }

    func start() {
        let assembly = resolver.resolve(LoadingAppAssembly.self)!
        let vc = assembly.assemble(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
}
