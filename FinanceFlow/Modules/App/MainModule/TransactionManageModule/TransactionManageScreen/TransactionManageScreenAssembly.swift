//
//  TransactionManageScreenAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//
import UIKit

final class TransactionManageScreenAssembly {
    func assemble() -> UIViewController {
        let vc = TransactionManageViewController()
        let presenter = TransactionManagePresenter()
        vc.presenter = presenter
        presenter.view = vc 
        return vc
    }
}
