//
//  MockFinanceService.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
import ServicesAPI
import Domain
import Foundation

public class MockFinanceService: IFinanceService {
    var getCategoriesCalled = false
    var lastGetCategoriesType: TransactionType?
    var categoriesToReturn: [TransactionCategory] = []
    var getCategoriesError: Error?
    
    var addTransactionCalled = false
    var lastAddedTransaction: Transaction?
    
    public func getCategories(for type: TransactionType) throws -> [TransactionCategory] {
        getCategoriesCalled = true
        lastGetCategoriesType = type
        
        if let error = getCategoriesError {
            throw error
        }
        
        return categoriesToReturn
    }
    
    public func addTransaction(_ transaction: Transaction) {
        addTransactionCalled = true
        lastAddedTransaction = transaction
    }
    
    public func saveBudget(sum: Double) {
        
    }
    
    public func getInitialBudget() throws -> Double {
        0
    }
    
    public func getCurrentBudget() throws -> Double {
        0
    }
    
    public func getTransactions(for interval: DateInterval) throws -> [Transaction] {
        []
    }
    
    public func getCategory(by id: UUID) throws -> TransactionCategory? {
        nil
    }
    
    public func getTransaction(by id: UUID) throws -> Transaction? {
        nil
    }
    
    public func deleteTransaction(by id: UUID) throws {
        
    }
    
    public func getTransactions(by categoryId: UUID, interval: DateInterval) throws -> [Transaction] {
        []
    }
}
