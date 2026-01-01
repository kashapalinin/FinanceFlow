//
//  TransactionManagePresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//
import UIKit

protocol TransactionManagePresenterProtocol {
    func backButtonTapped()
}

final class TransactionManagePresenter: TransactionManagePresenterProtocol {
    weak var view: UIViewController?
    
    func backButtonTapped() {
        view?.navigationController?.popViewController(animated: true)
    }
}
