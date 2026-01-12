//
//  TransactionsDataSource.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 01.01.2026.
//
import UIKit
import Domain

final class TransactionsDataSource: NSObject, UICollectionViewDataSource {
    private var transactions: [TransactionsByCategory] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpenseCell.reuseIdentifier, for: indexPath) as? ExpenseCell else {
            return UICollectionViewCell()
        }
        let expense = transactions[indexPath.row]
        cell.configure(with: expense)
        cell.amountLabel.textColor = expense.category.type == .INCOME ? .primary : .red
        return cell
    }
    
    func setExpenses(expenses: [TransactionsByCategory]) {
        transactions = expenses
    }
    
    func getTransaction(at index: Int) -> TransactionsByCategory {
        transactions[index]
    }
}
