//
//  FirebaseAnalyticsServiceImpl.swift
//  FirebaseServicesImpl
//
//  Created by Павел Калинин on 09.01.2026.
//
import FirebaseAnalytics
import FirebaseServicesAPI

public final class FirebaseAnalyticsService: IFirebaseAnalyticsService {
    public init() {
        Analytics.setAnalyticsCollectionEnabled(true)
    }
    
    public func log(event: String, parameters: [String : Any]?) {
        Analytics.logEvent(event, parameters: parameters)
    }
}
