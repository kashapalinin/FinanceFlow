// The Swift Programming Language
// https://docs.swift.org/swift-book
import CurrencyFormatter
import Foundation
import Domain

public protocol ISettingsService {
    func setCurrency(_ currency: Currency)
    func getDefaultCurrency() -> Currency?
    func getCurrencySymbol() -> String
    func getCurrencyCode() -> String
}

public protocol IFinanceService {
    func saveBudget(sum: Double)
    func getInitialBudget() -> Double
    func getCurrentBudget() -> Double
    func getTransactions(for interval: DateInterval) -> [Transaction]
    func getCategories(for transactionType: TransactionType) -> [TransactionCategory]
    func getCategory(by id: UUID) -> TransactionCategory
    func getTransaction(by id: UUID) -> Transaction
    func addTransaction(_ transaction: Transaction)
    func deleteTransaction(by id: UUID)
    func getTransactions(by categoryId: UUID, interval: DateInterval) -> [Transaction]
}
