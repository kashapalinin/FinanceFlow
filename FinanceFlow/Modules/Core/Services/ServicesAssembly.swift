//
//  ServicesAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 27.12.2025.
//
import Swinject
import ServicesAPI
import ServicesImpl
import StorageAPI
import FirebaseServicesAPI

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ISettingsService.self) { resolver in
            SettingsService(
                userDefaultsStorage: resolver.resolve(IUserDefaultsStorage.self)!
            )
        }
        
        container.register(IFinanceService.self) { resolver in
            FinanceService(coreDataManager: resolver.resolve(ICoreDataManager.self)!)
        }
        
        container.register(ISurveyBDUIService.self) { resolver in
            SurveyBDUIService(firestoreService: resolver.resolve(IFirestoreService.self)!)
        }
    }
}
