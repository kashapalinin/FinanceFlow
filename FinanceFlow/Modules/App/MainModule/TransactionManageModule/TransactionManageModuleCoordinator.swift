//
//  TransactionManageModuleCoordinator.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//

import UIKit
import Swinject

protocol TransactionManageModuleCoordinatorProtocol: Coordinator {
    func showTransactionManageScreen()
}

final class TransactionManageModuleCoordinator: TransactionManageModuleCoordinatorProtocol {
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    private let resolver: Resolver

    init(navigationController: UINavigationController, resolver: Resolver) {
        self.navigationController = navigationController
        self.resolver = resolver
    }

    func start() {
        showTransactionManageScreen()
    }
    
    func showTransactionManageScreen() {
        let assembly = resolver.resolve(TransactionManageScreenAssembly.self)!
        let vc = assembly.assemble()
        navigationController.pushViewController(vc, animated: true)
    }
}


