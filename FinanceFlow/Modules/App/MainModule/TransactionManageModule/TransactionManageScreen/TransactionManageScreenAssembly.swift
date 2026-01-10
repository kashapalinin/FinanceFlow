//
//  TransactionManageScreenAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//
import UIKit
import Swinject
import ServicesAPI
import CrashlyticsAPI

final class TransactionManageScreenAssembly {
    func assemble(coordinator: TransactionManageModuleCoordinatorProtocol, resolver: Resolver) -> UIViewController {
        let vc = TransactionManageViewController()
        let presenter = TransactionManagePresenter(
            settingsService: resolver.resolve(ISettingsService.self)!,
            financeService: resolver.resolve(IFinanceService.self)!,
            crashlytics: resolver.resolve(IAppCrashlytics.self)!
        )
        vc.presenter = presenter
        presenter.coordinator = coordinator
        return vc
    }
}
