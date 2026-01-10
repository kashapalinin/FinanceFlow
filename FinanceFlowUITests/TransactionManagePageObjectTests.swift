//
//  TransactionManagePageObjectTests.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 10.01.2026.
//


import XCTest

class TransactionManagePageObjectTests: XCTestCase {
    
    var app: XCUIApplication!
    var page: TransactionManagePage!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["-UITesting"]
        app.launch()
        navigateToTransactionManageScreen()
        page = TransactionManagePage(app: app)
        
        XCTAssertTrue(page.navigationBar.waitForExistence(timeout: 10))
    }
    
    func testAddButtonActivationFlow() {
        page.verifyScreenLoaded()
        
        page.enterAmount("500")
        page.selectCategory()
        page.selectDate()
        page.verifyAddButtonEnabled(true)
    }
    
    func testCompleteTransaction() {
        page.fillRequiredFields(amount: "1499.99", categoryIndex: 0)
        page.addComment("Покупка продуктов")
        
        page.verifyAddButtonEnabled(true)
        page.tapAddButton()
        
        sleep(2)
        XCTAssertFalse(page.navigationBar.exists)
    }
    
    func testTabSwitchResetsState() {
        page.fillRequiredFields()
        page.verifyAddButtonEnabled(true)
        
        page.switchToIncomeTab()
        page.verifyAddButtonEnabled(false)
        
        page.selectCategory()
        page.verifyAddButtonEnabled(true)
    }
    
    private func navigateToTransactionManageScreen() {
        let addButton = app.buttons["AddTransactionButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 10), "Add button not found on main screen")
        addButton.tap()
        
        let operationsTitle = app.staticTexts["Операции"]
        XCTAssertTrue(operationsTitle.waitForExistence(timeout: 5), "Transaction manage screen did not load")
    }
}
