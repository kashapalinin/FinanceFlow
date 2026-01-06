//
//  TransactionViewController.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.01.2026.
//

import UIKit
import Domain

protocol TransactionViewProtocol: AnyObject {
    func configure(with state: TransactionViewState)
}

class TransactionViewController: UIViewController, TransactionViewProtocol {
    private let transactionView = TransactionView()
    var presenter: TransactionPresenterProtocol?
    var transactionId: UUID?
    
    override func loadView() {
        view = transactionView
    }
    
    override func viewDidLoad() {
        transactionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.configureViewWithTransaction(by: transactionId!)
    }

    func configure(with state: TransactionViewState) {
        transactionView.configure(with: state)
    }
    
    func configureInitial(with transactionId: UUID) {
        self.transactionId = transactionId
    }
}

extension TransactionViewController: TransactionViewDelegate {
    func didBackButtonTapped() {
        presenter?.didBackButtonTapped()
    }
    
    func didDeleteButtonTapped() {
        guard let id = transactionId else { return }
        presenter?.didDeleteButtonTapped(id: id)
    }
}
