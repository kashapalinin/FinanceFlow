//
//  MoneyManagementCoordinator.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 20.12.2025.
//
import UIKit
import Swinject

protocol MainModuleCoordinatorProtocol: Coordinator {

}

final class MainModuleCoordinator: MainModuleCoordinatorProtocol {
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    private let resolver: Resolver

    init(navigationController: UINavigationController, resolver: Resolver) {
        self.navigationController = navigationController
        self.resolver = resolver
    }

    func start() {
        showMoneyManagementScreen()
    }
    
    func showMoneyManagementScreen() {
        let assembly = resolver.resolve(MainAssembly.self)!
        let vc = assembly.assemble()
        navigationController.setViewControllers([vc], animated: true)
    }
}


