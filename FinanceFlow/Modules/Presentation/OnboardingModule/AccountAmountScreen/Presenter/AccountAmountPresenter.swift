//
//  AccountAmountPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 23.12.2025.
//
import ServicesAPI
import CurrencyFormatter

protocol AccountAmountPresenterProtocol: AnyObject {
    func nextButtonTapped(budgetSum: Double)
    func getDefaultCurrency() -> Currency?
}

final class AccountAmountPresenter: AccountAmountPresenterProtocol {
    weak var coordinator: OnboardingCoordinatorProtocol?
    private let settingsService: ISettingsService
    private let financeService: IFinanceService
    
    init(
        settingsService: ISettingsService,
        financeService: IFinanceService
    ) {
        self.settingsService = settingsService
        self.financeService = financeService
    }
    
    func nextButtonTapped(budgetSum: Double) {
        financeService.saveBudget(sum: budgetSum)
        coordinator?.goToNextModule()
    }
    
    func getDefaultCurrency() -> Currency? {
        settingsService.getDefaultCurrency()
    }
}
