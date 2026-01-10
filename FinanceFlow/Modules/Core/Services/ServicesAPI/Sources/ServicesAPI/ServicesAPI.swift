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
    func hasAppAlreadyBeenOpened() -> Bool
    func isSurveyCompleted() -> Bool
    func markSurveyAsCompleted()
}

public protocol IFinanceService {
    func saveBudget(sum: Double)
    func getInitialBudget() throws -> Double
    func getCurrentBudget() throws -> Double
    func getTransactions(for interval: DateInterval) throws -> [Transaction]
    func getCategories(for transactionType: TransactionType) throws -> [TransactionCategory]
    func getCategory(by id: UUID) throws -> TransactionCategory?
    func getTransaction(by id: UUID) throws -> Transaction?
    func addTransaction(_ transaction: Transaction)
    func deleteTransaction(by id: UUID) throws
    func getTransactions(by categoryId: UUID, interval: DateInterval) throws -> [Transaction]
}

public protocol ISurveyBDUIService {
    func fetchSurvey() async throws -> SurveyPageDTO
    func send(result: SurveyResult) async throws
}
