//
//  MainScreenPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 20.12.2025.
//
import ServicesAPI

protocol MainScreenPresenterProtocol {
    func showTransactionManageScreen()
    func getCurrencySymbol() -> String
    func getCurrentBudget() -> Double
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    weak var coordinator: MainModuleCoordinatorProtocol?
    private var settingsService: ISettingsService
    private var financeService: IFinanceService
    
    init(
        settingsService: ISettingsService,
        financeService: IFinanceService
    ) {
        self.settingsService = settingsService
        self.financeService = financeService
    }
    
    func showTransactionManageScreen() {
        coordinator?.showTransactionManageScreen()
    }
    
    func getCurrencySymbol() -> String {
        settingsService.getCurrencySymbol()
    }
    
    func getCurrentBudget() -> Double {
        financeService.getCurrentBudget()
    }
}
