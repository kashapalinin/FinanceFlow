//
//  TransactionsCategoryViewController.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.01.2026.
//
import Domain
import UIKit

class TransactionsCategoryViewController: UIViewController {
    private let transactionsCategoryView = TransactionsCategoryView()
    var presenter: TransactionsCategoryPresenterProtocol?
    var category: TransactionCategory!
    var interval: DateInterval = DateInterval()
    
    private lazy var delegate: TransactionTableViewDelegate = {
        let delegate = TransactionTableViewDelegate(dataSource: dataSource)
        delegate.onCellTapped = { [ weak self] id in
            self?.presenter?.showTransactionScreen(transactionId: id)
        }
        return delegate
    }()
    
    private lazy var dataSource: TransactionTableViewDataSource = {
        TransactionTableViewDataSource(category: category)
    }()
    
    override func loadView() {
        view = transactionsCategoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        transactionsCategoryView.delegate = self
        transactionsCategoryView.tableView.delegate = delegate
        transactionsCategoryView.tableView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTableView()
    }
    
    func configure(with categoryId: UUID, interval: DateInterval) {
        category = presenter?.getCategory(by: categoryId)
        self.interval = interval
    }
    
    func updateTableView() {
        let transations = presenter?.getTransactions(categoryId: category.id, interval: interval) ?? []
        dataSource.transactions = presenter?.groupTransactionsByDate(transations) ?? []
        transactionsCategoryView.tableView.reloadData()
    }
}

extension TransactionsCategoryViewController: TransactionsCategoryViewDelegate {
    func didBackButtonTapped() {
        presenter?.backButtonTapped()
    }
}
