//
//  MockTransactionManageCoordinator.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
@testable import FinanceFlow
import UIKit

public class MockTransactionManageCoordinator: TransactionManageModuleCoordinatorProtocol {
    public var navigationController: UINavigationController
    public var flowCompletionHandler: (() -> Void)?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        
    }
    
    public func showTransactionManageScreen() {
        
    }
}
