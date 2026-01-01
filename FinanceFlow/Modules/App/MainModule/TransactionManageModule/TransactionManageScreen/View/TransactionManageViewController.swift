//
//  TransactionManageViewController.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//

import UIKit

class TransactionManageViewController: UIViewController {
    var presenter: TransactionManagePresenterProtocol?
    private let transactionManageView = TransactionManageView()
    
    override func loadView() {
        view = transactionManageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        transactionManageView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        presenter?.backButtonTapped()
    }
}
