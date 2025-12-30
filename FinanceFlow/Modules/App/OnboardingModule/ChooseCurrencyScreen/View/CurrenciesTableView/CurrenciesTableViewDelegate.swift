//
//  CurrenciesTableViewDelegate.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 06.12.2025.
//
import UIKit
import CurrencyFormatter

final class CurrenciesTableViewDelegate: NSObject, UITableViewDelegate {
    weak var presenter: ChooseCurrencyPresenterProtocol?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectCurrency(at: indexPath.row)
    }
}
