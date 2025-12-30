//
//  LoadingAppAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.11.2025.
//
import UIKit

final class LoadingAppAssembly {
    func assemble(coordinator: LoadingAppCoordinatorProtocol) -> UIViewController {
        let vc = LoadingAppViewController()
        let presenter = LoadingAppPresenter()
        vc.presenter = presenter
        presenter.view = vc
        presenter.coordinator = coordinator
        return vc
    }
}
