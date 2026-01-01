//
//  OnboardingService.swift
//  ServicesImpl
//
//  Created by Павел Калинин on 27.12.2025.
//
import ServicesAPI
import StorageAPI
import CurrencyFormatter

public final class SettingsService: ISettingsService {
    private let userDefaultsStorage: IUserDefaultsStorage
    
    public init(
        userDefaultsStorage: IUserDefaultsStorage
    ) {
        self.userDefaultsStorage = userDefaultsStorage
    }
    
    public func setCurrency(_ currency: Currency) {
        userDefaultsStorage.save(currency, forKey: "defaultCurrency")
    }
    
    public func getDefaultCurrency() -> Currency? {
        userDefaultsStorage.get(forKey: "defaultCurrency")
    }
    
    public func getCurrencySymbol() -> String {
        let currencyFormatter = CBCurrencyFormatter()
        let currency: Currency? = userDefaultsStorage.get(forKey: "defaultCurrency")
        let symbol = currencyFormatter.getCurrencySymbol(code: currency?.charCode ?? "")
        return symbol
    }
}
