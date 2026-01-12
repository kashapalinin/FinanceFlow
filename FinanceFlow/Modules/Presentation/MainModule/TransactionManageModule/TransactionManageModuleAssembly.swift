//
//  TransactionManageModuleAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//
import Swinject
import UIKit

final class TransactionManageModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MainModuleCoordinatorProtocol.self) { (resolver: Resolver, nc: UINavigationController) in
            MainModuleCoordinator(
                navigationController: nc,
                resolver: resolver
            )
        }.inObjectScope(.transient)
        
        container.register(MainAssembly.self) { _ in
            MainAssembly()
        }
        
        container.register(TransactionManageScreenAssembly.self) { _ in
            TransactionManageScreenAssembly()
        }
    }
}
