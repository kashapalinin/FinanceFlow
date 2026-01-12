//
//  WelcomeScreenAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 04.12.2025.
//
import UIKit

final class WelcomeScreenAssembly {
    func assemble(coordinator: OnboardingCoordinatorProtocol) -> UIViewController {
        let vc = WelcomeViewController()
        let presenter = WelcomeScreenPresenter()
        vc.presenter = presenter
        presenter.coordinator = coordinator
        return vc
    }
}
