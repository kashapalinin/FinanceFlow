//
//  TransactionsCategoryPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.01.2026.
//
import ServicesAPI
import Foundation
import Domain

protocol TransactionsCategoryPresenterProtocol {
    func backButtonTapped()
    func groupTransactionsByDate(_ transactions: [Transaction]) -> [(date: String, items: [Transaction])]
    func showTransactionScreen(transactionId: UUID)
    func getCategory(by id: UUID) -> TransactionCategory
    func getTransactions(categoryId: UUID, interval: DateInterval) -> [Transaction] 
}

final class TransactionsCategoryPresenter: TransactionsCategoryPresenterProtocol {
    weak var coordinator: MainModuleCoordinatorProtocol?
    private let financeService: IFinanceService
    
    init(financeService: IFinanceService) {
        self.financeService = financeService
    }
    
    func groupTransactionsByDate(_ transactions: [Transaction]) -> [(date: String, items: [Transaction])] {
        var groupedDict: [String: [Transaction]] = [:]
        
        // Группируем транзакции по дате
        for transaction in transactions {
            let createdAt = transaction.date
            
            let dateString = formatDate(createdAt)
            
            if groupedDict[dateString] == nil {
                groupedDict[dateString] = []
            }
            groupedDict[dateString]?.append(transaction)
        }
        
        let sortedGroups = groupedDict
            .map { (date: $0.key, items: $0.value) }
            .sorted { (group1, group2) -> Bool in
                // Сортируем группы по дате (от новой к старой)
                guard let date1 = parseDateFromString(group1.date),
                      let date2 = parseDateFromString(group2.date) else {
                    return false
                }
                return date1 > date2
            }
            .map { group -> (date: String, items: [Transaction]) in
                // Сортируем транзакции внутри группы (от новой к старой)
                let sortedItems = group.items.sorted { (t1, t2) -> Bool in
                    let date1 = t1.date
                    let date2 = t2.date
                    return date1 > date2
                }
                return (date: group.date, items: sortedItems)
            }
        
        return sortedGroups
    }
    
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Сегодня"
        } else if calendar.isDateInYesterday(date) {
            return "Вчера"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "dd MMMM yyyy"
            return dateFormatter.string(from: date)
        }
    }
    
    private func parseDateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        if dateString == "Сегодня" {
            return Calendar.current.startOfDay(for: Date())
        } else if dateString == "Вчера" {
            guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
                return nil
            }
            return Calendar.current.startOfDay(for: yesterday)
        } else {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            return dateFormatter.date(from: dateString)
        }
    }
    
    func backButtonTapped() {
        coordinator?.closeCurrentScreen()
    }
    
    func showTransactionScreen(transactionId: UUID) {
        coordinator?.showTransactionScreen(transactionId: transactionId)
    }
    
    func getCategory(by id: UUID) -> TransactionCategory {
        financeService.getCategory(by: id)
    }
    
    func getTransactions(categoryId: UUID, interval: DateInterval) -> [Transaction] {
        financeService.getTransactions(by: categoryId, interval: interval)
    }
}
