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
}
