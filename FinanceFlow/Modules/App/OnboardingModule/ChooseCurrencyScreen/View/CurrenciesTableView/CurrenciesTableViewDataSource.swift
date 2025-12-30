//
//  CurrenciesTableViewDataSource.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 06.12.2025.
//
import UIKit
import CurrencyFormatter

final class CurrenciesTableViewDataSource: NSObject, UITableViewDataSource {
    var dataSource: [Currency] = []
    weak var presenter: ChooseCurrencyPresenterProtocol?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.reuseIdentifier, for: indexPath) as? CurrencyCell else { return UITableViewCell() }
        
        let currency = dataSource[indexPath.row]
        let isSelected = presenter?.isCurrencySelected(currency.id) ?? false
        cell.configure(with: currency, isSelected: isSelected)
        return cell
    }
    
    func update(currencies: [Currency]) {
        self.dataSource = currencies
    }
}
