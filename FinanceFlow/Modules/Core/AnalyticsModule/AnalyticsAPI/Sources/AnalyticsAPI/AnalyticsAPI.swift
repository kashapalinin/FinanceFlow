// The Swift Programming Language
// https://docs.swift.org/swift-book

public protocol IAppAnalytics {
    func trackAppLaunch()
    func trackSurveyShown(id: String)
    func trackSurveyRated(id: String, rating: Int)
    func trackSurveyCommentEntered(id: String)
    func trackSurveySubmitted(id: String)
}

public protocol IAnalyticsProvider {
    func log(event: String, parameters: [String: Any]?)
}
