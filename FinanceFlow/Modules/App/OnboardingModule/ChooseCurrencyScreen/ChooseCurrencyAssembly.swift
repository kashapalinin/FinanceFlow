//
//  ChooseCurrencyAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.12.2025.
//
import UIKit
import ServicesAPI
import Swinject

final class ChooseCurrencyAssembly {
    func assemble(coordinator: OnboardingCoordinatorProtocol, resolver: Resolver) -> UIViewController {
        let vc = ChooseCurrencyViewController()
        let presenter = ChooseCurrencyPresenter(service: resolver.resolve(IOnboardingService.self)!)
        vc.presenter = presenter
        presenter.coordinator = coordinator
        presenter.view = vc
        return vc
    }
}
