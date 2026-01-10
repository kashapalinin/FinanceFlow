// The Swift Programming Language
// https://docs.swift.org/swift-book

public protocol IAppCrashlytics {
    func recordNonFatal(_ error: Error, info: [String: Any]?)
}

public protocol ICrashlyticsProvider {
    func record(error: Error, info: [String: Any]?)
}
