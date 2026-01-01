// The Swift Programming Language
// https://docs.swift.org/swift-book
import CurrencyFormatter
import Foundation
import Domain

public protocol ISettingsService {
    func setCurrency(_ currency: Currency)
    func getDefaultCurrency() -> Currency?
    func getCurrencySymbol() -> String
}

public protocol IFinanceService {
    func saveBudget(sum: Double)
    func getInitialBudget() -> Double
    func getCurrentBudget() -> Double
    func getTransactions(for interval: DateInterval) -> [Transaction]
}
