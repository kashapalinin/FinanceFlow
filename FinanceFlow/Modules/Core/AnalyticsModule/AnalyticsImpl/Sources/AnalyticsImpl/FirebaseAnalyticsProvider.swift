//
//  FirebaseAnalyticsProvider.swift
//  AnalyticsImpl
//
//  Created by Павел Калинин on 09.01.2026.
//
import FirebaseServicesAPI
import AnalyticsAPI

public final class FirebaseAnalyticsProvider: IAnalyticsProvider {
    private var analytics: IFirebaseAnalyticsService
    public init(analytics: IFirebaseAnalyticsService) {
        self.analytics = analytics
    }

    public func log(event: String, parameters: [String : Any]?) {
        analytics.log(event: event, parameters: parameters)
    }
}
