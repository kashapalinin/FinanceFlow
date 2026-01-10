//
//  MockCrashlytics.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
import CrashlyticsAPI

public class MockCrashlytics: IAppCrashlytics {
    var recordNonFatalCalled = false
    var lastRecordedError: Error?
    var lastInfo: [String: Any]?
    
    public func recordNonFatal(_ error: Error, info: [String: Any]?) {
        recordNonFatalCalled = true
        lastRecordedError = error
        lastInfo = info
    }
}
