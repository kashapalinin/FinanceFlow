//
//  TransactionPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.01.2026.
//
import ServicesAPI
import Foundation
import Domain

protocol TransactionPresenterProtocol {
    func didBackButtonTapped()
    func getTransaction(by id: UUID) -> Transaction
    func configureViewWithTransaction(by id: UUID)
    func didDeleteButtonTapped(id: UUID)
}

final class TransactionPresenter: TransactionPresenterProtocol {
    weak var coordinator: MainModuleCoordinatorProtocol?
    weak var view: TransactionViewProtocol?
    private var financeService: IFinanceService
    private var settingsService: ISettingsService
    
    init(financeService: IFinanceService,
         settingsService: ISettingsService) {
        self.financeService = financeService
        self.settingsService = settingsService
    }
    
    func didBackButtonTapped() {
        coordinator?.closeCurrentScreen()
    }
    
    func getTransaction(by id: UUID) -> Transaction {
        financeService.getTransaction(by: id)
    }
    
    func configureViewWithTransaction(by id: UUID) {
        let transaction = getTransaction(by: id)
        let category = financeService.getCategory(by: transaction.categoryId)
        view?.configure(
            with: TransactionViewState(
                amount: transaction.amount,
                currencySign: settingsService.getCurrencySymbol(),
                categoryName: category.name,
                categoryIcon: category.icon,
                categoryColor: category.color,
                date: transaction.date
            )
        )
    }
    
    func didDeleteButtonTapped(id: UUID) {
        financeService.deleteTransaction(by: id)
        coordinator?.closeCurrentScreen()
    }
}
