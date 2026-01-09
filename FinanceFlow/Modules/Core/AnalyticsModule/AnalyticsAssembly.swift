//
//  AnalyticsAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
import Swinject
import AnalyticsAPI
import AnalyticsImpl
import FirebaseServicesAPI

public final class AnalyticsAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {

        container.register(IAppAnalytics.self) { resolver in
            AppAnalytics(provider: resolver.resolve(IAnalyticsProvider.self)!)
        }.inObjectScope(.container)

        container.register(IAnalyticsProvider.self) { resolver in
            FirebaseAnalyticsProvider(analytics: resolver.resolve(IFirebaseAnalyticsService.self)!)
        }.inObjectScope(.container)
    }
}
