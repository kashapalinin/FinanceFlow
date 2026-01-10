//
//  TransactionManageViewControllerSnapshotTests.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 10.01.2026.
//
import XCTest
import SnapshotTesting
@testable import FinanceFlow
import Domain

final class TransactionManageViewControllerSnapshotTests: XCTestCase {
    
    var viewController: TransactionManageViewController!
    var mockPresenter: MockTransactionManagePresenter!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        mockPresenter = MockTransactionManagePresenter()
        
        viewController = TransactionManageViewController()
        viewController.presenter = mockPresenter
        
        window.rootViewController = UINavigationController(rootViewController: viewController)
        
        _ = viewController.view
        
        viewController.view.layoutIfNeeded()
        
        viewController.view.frame = window.bounds
        
        isRecording = false
        
        UIView.setAnimationsEnabled(false)
    }
    
    override func tearDown() {
        viewController = nil
        mockPresenter = nil
        window = nil
        super.tearDown()
    }
    
    func test_initial_state_expenses_selected() {
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "initial_state_expenses_selected"
        )
    }
    
    func test_income_tab_selected() {
        viewController.transactionManageView.setSelectedTab(true, animated: false)
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "income_tab_selected"
        )
    }
    
    func test_with_amount_entered() {
        viewController.transactionManageView.amountTextField.text = "123.45"
        viewController.updateUnderlineState()
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "with_amount_entered"
        )
    }
    
    func test_with_category_selected() {
        let category = TransactionCategory(id: UUID(), name: "Еда", type: .EXPENSE, icon: Data(), color: Data())
        viewController.dataSource.selectedCategory = category
        
        viewController.transactionManageView.collectionView.reloadData()
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "with_category_selected"
        )
    }
    
    func test_with_date_selected() {
        let date = Date()
        viewController.transactionManageView.datePicker.selectedDate = date
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "with_date_selected"
        )
    }
    
    func test_with_comment_entered() {
        viewController.transactionManageView.commentTextField.setText("Тестовый комментарий для транзакции")
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "with_comment_entered"
        )
    }
    
    func test_add_button_enabled() {
        viewController.transactionManageView.amountTextField.text = "1000"
        viewController.updateUnderlineState()
        
        let category = TransactionCategory(id: UUID(), name: "Еда", type: .EXPENSE, icon: Data(), color: Data())
        viewController.dataSource.selectedCategory = category
        
        let date = Date()
        viewController.transactionManageView.datePicker.selectedDate = date
        
        viewController.updateAddButtonState()
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "add_button_enabled"
        )
    }
    
    func test_add_button_disabled() {
        viewController.transactionManageView.updateAddButton(enabled: false)
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "add_button_disabled"
        )
    }
    
    func test_active_text_field_state() {
        viewController.transactionManageView.showActiveState()
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "active_text_field_state"
        )
    }
    
    func test_all_fields_filled() {
        // Полностью заполненная форма
        viewController.transactionManageView.setSelectedTab(false, animated: false)
        viewController.transactionManageView.amountTextField.text = "2499.99"
        viewController.updateUnderlineState()
        
        let category = TransactionCategory(id: UUID(), name: "Еда", type: .EXPENSE, icon: Data(), color: Data())
        viewController.dataSource.selectedCategory = category
        
        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        viewController.transactionManageView.datePicker.selectedDate = date
        
        viewController.transactionManageView.commentTextField.setText("Посещение кинотеатра с друзьями")
        viewController.updateAddButtonState()
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "all_fields_filled_expenses"
        )
    }
    
    func test_income_all_fields_filled() {
        viewController.transactionManageView.setSelectedTab(true, animated: false)
        viewController.transactionManageView.amountTextField.text = "50000"
        viewController.updateUnderlineState()
        
        let category = TransactionCategory(id: UUID(), name: "Зарплата", type: .INCOME, icon: Data(), color: Data())
        viewController.dataSource.selectedCategory = category
        
        let date = Date()
        viewController.transactionManageView.datePicker.selectedDate = date
        
        viewController.transactionManageView.commentTextField.setText("Зарплата за январь 2024")
        viewController.updateAddButtonState()
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "all_fields_filled_income"
        )
    }
    
    func test_different_date_states() {
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        viewController.transactionManageView.datePicker.selectedDate = yesterday
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "date_yesterday"
        )
        
        let dayBeforeYesterday = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        viewController.transactionManageView.datePicker.selectedDate = dayBeforeYesterday
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "date_day_before_yesterday"
        )
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        viewController.transactionManageView.datePicker.selectedDate = tomorrow
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "date_tomorrow"
        )
    }
    
    func test_large_amount() {
        viewController.transactionManageView.amountTextField.text = "9999999.99"
        viewController.updateUnderlineState()
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "large_amount"
        )
    }
    
    func test_zero_amount() {
        viewController.transactionManageView.amountTextField.text = "0"
        viewController.updateUnderlineState()
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "zero_amount"
        )
    }
    
    func test_decimal_amount() {
        viewController.transactionManageView.amountTextField.text = "123.4567"
        viewController.updateUnderlineState()
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "decimal_amount"
        )
    }
    
    func test_long_comment() {
        let longComment = """
        Очень длинный комментарий для тестирования отображения текстового поля. 
        Этот комментарий должен занимать несколько строк и показывать, 
        как интерфейс адаптируется под длинный текст.
        """
        
        viewController.transactionManageView.commentTextField.setText(longComment)
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "long_comment"
        )
    }
    
    func test_dark_mode_initial() {
        viewController.overrideUserInterfaceStyle = .dark
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "dark_mode_initial"
        )
    }
    
    func test_dark_mode_all_filled() {
        viewController.overrideUserInterfaceStyle = .dark
        
        viewController.transactionManageView.amountTextField.text = "1500"
        viewController.updateUnderlineState()
        
        let category = TransactionCategory(id: UUID(), name: "Еда", type: .EXPENSE, icon: Data(), color: Data())
        viewController.dataSource.selectedCategory = category
        
        viewController.transactionManageView.datePicker.selectedDate = Date()
        viewController.transactionManageView.commentTextField.setText("Ужин в ресторане")
        viewController.updateAddButtonState()
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13),
            named: "dark_mode_all_filled"
        )
    }
    
    func test_different_device_sizes() {
        let configurations: [(String, ViewImageConfig)] = [
            ("iPhone_SE", .iPhoneSe),
            ("iPhone_8", .iPhone8),
            ("iPhone_13", .iPhone13),
            ("iPhone_13_Pro_Max", .iPhone13ProMax)
        ]
        
        viewController.transactionManageView.amountTextField.text = "1000"
        viewController.updateUnderlineState()
        
        let category = TransactionCategory(id: UUID(), name: "Еда", type: .EXPENSE, icon: Data(), color: Data())
        viewController.dataSource.selectedCategory = category
        
        viewController.transactionManageView.datePicker.selectedDate = Date()
        viewController.updateAddButtonState()
        
        for (name, config) in configurations {
            assertSnapshot(
                of: viewController,
                as: .image(on: config),
                named: "\(name)_size"
            )
        }
    }
    
    func test_dynamic_type_large() {
        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityLarge)
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13, traits: traits),
            named: "dynamic_type_large"
        )
    }
    
    func test_dynamic_type_extra_large() {
        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraLarge)
        
        assertSnapshot(
            of: viewController,
            as: .image(on: .iPhone13, traits: traits),
            named: "dynamic_type_extra_large"
        )
    }
    
    func test_app_store_screenshot_ready() {
        viewController.transactionManageView.setSelectedTab(false, animated: false)
        viewController.transactionManageView.amountTextField.text = "149.99"
        viewController.updateUnderlineState()
        
        let category = TransactionCategory(id: UUID(), name: "Еда", type: .EXPENSE, icon: Data(), color: Data())
        viewController.dataSource.selectedCategory = category
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let niceDate = formatter.date(from: "2024-01-15")!
        viewController.transactionManageView.datePicker.selectedDate = niceDate
        
        viewController.transactionManageView.commentTextField.setText("Утренний кофе в Starbucks")
        viewController.updateAddButtonState()
        
        viewController.transactionManageView.amountTextField.tintColor = .clear
        
        assertSnapshot(
            matching: viewController,
            as: .image(on: .iPhone13ProMax),
            named: "app_store_screenshot"
        )
    }
}

class MockTransactionManagePresenter: TransactionManagePresenterProtocol {
    func addTransaction(type: Domain.TransactionType, amount: Double, category: TransactionCategory, date: Date, comment: String?) {
        
    }
    
    var mockCategories: [TransactionCategory] = [
        TransactionCategory(id: UUID(), name: "Еда", type: .EXPENSE, icon: Data(), color: Data()),
        TransactionCategory(id: UUID(), name: "Транспорт", type: .EXPENSE, icon: Data(), color: Data()),
        TransactionCategory(id: UUID(), name: "Развлечения", type: .EXPENSE, icon: Data(), color: Data()),
        TransactionCategory(id: UUID(), name: "Одежда", type: .EXPENSE, icon: Data(), color: Data()),
    ]
    
    var mockIncomeCategories: [TransactionCategory] = [
        TransactionCategory(id: UUID(), name: "Зарплата", type: .INCOME, icon: Data(), color: Data()),
        TransactionCategory(id: UUID(), name: "Фриланс", type: .INCOME, icon: Data(), color: Data()),
        TransactionCategory(id: UUID(), name: "Инвестиции", type: .INCOME, icon: Data(), color: Data())
    ]
    
    func getCategories(for type: TransactionType) -> [TransactionCategory] {
        switch type {
        case .EXPENSE:
            return mockCategories
        case .INCOME:
            return mockIncomeCategories
        }
    }
    
    func getDefaultCurrency() -> String {
        return "USD"
    }
    
    func addTransaction(type: TransactionType, amount: Double, category: TransactionCategory, date: Date, comment: String) {
        print("Mock: Adding transaction - \(type), \(amount), \(category.name)")
    }
    
    func closeScreen() {
        print("Mock: Closing screen")
    }
}
