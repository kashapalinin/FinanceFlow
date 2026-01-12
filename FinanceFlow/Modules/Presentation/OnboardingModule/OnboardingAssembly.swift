//
//  OnboardingModule.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 07.12.2025.
//
import Swinject
import UIKit

final class OnboardingAssembly: Assembly {
    func assemble(container: Container) {
        container.register(OnboardingCoordinatorProtocol.self) { (resolver: Resolver, nc: UINavigationController) in
            OnboardingCoordinator(
                navigationController: nc,
                resolver: resolver
            )
        }.inObjectScope(.transient)
        
        container.register(ChooseCurrencyAssembly.self) { _ in
            ChooseCurrencyAssembly()
        }
        
        container.register(WelcomeScreenAssembly.self) { _ in
            WelcomeScreenAssembly()
        }
        
        container.register(AccountAmountAssembly.self) { _ in
            AccountAmountAssembly()
        }
    }
}
