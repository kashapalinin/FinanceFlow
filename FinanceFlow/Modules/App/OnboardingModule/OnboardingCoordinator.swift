//
//  OnboardingCoordinator.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 03.12.2025.
//
import UIKit
import Swinject

protocol OnboardingCoordinatorProtocol: Coordinator {
    func showWelcomeScreen()
    func showCurrencyScreen()
    func showAccountAmountScreen()
    func goToNextModule()
}

final class OnboardingCoordinator: OnboardingCoordinatorProtocol {
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    private let resolver: Resolver

    init(navigationController: UINavigationController, resolver: Resolver) {
        self.navigationController = navigationController
        self.resolver = resolver
    }

    func start() {
        showWelcomeScreen()
    }
    
    func showWelcomeScreen() {
        let assembly = resolver.resolve(WelcomeScreenAssembly.self)!
        let vc = assembly.assemble(coordinator: self)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showCurrencyScreen() {
        let assembly = resolver.resolve(ChooseCurrencyAssembly.self)!
        let vc = assembly.assemble(coordinator: self, resolver: resolver)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func showAccountAmountScreen() {
        let assembly = resolver.resolve(AccountAmountAssembly.self)!
        let vc = assembly.assemble(coordinator: self, resolver: resolver)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    func goToNextModule() {
        flowCompletionHandler?()
    }
}
