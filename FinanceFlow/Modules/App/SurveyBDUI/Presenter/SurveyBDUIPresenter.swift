//
//  SurveyBDUIPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
import ServicesAPI
import Domain

protocol SurveyBDUIPresenterProtocol {
    func sendResult(_ result: SurveyResult)
}

final class SurveyBDUIPresenter: SurveyBDUIPresenterProtocol {
    private let surveyService: ISurveyBDUIService
    private let settingsService: ISettingsService
    
    init(
        surveyService: ISurveyBDUIService,
        settingsService: ISettingsService
    ) {
        self.surveyService = surveyService
        self.settingsService = settingsService
    }
    
    func sendResult(_ result: SurveyResult) {
        Task {
            try await surveyService.send(result: result)
        }
        markAsCompleted()
    }
    
    func markAsCompleted() {
        settingsService.markSurveyAsCompleted()
    }
}
