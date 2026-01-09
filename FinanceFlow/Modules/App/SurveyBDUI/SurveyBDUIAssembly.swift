//
//  SurveyBDUIAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
import Swinject
import UIKit
import Domain
import ServicesAPI

final class SurveyBDUIAssembly {
    func assemble(dto: SurveyPageDTO, resolver: Resolver) -> UIViewController {
        let vc = SurveyViewController(dto: dto)
        let presenter = SurveyBDUIPresenter(
            surveyService: resolver.resolve(ISurveyBDUIService.self)!,
            settingsService: resolver.resolve(ISettingsService.self)!
        )
        vc.presenter = presenter
        return vc
    }
}

