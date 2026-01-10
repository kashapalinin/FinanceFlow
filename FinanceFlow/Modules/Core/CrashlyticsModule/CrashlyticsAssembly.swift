//
//  CrashlyticsAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
import Swinject
import CrashlyticsAPI
import CrashlyticsImpl
import FirebaseServicesAPI

public final class CrashlyticsAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {

        container.register(IAppCrashlytics.self) { resolver in
            AppCrashlytics(provider: resolver.resolve(ICrashlyticsProvider.self)!)
        }.inObjectScope(.container)

        container.register(ICrashlyticsProvider.self) { resolver in
            FirebaseCrashlyticsProvider(crashlytics: resolver.resolve(IFirebaseCrashlyticsService.self)!)
        }.inObjectScope(.container)
    }
}
