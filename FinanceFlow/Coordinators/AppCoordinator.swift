//
//  AppCoordinator.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 22.11.2025.
//
import UIKit
import Swinject
import AnalyticsAPI

final class AppCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    private var childCoordinators: [Coordinator] = []
    private let resolver: Resolver

    init(
        navigationController: UINavigationController,
        resolver: Resolver
    )
    {
        self.navigationController = navigationController
        self.resolver = resolver
    }

    func start() {
        showLoadingAppModule()
        resolver.resolve(IAppAnalytics.self)!.trackAppLaunch()
    }
    
    func showLoadingAppModule() {
        let coordinator = resolver.resolve(LoadingAppCoordinatorProtocol.self, argument: navigationController)!
        childCoordinators.append(coordinator)
        
        coordinator.flowCompletionHandler = {[weak self] in
            self?.childCoordinators = []
            self?.showMainApp()
        }
        coordinator.start()
    }
    
    func showMainApp() {
        if UserDefaults.standard.bool(forKey: "isAlreadyOpened") {
            showMainModule()
        }else {
            showOnboardingModule()
        }
    }
    
    func showOnboardingModule() {
        let coordinator = resolver.resolve(OnboardingCoordinatorProtocol.self, argument: navigationController)!
        childCoordinators.append(coordinator)
        
        coordinator.flowCompletionHandler = {[weak self] in
            self?.showMainModule()
            UserDefaults.standard.set(true, forKey: "isAlreadyOpened")
        }
        
        coordinator.start()
    }
    
    func showMainModule() {
        let coordinator = resolver.resolve(MainModuleCoordinatorProtocol.self, argument: navigationController)!
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
}
