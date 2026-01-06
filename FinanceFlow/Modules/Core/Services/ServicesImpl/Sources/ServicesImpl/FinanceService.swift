//
//  BudgetStorageService.swift
//  ServicesImpl
//
//  Created by Павел Калинин on 31.12.2025.
//
import ServicesAPI
import StorageAPI
import Domain
import Foundation
import UIKit

final public class FinanceService: IFinanceService {
    
    private var coreDataManager: ICoreDataManager
    
    public init(coreDataManager: ICoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    public func saveBudget(sum: Double) {
        let _ = Budget(id: UUID(), amount: sum, startDate: Date()).toBudgetEntity(context: coreDataManager.viewContext)
        coreDataManager.saveContext()
    }
    
    public func getInitialBudget() -> Double {
        let request = BudgetEntity.fetchRequest()
        let entity = (try? (coreDataManager.viewContext.fetch(request))) ?? []
        return entity.first?.toBudget().amount ?? 0
    }
    
    public func getTransactions(for interval: DateInterval) -> [Transaction] {
        let request = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            interval.start as NSDate,
            interval.end as NSDate
        )
        return (try? coreDataManager.viewContext.fetch(request).map{ $0.toTransaction() }) ?? []
    }
    
    public func getCategories(for transactionType: TransactionType) -> [TransactionCategory] {
        let request = CategoryEntity.fetchRequest()
        
        do {
            let existing = try coreDataManager.viewContext.fetch(request)
            if !existing.isEmpty {
                return existing.compactMap { $0.toCategory() }.filter { $0.type == transactionType }
            }
        } catch {
            print("Ошибка загрузки категорий: \(error)")
            return []
        }
        
        createDefaultCategories()
        
        return getCategories(for: transactionType)
    }
    
    func createDefaultCategories() {
        DefaultCategories.expenses.forEach {$0.toCategoryEntity(context: coreDataManager.viewContext)}
        DefaultCategories.incomes.forEach {$0.toCategoryEntity(context: coreDataManager.viewContext)}
        
        coreDataManager.saveContext()
    }
    
    public func getCurrentBudget() -> Double {
        let budget = getInitialBudget()
        let transactions = getTransactions(for: DateInterval(start: .distantPast, end: .distantFuture))
        
        var result = budget
        
        for transaction in transactions {
            switch transaction.type {
            case .EXPENSE:
                result -= transaction.amount
            case .INCOME:
                result += transaction.amount
            }
        }
        
        return result
    }
    
    public func addTransaction(_ transaction: Transaction) {
        let _ = transaction.toTransactionEntity(context: coreDataManager.viewContext)
        coreDataManager.saveContext()
    }
    
    public func getCategory(by id: UUID) -> TransactionCategory {
        let request = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )
        return ((try? coreDataManager.viewContext.fetch(request).map{ $0.toCategory() }) ?? []).first!
    }
    
    public func getTransactions(by categoryId: UUID, interval: DateInterval) -> [Transaction] {
        let request = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@ AND categoryId == %@",
            interval.start as NSDate,
            interval.end as NSDate,
            categoryId as CVarArg
        )
        return (try? coreDataManager.viewContext.fetch(request).map{ $0.toTransaction() }) ?? []
    }
    
    public func getTransaction(by id: UUID) -> Transaction {
        let request = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@",
            id as CVarArg
        )
        return ((try? coreDataManager.viewContext.fetch(request).map { $0.toTransaction() }) ?? []).first!
    }
    
    public func deleteTransaction(by id: UUID) {
        let fetchRequest = TransactionEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        let results = try? coreDataManager.viewContext.fetch(fetchRequest)
        
        if let transactionToDelete = results?.first {
            coreDataManager.viewContext.delete(transactionToDelete)
            coreDataManager.saveContext()
            print("Транзакция с ID \(id) удалена")
        } else {
            print("Транзакция с ID \(id) не найдена")
        }
    }
}
