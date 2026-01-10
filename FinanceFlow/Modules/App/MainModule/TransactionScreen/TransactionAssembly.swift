//
//  TransactionAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.01.2026.
//
import UIKit
import Swinject
import ServicesAPI
import CrashlyticsAPI

final class TransactionAssembly {
    func assemble(
        transactionId: UUID,
        coordinator: MainModuleCoordinatorProtocol,
        resolver: Resolver
    ) -> UIViewController {
        let vc = TransactionViewController()
        let presenter = TransactionPresenter(
            financeService: resolver.resolve(IFinanceService.self)!,
            settingsService: resolver.resolve(ISettingsService.self)!,
            crashlytics: resolver.resolve(IAppCrashlytics.self)!
        )
        vc.presenter = presenter
        presenter.coordinator = coordinator
        presenter.view = vc
        vc.configureInitial(with: transactionId)
        return vc
    }
}
