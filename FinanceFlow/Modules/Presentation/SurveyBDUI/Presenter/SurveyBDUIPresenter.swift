//
//  SurveyBDUIPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
import ServicesAPI
import AnalyticsAPI
import CrashlyticsAPI
import Domain

protocol SurveyBDUIPresenterProtocol {
    func sendResult(_ result: SurveyResult)
    func logSurveyShown(id: String)
}

final class SurveyBDUIPresenter: SurveyBDUIPresenterProtocol {
    private let surveyService: ISurveyBDUIService
    private let settingsService: ISettingsService
    private let analytics: IAppAnalytics
    private let crashlytics: IAppCrashlytics
    
    init(
        surveyService: ISurveyBDUIService,
        settingsService: ISettingsService,
        analytics: IAppAnalytics,
        crashlytics: IAppCrashlytics
    ) {
        self.surveyService = surveyService
        self.settingsService = settingsService
        self.analytics = analytics
        self.crashlytics = crashlytics
    }
    
    func sendResult(_ result: SurveyResult) {
        Task {
            do {
                try await surveyService.send(result: result)
            } catch {
                crashlytics.recordNonFatal(error, info: [:])
            }
        }
        markAsCompleted()
        analytics.trackSurveySubmitted(id: result.deviceId)
        analytics.trackSurveyRated(id: result.deviceId, rating: result.rating)
    }
    
    func logSurveyShown(id: String) {
        analytics.trackSurveyShown(id: id)
    }
    
    func markAsCompleted() {
        settingsService.markSurveyAsCompleted()
    }
}
