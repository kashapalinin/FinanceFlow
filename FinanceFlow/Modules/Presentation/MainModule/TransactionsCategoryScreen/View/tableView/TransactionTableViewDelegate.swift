//
//  TransactionTableViewDelegate.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.01.2026.
//
import UIKit
import Domain

final class TransactionTableViewDelegate: NSObject, UITableViewDelegate {
    weak var dataSource: TransactionTableViewDataSource?
    var onCellTapped: ((UUID) -> Void)?
    
    init(dataSource: TransactionTableViewDataSource) {
        self.dataSource = dataSource
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        header.textLabel?.textColor = .secondaryLabel
        header.contentView.backgroundColor = .background
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }
        onCellTapped?(dataSource.transactions[indexPath.section].items[indexPath.row].id)
    }
}
