//
//  AccountAmountViewController.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 23.12.2025.
//
import CurrencyFormatter
import UIKit

class AccountAmountViewController: UIViewController {
    var presenter: AccountAmountPresenterProtocol?
    private var accountAmountView = AccountAmountView()
    
    override func loadView() {
        view = accountAmountView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountAmountView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        accountAmountView.amountTextField.delegate = self
        accountAmountView.amountTextField.addTarget(
                    self,
                    action: #selector(updateUnderlineState),
                    for: .editingChanged
                )
        if let currency = presenter?.getDefaultCurrency() {
            accountAmountView.setCurrency(currency.charCode)
        }
        
        setupKeyboardDismissal()
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func nextButtonTapped() {
        guard let rawInput = accountAmountView.getEnteredAmount(),
              !rawInput.isEmpty else {
            showErrorState(message: "Введите сумму")
            return
        }
        
        // Нормализуем: заменяем запятую на точку
        let normalized = rawInput.replacingOccurrences(of: ",", with: ".")
        
        guard let amount = Double(normalized),
              amount >= 0 else {
            showErrorState(message: "Сумма должна быть больше 0")
            return
        }
        
        presenter?.nextButtonTapped()
    }
    
    private func showErrorState(message: String) {
        // Можно показатьUIAlertController или просто анимацию ошибки
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.accountAmountView.transform = CGAffineTransform(translationX: 5, y: 0)
        } completion: { [weak self] _ in
            self?.accountAmountView.transform = .identity
        }
        
        accountAmountView.showInactiveState()
    }
}
extension AccountAmountViewController: UITextFieldDelegate {
    @objc private func updateUnderlineState() {
        let hasText = !(accountAmountView.amountTextField.text?.isEmpty ?? true)
        if hasText {
            accountAmountView.showActiveState()
        } else {
            accountAmountView.showInactiveState()
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
