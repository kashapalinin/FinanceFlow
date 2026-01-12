//
//  MainModuleAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 20.12.2025.
//
import Swinject
import UIKit

final class MainModuleAssembly: Assembly {
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
        
        container.register(TransactionCategoryAssembly.self) { _ in
            TransactionCategoryAssembly()
        }
        
        container.register(TransactionAssembly.self) { _ in
            TransactionAssembly()
        }
        
        container.register(TransactionManageModuleCoordinatorProtocol.self) { (resolver: Resolver, nc: UINavigationController) in
            TransactionManageModuleCoordinator(
                navigationController: nc,
                resolver: resolver
            )
        }
        .inObjectScope(.transient)
    }
}

