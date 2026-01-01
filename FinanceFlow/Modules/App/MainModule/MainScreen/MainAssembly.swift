//
//  MainAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 20.12.2025.
//
import UIKit
import Swinject
import ServicesAPI

final class MainAssembly {
    func assemble(coordinator: MainModuleCoordinatorProtocol, resolver: Resolver) -> UIViewController {
        let vc = MainScreenViewController()
        let presenter = MainScreenPresenter(
            settingsService: resolver.resolve(ISettingsService.self)!,
            financeService: resolver.resolve(IFinanceService.self)!
        )
        vc.presenter = presenter
        presenter.coordinator = coordinator
        return vc
    }
}
