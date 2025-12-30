//
//  Coordinator.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.11.2025.
//
import UIKit

typealias CoordinatorHandler = () -> Void

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController {get set}
    var flowCompletionHandler: CoordinatorHandler? {get set}

    func start()
}

