//
//  SurveyBDUICoordinator.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
import UIKit
import Swinject
import ServicesAPI

protocol SurveyBDUICoordinatorProtocol: Coordinator {
}

final class SurveyBDUICoordinator: SurveyBDUICoordinatorProtocol {
    var navigationController: UINavigationController
    var flowCompletionHandler: CoordinatorHandler?
    private let resolver: Resolver
    private let surveyService: ISurveyBDUIService
    private let settingsService: ISettingsService
    
    init(navigationController: UINavigationController, resolver: Resolver) {
        self.navigationController = navigationController
        self.resolver = resolver
        surveyService = resolver.resolve(ISurveyBDUIService.self)!
        settingsService = resolver.resolve(ISettingsService.self)!
    }
    
    func start() {
        if settingsService.hasAppAlreadyBeenOpened() && !settingsService.isSurveyCompleted() {
            showSurvey()
        }
    }
    
    private func showSurvey() {
        Task { @MainActor in
            let assembly = resolver.resolve(SurveyBDUIAssembly.self)!
            let dto = try await surveyService.fetchSurvey()
            let vc = assembly.assemble(dto: dto, resolver: resolver)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .pageSheet
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
            }
            navigationController.present(nav, animated: true)
        }
    }
}
