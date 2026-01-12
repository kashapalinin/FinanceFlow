//
//  OnboardingAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
import Swinject
import UIKit

final class SurveyBDUIModuleAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SurveyBDUICoordinatorProtocol.self) { (resolver: Resolver, nc: UINavigationController) in
            SurveyBDUICoordinator(navigationController: nc, resolver: resolver)
        }.inObjectScope(.transient)
        
        container.register(SurveyBDUIAssembly.self) { _ in
            SurveyBDUIAssembly()
        }
    }
}
