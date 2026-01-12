//
//  TransactionManagePresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//
import Foundation
import CoreData
import Domain
import ServicesAPI
import CurrencyFormatter
import CrashlyticsAPI

protocol TransactionManagePresenterProtocol {
    func getCategories(for type: TransactionType) -> [TransactionCategory]
    func addTransaction(type: TransactionType, amount: Double, category: TransactionCategory, date: Date, comment: String?)
    func closeScreen()
    func getDefaultCurrency() -> String
}

class TransactionManagePresenter: TransactionManagePresenterProtocol {
    weak var coordinator: TransactionManageModuleCoordinatorProtocol?

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
    
    func getCategories(for type: TransactionType) -> [TransactionCategory] {
        do {
            return try financeService.getCategories(for: type)
        } catch {
            crashlytics.recordNonFatal(error, info: [
                "context": "getCategories"
            ])
            return []
        }
    }
    
    func addTransaction(type: TransactionType, amount: Double, category: TransactionCategory, date: Date, comment: String? = nil) {
        let transaction = Transaction(
            id: UUID(),
            amount: amount,
            categoryId: category.id,
            date: date,
            note: comment,
            type: type
        )
        financeService.addTransaction(transaction)
    }
    
    func closeScreen() {
        coordinator?.flowCompletionHandler?()
    }
    
    func getDefaultCurrency() -> String {
        settingsService.getCurrencyCode()
    }
}
