//
//  StorageAssembly.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 27.12.2025.
//
import Swinject
import StorageAPI
import StorageImpl

final class StorageAssembly: Assembly {
    func assemble(container: Container) {
        container.register(IUserDefaultsStorage.self) { _ in
            UserDefaultsStorage() 
        }
    }
}
