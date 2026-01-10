//
//  TransactionManagePage.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 10.01.2026.
//
import XCTest

class TransactionManagePage {
    private let app: XCUIApplication
    
    var navigationBar: XCUIElement { app.staticTexts["Операции"] }
    var expensesTab: XCUIElement { app.buttons["Расходы"] }
    var incomeTab: XCUIElement { app.buttons["Доходы"] }
    var amountField: XCUIElement { app.textFields["amountTextField"] }
    var addButton: XCUIElement { app.buttons["Добавить"] }
    var commentField: XCUIElement { app.textFields["Комментарий"] }
    var categoriesCollection: XCUIElement { app.collectionViews.firstMatch }
    var datePickerElement: XCUIElement {
        app.staticTexts.matching(NSPredicate(format: "label CONTAINS[cd] %@", "дата")).firstMatch
    }
    
    init(app: XCUIApplication) {
        self.app = app
    }
        
    func enterAmount(_ amount: String) {
        amountField.tap()
        
        // Очистка поля
        if let currentValue = amountField.value as? String, !currentValue.isEmpty {
            amountField.doubleTap()
            
            // Удаление через меню или клавишу
            let selectAllMenu = app.menuItems["Select All"]
            if selectAllMenu.exists {
                selectAllMenu.tap()
                app.keys["delete"].tap()
            } else {
                amountField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue,
                                          count: currentValue.count))
            }
        }
        
        amountField.typeText(amount)
        dismissKeyboard()
        sleep(1)
    }
    
    func selectCategory(at index: Int = 0) {
        XCTAssertTrue(categoriesCollection.waitForExistence(timeout: 5))
        
        if categoriesCollection.cells.count > index {
            categoriesCollection.cells.element(boundBy: index).tap()
            sleep(1)
        }
    }
    
    func selectDate() {
        if datePickerElement.exists {
            datePickerElement.tap()
            sleep(2)
            
            // Закрываем календарь (в UI тестах дата выбирается автоматически в моке)
            let doneButton = app.buttons.matching(NSPredicate(format: "label IN {'Готово', 'Done'}")).firstMatch
            if doneButton.exists {
                doneButton.tap()
            } else {
                app.tap()
            }
            sleep(1)
        }
    }
    
    func addComment(_ text: String) {
        if commentField.exists {
            commentField.tap()
            commentField.typeText(text)
            dismissKeyboard()
        }
    }
    
    func switchToIncomeTab() {
        incomeTab.tap()
        sleep(1)
    }
    
    func switchToExpensesTab() {
        expensesTab.tap()
        sleep(1)
    }
    
    func tapAddButton() {
        addButton.tap()
    }
    
    func verifyScreenLoaded() {
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 10))
        XCTAssertTrue(expensesTab.exists)
        XCTAssertTrue(addButton.exists)
    }
    
    func verifyAddButtonEnabled(_ enabled: Bool, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(addButton.isEnabled, enabled,
                      "Add button should be \(enabled ? "enabled" : "disabled")",
                      file: file, line: line)
    }
    
    func verifyAmountEntered(_ expectedAmount: String? = nil) {
        if let expected = expectedAmount {
            XCTAssertEqual(amountField.value as? String, expected)
        } else {
            XCTAssertNotNil(amountField.value as? String)
            XCTAssertFalse((amountField.value as? String)?.isEmpty ?? true)
        }
    }
        
    private func dismissKeyboard() {
        if app.keyboards.element.exists {
            let returnButton = app.buttons["Return"]
            let doneButton = app.buttons["Done"]
            
            if returnButton.exists {
                returnButton.tap()
            } else if doneButton.exists {
                doneButton.tap()
            } else {
                app.tap()
            }
        }
    }
    
    func fillRequiredFields(amount: String = "1000", categoryIndex: Int = 0) {
        enterAmount(amount)
        selectCategory(at: categoryIndex)
        selectDate()
    }
}
