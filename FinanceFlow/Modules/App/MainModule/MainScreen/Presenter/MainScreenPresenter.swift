//
//  MainScreenPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 20.12.2025.
//
import ServicesAPI
import Domain
import Foundation
import CrashlyticsAPI

protocol MainScreenPresenterProtocol {
    func showTransactionManageScreen()
    func getCurrencySymbol() -> String
    func getCurrentBudget() -> Double
    func formTransactionsByCategories(type: TransactionType, for interval: DateInterval) -> [TransactionsByCategory]
    func getCategory(by id: UUID) -> TransactionCategory?
    func openTransactionsCategoryScreen(categoryId: UUID, interval: DateInterval)
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    weak var coordinator: MainModuleCoordinatorProtocol?
    private let settingsService: ISettingsService
    private let financeService: IFinanceService
    private let crashlytics: IAppCrashlytics
    
    init(
        settingsService: ISettingsService,
        financeService: IFinanceService,
        crashlytics: IAppCrashlytics
    ) {
        self.settingsService = settingsService
        self.financeService = financeService
        self.crashlytics = crashlytics
    }
    
    func showTransactionManageScreen() {
        coordinator?.showTransactionManageScreen()
    }
    
    func getCurrencySymbol() -> String {
        settingsService.getCurrencySymbol()
    }
    
    func getCurrentBudget() -> Double {
        do {
            return try financeService.getCurrentBudget()
        } catch {
            crashlytics.recordNonFatal(error, info: [
                "context": "MainScreenPresenter.getCurrentBudget"
            ])
            return 0
        }
    }
    
    func getTransactions(type: TransactionType, for interval: DateInterval) -> [Transaction] {
        do {
            return try financeService.getTransactions(for: interval).filter { $0.type == type }
        } catch {
            crashlytics.recordNonFatal(error, info: [
                "context": "MainScreenPresenter.getTransactions"
            ])
            return []
        }
    }
    
    func getCategory(by id: UUID) -> TransactionCategory? {
        do {
            return try financeService.getCategory(by: id)
        } catch {
            crashlytics.recordNonFatal(error, info: [
                "context": "MainScreenPresenter.getCategory"
            ])
            return nil
        }
    }
    
    func formTransactionsByCategories(type: TransactionType, for interval: DateInterval) -> [TransactionsByCategory] {
        let transactions = getTransactions(type: type, for: interval)
        
        let grouped = Dictionary(grouping: transactions) { $0.categoryId }
        
        return grouped.compactMap { category, categoryTransactions in
            let totalAmount = categoryTransactions.reduce(0) { $0 + $1.amount }
            if let category = getCategory(by: category) {
                return TransactionsByCategory(
                    category: category,
                    amount: totalAmount,
                    transactions: categoryTransactions)
            }
            return nil
        }
        .sorted { $0.amount > $1.amount }
    }
    
    func openTransactionsCategoryScreen(categoryId: UUID, interval: DateInterval) {
        coordinator?.showTransactionCategoryScreen(categoryId: categoryId, interval: interval)
    }
}
