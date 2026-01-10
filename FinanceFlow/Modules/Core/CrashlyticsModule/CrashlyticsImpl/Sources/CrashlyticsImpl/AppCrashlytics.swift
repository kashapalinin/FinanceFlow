//
//  AppCrashlytics.swift
//  CrashlyticsImpl
//
//  Created by Павел Калинин on 09.01.2026.
//
import CrashlyticsAPI

public final class AppCrashlytics: IAppCrashlytics {
    private let provider: ICrashlyticsProvider
    
    public init(provider: ICrashlyticsProvider) {
        self.provider = provider
    }
    
    public func recordNonFatal(_ error: any Error, info: [String : Any]?) {
        provider.record(error: error, info: info)
    }
}
