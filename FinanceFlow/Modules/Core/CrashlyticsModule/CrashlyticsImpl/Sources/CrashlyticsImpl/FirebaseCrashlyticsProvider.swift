//
//  FirebaseAnalyticsProvider.swift
//  CrashlyticsImpl
//
//  Created by Павел Калинин on 09.01.2026.
//
import FirebaseServicesAPI
import CrashlyticsAPI

public final class FirebaseCrashlyticsProvider: ICrashlyticsProvider {
    private var crashlytics: IFirebaseCrashlyticsService
    public init(crashlytics: IFirebaseCrashlyticsService) {
        self.crashlytics = crashlytics
    }

    public func record(error: any Error, info: [String : Any]?) {
        crashlytics.record(error: error, info: info)
    }
}
