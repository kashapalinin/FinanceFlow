//
//  MainScreenPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 20.12.2025.
//
import ServicesAPI
import Domain
import Foundation

protocol MainScreenPresenterProtocol {
    func showTransactionManageScreen()
    func getCurrencySymbol() -> String
    func getCurrentBudget() -> Double
    func formTransactionsByCategories(type: TransactionType, for interval: DateInterval) -> [TransactionsByCategory]
    func getCategory(by id: UUID) -> TransactionCategory
    func openTransactionsCategoryScreen(categoryId: UUID, interval: DateInterval)
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
    
    func getTransactions(type: TransactionType, for interval: DateInterval) -> [Transaction] {
        financeService.getTransactions(for: interval).filter { $0.type == type }
    }
    
    func getCategory(by id: UUID) -> TransactionCategory {
        financeService.getCategory(by: id)
    }
    
    func formTransactionsByCategories(type: TransactionType, for interval: DateInterval) -> [TransactionsByCategory] {
        let transactions = getTransactions(type: type, for: interval)
        
        let grouped = Dictionary(grouping: transactions) { $0.categoryId }
        
        return grouped.map { category, categoryTransactions in
            let totalAmount = categoryTransactions.reduce(0) { $0 + $1.amount }
            
            return TransactionsByCategory(
                category: getCategory(by: category),
                amount: totalAmount,
                transactions: categoryTransactions
            )
        }
        .sorted { $0.amount > $1.amount }
    }
    
    func openTransactionsCategoryScreen(categoryId: UUID, interval: DateInterval) {
        coordinator?.showTransactionCategoryScreen(categoryId: categoryId, interval: interval)
    }
}
