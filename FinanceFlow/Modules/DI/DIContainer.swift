//
//  DIContainer.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 07.12.2025.
//

import Swinject
import CurrencyFormatter

import UIKit

final class DIContainer {
    static let shared = Container()
    
    static func setup() {        
        shared.registerDependencies()
        shared.registerModule(OnboardingAssembly())
        shared.registerModule(MainModuleAssembly())
        shared.registerModule(StorageAssembly())
        shared.registerModule(ServicesAssembly())
        shared.registerModule(FirebaseServicesAssembly())
        shared.registerModule(AnalyticsAssembly())
        shared.registerModule(SurveyBDUIModuleAssembly())
    }
}

extension Container {
    func registerDependencies() {
        register(AppCoordinator.self) { (resolver: Resolver, nc: UINavigationController) in
            AppCoordinator(navigationController: nc, resolver: resolver)
        }.inObjectScope(.container)
        
        register(LoadingAppAssembly.self) { _ in
            LoadingAppAssembly()
        }
        
        register(LoadingAppCoordinatorProtocol.self) { (resolver: Resolver, nc: UINavigationController) in
            LoadingAppCoordinator(navigationController: nc, resolver: resolver)
        }
        
        registerCurrencyFormatter()
    }
    
    func registerCurrencyFormatter() {
        register(CBCurrencyFormatter.self) { _ in
            CBCurrencyFormatter()
        }.inObjectScope(.container)
    }
    
    func registerModule(_ assembly: Assembly) {
        assembly.assemble(container: self)
    }
}
