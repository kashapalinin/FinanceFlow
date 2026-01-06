//
//  TransactionsCategoryAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.01.2026.
//
import UIKit
import Swinject
import ServicesAPI

final class TransactionCategoryAssembly {
    func assemble(
        categoryId: UUID,
        interval: DateInterval,
        coordinator: MainModuleCoordinatorProtocol,
        resolver: Resolver
    ) -> UIViewController {
        let vc = TransactionsCategoryViewController()
        let presenter = TransactionsCategoryPresenter(financeService: resolver.resolve(IFinanceService.self)!)
        vc.presenter = presenter
        presenter.coordinator = coordinator
        vc.configure(with: categoryId, interval: interval)
        return vc
    }
}

