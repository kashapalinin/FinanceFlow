// The Swift Programming Language
// https://docs.swift.org/swift-book

public protocol IFirebaseAnalyticsService {
    func log(event: String, parameters: [String: Any]?)
}

public protocol IFirebaseCrashlyticsService {
    func record(error: Error, info: [String: Any]?)
}

public protocol IFirestoreService {
    func getDocument(path: String) async throws -> [String: Any]
    func setDocument(path: String, data: [String: Any]) async throws
    func addDocument(collection: String, data: [String: Any]) async throws
}
