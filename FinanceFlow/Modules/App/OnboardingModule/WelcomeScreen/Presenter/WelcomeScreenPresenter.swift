//
//  WelcomeScreenPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 04.12.2025.
//

protocol WelcomeScreenPresenterProtocol: AnyObject {
    var coordinator: OnboardingCoordinatorProtocol? { get set }
    func showCurrencyScreen()
}

final class WelcomeScreenPresenter: WelcomeScreenPresenterProtocol {
    weak var coordinator: OnboardingCoordinatorProtocol?
    
    func showCurrencyScreen() {
        coordinator?.showCurrencyScreen()
    }
}
