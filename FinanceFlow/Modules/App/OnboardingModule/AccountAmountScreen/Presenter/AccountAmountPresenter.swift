//
//  AccountAmountPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 23.12.2025.
//
import ServicesAPI
import CurrencyFormatter

protocol AccountAmountPresenterProtocol: AnyObject {
    func nextButtonTapped()
    func getDefaultCurrency() -> Currency?
}

final class AccountAmountPresenter: AccountAmountPresenterProtocol {
    weak var coordinator: OnboardingCoordinatorProtocol?
    private let service: IOnboardingService
    
    init(service: IOnboardingService) {
        self.service = service
    }
    
    func nextButtonTapped() {
        coordinator?.goToNextModule()
    }
    
    func getDefaultCurrency() -> Currency? {
        service.getDefaultCurrency()
    }
}
