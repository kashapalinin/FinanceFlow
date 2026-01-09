//
//  FirebaseServicesAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
import Swinject
import FirebaseServicesAPI
import FirebaseServicesImpl

public final class FirebaseServicesAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        FirebaseBootstrap.configure()

        container.register(IFirebaseAnalyticsService.self) { _ in
            FirebaseAnalyticsService()
        }.inObjectScope(.container)

        container.register(IFirebaseCrashlyticsService.self) { _ in
            FirebaseCrashReportingService()
        }.inObjectScope(.container)

        container.register(IFirestoreService.self) { _ in
            FirebaseFirestoreService()
        }.inObjectScope(.container)
    }
}
