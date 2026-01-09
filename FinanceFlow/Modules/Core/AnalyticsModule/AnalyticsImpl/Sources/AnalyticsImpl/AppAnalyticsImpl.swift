//
//  AppAnalyticsImpl.swift
//  AnalyticsImpl
//
//  Created by Павел Калинин on 09.01.2026.
//
import AnalyticsAPI

public final class AppAnalytics: IAppAnalytics {

    private let provider: IAnalyticsProvider

    public init(provider: IAnalyticsProvider) {
        self.provider = provider
    }

    public func trackAppLaunch() {
        provider.log(event: "app_launch", parameters: nil)
    }

    public func trackSurveyShown(id: String) {
        provider.log(event: "survey_shown", parameters: [
            "survey_id": id
        ])
    }

    public func trackSurveyRated(id: String, rating: Int) {
        provider.log(event: "survey_rated", parameters: [
            "survey_id": id,
            "rating": rating
        ])
    }

    public func trackSurveyCommentEntered(id: String) {
        provider.log(event: "survey_comment_entered", parameters: [
            "survey_id": id
        ])
    }

    public func trackSurveySubmitted(id: String) {
        provider.log(event: "survey_submitted", parameters: [
            "survey_id": id
        ])
    }
}
