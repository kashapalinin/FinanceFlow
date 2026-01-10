//
//  TransactionManagePresenterTests.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//


import XCTest
@testable import FinanceFlow
import Domain
import ServicesAPI
import UIKit

class TransactionManagePresenterTests: XCTestCase {
    
    private var presenter: TransactionManagePresenter!
    private var mockCoordinator: MockTransactionManageCoordinator!
    private var mockSettingsService: MockSettingsService!
    private var mockFinanceService: MockFinanceService!
    private var mockCrashlytics: MockCrashlytics!
    
    override func setUp() {
        super.setUp()
        mockCoordinator = MockTransactionManageCoordinator(navigationController: UINavigationController())
        mockSettingsService = MockSettingsService()
        mockFinanceService = MockFinanceService()
        mockCrashlytics = MockCrashlytics()
        
        presenter = TransactionManagePresenter(
            settingsService: mockSettingsService,
            financeService: mockFinanceService,
            crashlytics: mockCrashlytics
        )
        presenter.coordinator = mockCoordinator
    }
    
    override func tearDown() {
        presenter = nil
        mockCoordinator = nil
        mockSettingsService = nil
        mockFinanceService = nil
        mockCrashlytics = nil
        super.tearDown()
    }
    
    func test_getCategories_success() {
        // Given
        let expectedCategories = [
            TransactionCategory(id: UUID(), name: "Зарплата", type: .INCOME, icon: Data(), color: Data())
        ]
        mockFinanceService.categoriesToReturn = expectedCategories
        let transactionType = TransactionType.INCOME
        
        // When
        let categories = presenter.getCategories(for: transactionType)
        
        // Then
        XCTAssertEqual(categories.count, expectedCategories.count)
        XCTAssertEqual(categories, expectedCategories)
        XCTAssertTrue(mockFinanceService.getCategoriesCalled)
        XCTAssertEqual(mockFinanceService.lastGetCategoriesType, transactionType)
        XCTAssertFalse(mockCrashlytics.recordNonFatalCalled)
    }
    
    func test_getCategories_failure_recordsToCrashlytics() {
        // Given
        let expectedError = NSError(domain: "Test", code: 500, userInfo: nil)
        mockFinanceService.getCategoriesError = expectedError
        let transactionType = TransactionType.INCOME
        
        // When
        let categories = presenter.getCategories(for: transactionType)
        
        // Then
        XCTAssertTrue(categories.isEmpty)
        XCTAssertTrue(mockFinanceService.getCategoriesCalled)
        XCTAssertEqual(mockFinanceService.lastGetCategoriesType, transactionType)
        XCTAssertTrue(mockCrashlytics.recordNonFatalCalled)
        XCTAssertEqual(mockCrashlytics.lastRecordedError as NSError?, expectedError)
        XCTAssertEqual(mockCrashlytics.lastInfo?["context"] as? String, "getCategories")
    }

    func test_addTransaction_withComment() {
        // Given
        let type = TransactionType.EXPENSE
        let amount = 100.0
        let category = TransactionCategory(id: UUID(), name: "Еда", type: type, icon: Data(), color: Data())
        let date = Date()
        let comment = "Lunch at restaurant"
        
        // When
        presenter.addTransaction(
            type: type,
            amount: amount,
            category: category,
            date: date,
            comment: comment
        )
        
        // Then
        XCTAssertTrue(mockFinanceService.addTransactionCalled)
        XCTAssertNotNil(mockFinanceService.lastAddedTransaction)
        
        let transaction = mockFinanceService.lastAddedTransaction!
        XCTAssertEqual(transaction.amount, amount)
        XCTAssertEqual(transaction.categoryId, category.id)
        XCTAssertEqual(transaction.date, date)
        XCTAssertEqual(transaction.note, comment)
        XCTAssertEqual(transaction.type, type)
    }
    
    func test_addTransaction_withoutComment() {
        // Given
        let type = TransactionType.INCOME
        let amount = 500.0
        let category = TransactionCategory(id: UUID(), name: "Зарплата", type: type, icon: Data(), color: Data())
        let date = Date()
        
        // When
        presenter.addTransaction(
            type: type,
            amount: amount,
            category: category,
            date: date,
            comment: nil
        )
        
        // Then
        XCTAssertTrue(mockFinanceService.addTransactionCalled)
        XCTAssertNotNil(mockFinanceService.lastAddedTransaction)
        
        let transaction = mockFinanceService.lastAddedTransaction!
        XCTAssertEqual(transaction.amount, amount)
        XCTAssertEqual(transaction.categoryId, category.id)
        XCTAssertEqual(transaction.date, date)
        XCTAssertNil(transaction.note)
        XCTAssertEqual(transaction.type, type)
    }
    
    func test_addTransaction_generatesUUID() {
        // Given
        let category = TransactionCategory(id: UUID(), name: "Test", type: .EXPENSE, icon: Data(), color: Data())
        
        // When
        presenter.addTransaction(
            type: .EXPENSE,
            amount: 50.0,
            category: category,
            date: Date(),
            comment: nil
        )
        
        // Then
        XCTAssertNotNil(mockFinanceService.lastAddedTransaction?.id)
    }
    
    func test_closeScreen_callsCoordinatorCompletion() {
        // Given
        var completionCalled = false
        mockCoordinator.flowCompletionHandler = { completionCalled = true }
        
        // When
        presenter.closeScreen()
        
        // Then
        XCTAssertTrue(completionCalled)
    }
    
    func test_closeScreen_withNilCoordinator() {
        // Given
        presenter.coordinator = nil
        
        // When & Then - Should not crash
        presenter.closeScreen()
    }
    
    func test_closeScreen_withNilCompletionHandler() {
        // Given
        mockCoordinator.flowCompletionHandler = nil
        
        // When & Then - Should not crash
        presenter.closeScreen()
    }
    
    func test_getDefaultCurrency_returnsCurrencyCode() {
        // Given
        let expectedCurrency = "USD"
        mockSettingsService.currencyCodeToReturn = expectedCurrency
        
        // When
        let currency = presenter.getDefaultCurrency()
        
        // Then
        XCTAssertEqual(currency, expectedCurrency)
        XCTAssertTrue(mockSettingsService.getCurrencyCodeCalled)
    }
    
    func test_getDefaultCurrency_returnsEmptyStringIfServiceFails() {
        // Given
        mockSettingsService.currencyCodeToReturn = ""
        
        // When
        let currency = presenter.getDefaultCurrency()
        
        // Then
        XCTAssertEqual(currency, "")
        XCTAssertTrue(mockSettingsService.getCurrencyCodeCalled)
    }
}
