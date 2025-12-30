//
//  LoadingAppPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.11.2025.
//
import UIKit

protocol LoadingAppPresenterProtocol {
    func goToMainPart()
}

final class LoadingAppPresenter: LoadingAppPresenterProtocol {
    weak var coordinator: Coordinator?
    weak var view: UIViewController?
    
    func goToMainPart() {
        coordinator?.flowCompletionHandler?()
    }
}
