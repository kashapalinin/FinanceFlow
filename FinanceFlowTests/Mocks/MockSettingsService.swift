//
//  MockSettingsService.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 09.01.2026.
//
import ServicesAPI
import CurrencyFormatter

public class MockSettingsService: ISettingsService {
    var getCurrencyCodeCalled = false
    var currencyCodeToReturn = ""
    
    public func getCurrencyCode() -> String {
        getCurrencyCodeCalled = true
        return currencyCodeToReturn
    }
    
    public func setCurrency(_ currency: Currency) {
        
    }
    
    public func getDefaultCurrency() -> Currency? {
        nil
    }
    
    public func getCurrencySymbol() -> String {
        ""
    }
    
    public func hasAppAlreadyBeenOpened() -> Bool {
        false
    }
    
    public func isSurveyCompleted() -> Bool {
        false
    }
    
    public func markSurveyAsCompleted() {
        
    }
}
