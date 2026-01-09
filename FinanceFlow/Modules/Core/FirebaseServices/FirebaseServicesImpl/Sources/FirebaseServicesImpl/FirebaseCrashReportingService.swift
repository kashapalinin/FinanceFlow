//
//  FirebaseCrashReportingServiceImpl.swift
//  FirebaseServicesImpl
//
//  Created by Павел Калинин on 09.01.2026.
//


import FirebaseCrashlytics
import FirebaseServicesAPI

public final class FirebaseCrashReportingService: IFirebaseCrashlyticsService {
    public init() {}

    public func record(error: Error, info: [String : Any]?) {
        let crashlytics = Crashlytics.crashlytics()
        crashlytics.record(error: error)

        info?.forEach {
            crashlytics.setCustomValue($0.value, forKey: $0.key)
        }
    }
}
