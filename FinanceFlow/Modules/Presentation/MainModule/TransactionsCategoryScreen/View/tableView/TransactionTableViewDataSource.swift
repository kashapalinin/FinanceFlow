//
//  TransactionTableViewDataSource.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.01.2026.
//
import UIKit
import Domain

final class TransactionTableViewDataSource: NSObject, UITableViewDataSource {
    
    var transactions: [(date: String, items: [Transaction])] = []
    var category: TransactionCategory
    
    init(category: TransactionCategory) {
        self.category = category
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier, for: indexPath) as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        
        let transaction = transactions[indexPath.section].items[indexPath.row]
        cell.configure(with: transaction, category: category)
        
        let isLastRow = indexPath.row == transactions[indexPath.section].items.count - 1
        cell.separatorInset = isLastRow
            ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            : UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return transactions[section].date
    }
}
