//
//  TransactionManageViewController.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//

import UIKit
import Domain

class TransactionManageViewController: UIViewController {
    var presenter: TransactionManagePresenterProtocol?
    private let transactionManageView = TransactionManageView()
    private(set) lazy var dataSource: CategoryCollectionDataSource = {
        CategoryCollectionDataSource()
    }()
    
    private(set) lazy var delegate: CategoryCollectionDelegate = {
        CategoryCollectionDelegate(vc: self)
    }()
    
    override func loadView() {
        view = transactionManageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardDismissal()
        configureView()
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func updateAddButtonState() {
        let hasAmount = !(transactionManageView.amountTextField.text?.isEmpty ?? true)
        let hasCategory = dataSource.selectedCategory != nil
        let dateSelected = transactionManageView.datePicker.selectedDate != nil
        let enabled = hasAmount && hasCategory && dateSelected

        transactionManageView.updateAddButton(enabled: enabled)
    }
    
    func configureView() {
        transactionManageView.delegate = self
        
        transactionManageView.amountTextField.delegate = self
        transactionManageView.amountTextField.addTarget(
                    self,
                    action: #selector(updateUnderlineState),
                    for: .editingChanged
                )
        
        transactionManageView.collectionView.delegate = delegate
        transactionManageView.collectionView.dataSource = dataSource
        
        transactionManageView.datePicker.onDateSelected = {[weak self] _ in
            self?.updateAddButtonState()
        }
        
        transactionManageView.configure(with: presenter?.getDefaultCurrency() ?? "")
        updateCollectionView(with: .EXPENSE)
        updateAddButtonState()
    }
}

extension TransactionManageViewController: UITextFieldDelegate {
    @objc private func updateUnderlineState() {
        let hasText = !(transactionManageView.amountTextField.text?.isEmpty ?? true)
        if hasText {
            transactionManageView.showActiveState()
            updateAddButtonState()
        } else {
            transactionManageView.showInactiveState()
            updateAddButtonState()
        }
    }
        
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        let newString = (currentText as NSString).replacingCharacters(in: range, with: string)

        if newString.isEmpty {
            return true
        }

        let allowedCharacters = CharacterSet(charactersIn: "0123456789.,")
        let characterSet = CharacterSet(charactersIn: string)
        guard characterSet.isSubset(of: allowedCharacters) else {
            return false
        }

        let separators = newString.filter { $0 == "." || $0 == "," }.count
        if separators > 1 {
            return false
        }

        if !newString.contains(where: { $0 == "." || $0 == "," }) {
            if newString.count > 1 && newString.first == "0" {
                return false
            }
            if newString == "0" {
                return true
            }
        } else {
            if newString.hasPrefix("0") {
                let secondChar = newString.count > 1 ? newString[newString.index(newString.startIndex, offsetBy: 1)] : nil
                if secondChar != "." && secondChar != "," {
                    return false
                }
                if newString.count >= 3 {
                    let thirdChar = newString[newString.index(newString.startIndex, offsetBy: 2)]
                    if !thirdChar.isNumber {
                        return false
                    }
                }
            }
        }

        return true
    }
}

extension TransactionManageViewController: TransactionManageDelegate {
    func updateCollectionView(with type: TransactionType) {
        dataSource.categories = presenter?.getCategories(for: type) ?? []
        transactionManageView.collectionView.reloadData()
    }
    func didTapIncome() {
        updateCollectionView(with: .INCOME)
    }
    
    func didTapExpense() {
        updateCollectionView(with: .EXPENSE)
    }
    
    func didAddButtonTapped() {
        presenter?.addTransaction(
            type: transactionManageView.isIncomeSelected ? .INCOME : .EXPENSE,
            amount: Double(transactionManageView.amountTextField.text ?? "0") ?? 0,
            category: dataSource.selectedCategory!,
            date: transactionManageView.datePicker.selectedDate ?? Date(),
            comment: transactionManageView.commentTextField.getText()
        )
        presenter?.closeScreen()
    }
    
    func didBackButtonTapped() {
        presenter?.closeScreen()
    }
}
