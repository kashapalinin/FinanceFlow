//
//  AccountAmountAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 23.12.2025.
//
import UIKit
import ServicesAPI
import Swinject

final class AccountAmountAssembly {
    func assemble(coordinator: OnboardingCoordinatorProtocol, resolver: Resolver) -> UIViewController {
        let vc = AccountAmountViewController()
        let presenter = AccountAmountPresenter(
            settingsService: resolver.resolve(ISettingsService.self)!,
            financeService: resolver.resolve(IFinanceService.self)!
        )
        vc.presenter = presenter
        presenter.coordinator = coordinator
        return vc
    }
}

