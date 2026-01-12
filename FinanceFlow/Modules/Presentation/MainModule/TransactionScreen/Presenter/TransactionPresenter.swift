//
//  TransactionPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.01.2026.
//
import ServicesAPI
import Foundation
import Domain
import CrashlyticsAPI

protocol TransactionPresenterProtocol {
    func didBackButtonTapped()
    func getTransaction(by id: UUID) throws -> Transaction?
    func configureViewWithTransaction(by id: UUID)
    func didDeleteButtonTapped(id: UUID)
}

final class TransactionPresenter: TransactionPresenterProtocol {
    weak var coordinator: MainModuleCoordinatorProtocol?
    weak var view: TransactionViewProtocol?
    private let financeService: IFinanceService
    private let settingsService: ISettingsService
    private let crashlytics: IAppCrashlytics
    
    init(financeService: IFinanceService,
         settingsService: ISettingsService,
         crashlytics: IAppCrashlytics) {
        self.financeService = financeService
        self.settingsService = settingsService
        self.crashlytics = crashlytics
    }
    
    func didBackButtonTapped() {
        coordinator?.closeCurrentScreen()
    }
    
    func getTransaction(by id: UUID) throws -> Transaction? {
        try financeService.getTransaction(by: id)
    }
    
    func configureViewWithTransaction(by id: UUID) {
        do {
            let transaction = try getTransaction(by: id)
            guard let transaction = transaction else { return }
            let category = try financeService.getCategory(by: transaction.categoryId)
            guard let category = category else { return }
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
        } catch {
            crashlytics.recordNonFatal(error, info: [
                "context": "configureViewWithTransaction"
            ])
        }
    }
    
    func didDeleteButtonTapped(id: UUID) {
        do {
            try financeService.deleteTransaction(by: id)
            coordinator?.closeCurrentScreen()
        } catch {
            crashlytics.recordNonFatal(error, info: [
                "context": "didDeleteButtonTapped"
            ])
        }
    }
}
