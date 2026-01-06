//
//  MoneyManagementCoordinator.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 20.12.2025.
//
import UIKit
import Swinject

protocol MainModuleCoordinatorProtocol: Coordinator {
    func showMoneyManagementScreen()
    func showTransactionManageScreen()
    func showTransactionCategoryScreen(categoryId: UUID, interval: DateInterval)
    func showTransactionScreen(transactionId: UUID)
    func closeCurrentScreen()
}

final class MainModuleCoordinator: MainModuleCoordinatorProtocol {
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    private var childCoordinators: [Coordinator] = []
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
        let vc = assembly.assemble(coordinator: self, resolver: resolver)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showTransactionManageScreen() {
        let coordinator = resolver.resolve(TransactionManageModuleCoordinatorProtocol.self, argument: navigationController)!
        childCoordinators.append(coordinator)
        coordinator.flowCompletionHandler = { [weak self] in
            self?.navigationController.popViewController(animated: true)
            self?.childCoordinators = []
        }
        coordinator.start()
    }
    
    func showTransactionCategoryScreen(categoryId: UUID, interval: DateInterval) {
        let assembly = resolver.resolve(TransactionCategoryAssembly.self)!
        let vc = assembly.assemble(
            categoryId: categoryId,
            interval: interval,
            coordinator: self,
            resolver: resolver
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showTransactionScreen(transactionId: UUID) {
        let assembly = resolver.resolve(TransactionAssembly.self)!
        let vc = assembly.assemble(
            transactionId: transactionId,
            coordinator: self,
            resolver: resolver
        )
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func closeCurrentScreen() {
        navigationController.popViewController(animated: true)
    }
}


