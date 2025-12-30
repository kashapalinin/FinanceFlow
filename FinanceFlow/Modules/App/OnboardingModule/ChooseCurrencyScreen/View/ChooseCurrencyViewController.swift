//
//  ChooseCurrencyViewController.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.12.2025.
//

import UIKit
import CurrencyFormatter

class ChooseCurrencyViewController: UIViewController {
    private let chooseCurrencyView = ChooseCurrencyView()
    var presenter: ChooseCurrencyPresenterProtocol?
    
    private lazy var dataSource: CurrenciesTableViewDataSource = {
        let dataSource = CurrenciesTableViewDataSource()
        dataSource.presenter = self.presenter
        return dataSource
    }()
    
    private lazy var delegate: CurrenciesTableViewDelegate = {
        let delegate = CurrenciesTableViewDelegate()
        delegate.presenter = self.presenter
        return delegate
    }()
    
    override func loadView() {
        view = chooseCurrencyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
    }
    
    private func setupView() {
        chooseCurrencyView.searchTextField.delegate = self
        chooseCurrencyView.searchButton.addTarget(self, action: #selector(performSearch), for: .touchUpInside)
        chooseCurrencyView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        chooseCurrencyView.tableView.dataSource = dataSource
        chooseCurrencyView.tableView.delegate = delegate
        chooseCurrencyView.updateNextButton(enabled: false)
    }

    @objc private func performSearch() {
        guard let searchText = chooseCurrencyView.searchTextField.text else { return }
        presenter?.searchCurrency(with: searchText)
    }
    
    @objc private func nextButtonTapped() {
        presenter?.nextButtonTapped()
    }
}

// MARK: - UITextFieldDelegate
extension ChooseCurrencyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if newText.isEmpty {
            presenter?.clearSearch()
        } else {
            presenter?.searchCurrency(with: newText)
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        presenter?.clearSearch()
        return true
    }
}

// MARK: - ChooseCurrencyViewProtocol
extension ChooseCurrencyViewController: ChooseCurrencyViewProtocol {
    func updateSelectedCurrency(_ currency: Currency) {
        chooseCurrencyView.tableView.reloadData()
        chooseCurrencyView.updateNextButton(enabled: presenter?.hasSelectedCurrency() ?? false)
    }
    
    func showLoading() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    func hideLoading() {
        view.subviews.filter { $0 is UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
    }
    
    func showCurrencies(_ currencies: [Currency]) {
        dataSource.update(currencies: currencies)
        chooseCurrencyView.tableView.reloadData()
    }
    
    func updateSelectedCurrency() {
        // Просто перезагружаем таблицу, чтобы обновить состояние ячеек
        chooseCurrencyView.tableView.reloadData()
        chooseCurrencyView.updateNextButton(enabled: presenter?.hasSelectedCurrency() ?? false)
    }
    
    func showError(_ error: Error, fallbackToRuble: Bool) {
        if fallbackToRuble {
            presenter?.selectRubleAsFallback()
            showAlert(title: "Ошибка сети", message: "Используется рубль по умолчанию")
        } else {
            showAlert(title: "Ошибка", message: error.localizedDescription)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension Currency {
    static func createRuble() -> Currency {
        return Currency(
            id: "R00000",
            numCode: "643",
            charCode: "RUB",
            nominal: 1,
            name: "Российский рубль",
            value: 1.0,
            vunitRate: 1
        )
    }
}
