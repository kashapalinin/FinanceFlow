//
//  ChooseCurrencyPresenter.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.12.2025.
//
import CurrencyFormatter
import ServicesAPI
import Foundation

protocol ChooseCurrencyViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showCurrencies(_ currencies: [Currency])
    func updateSelectedCurrency(_ currency: Currency)
    func showError(_ error: Error, fallbackToRuble: Bool)
}

protocol ChooseCurrencyPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectCurrency(at index: Int)
    func didSelectCurrency(_ currency: Currency)
    func searchCurrency(with text: String)
    func clearSearch()
    func nextButtonTapped()
    func isCurrencySelected(_ currencyId: String) -> Bool
    func hasSelectedCurrency() -> Bool
    func selectRubleAsFallback()
}

final class ChooseCurrencyPresenter: ChooseCurrencyPresenterProtocol {
    weak var view: ChooseCurrencyViewProtocol?
    weak var coordinator: OnboardingCoordinatorProtocol?
    private var allCurrencies: [Currency] = []
    private var filteredCurrencies: [Currency] = []
    private var selectedCurrency: Currency?
    private var currencyFormatter: CBCurrencyFormatter
    private var isSearching = false
    private let service: IOnboardingService
    
    init(
        currencyFormatter: CBCurrencyFormatter = CBCurrencyFormatter(),
        service: IOnboardingService
    ) {
        self.currencyFormatter = currencyFormatter
        self.service = service
    }
    
    func viewDidLoad() {
        view?.showLoading()
        fetchCurrencies()
    }
    
    func didSelectCurrency(at index: Int) {
        let currenciesToUse = filteredCurrencies.isEmpty ? allCurrencies : filteredCurrencies
        
        guard index < currenciesToUse.count else { return }
        selectedCurrency = currenciesToUse[index]
        view?.updateSelectedCurrency(currenciesToUse[index])
    }
    
    func isCurrencySelected(_ currencyId: String) -> Bool {
        return selectedCurrency?.id == currencyId
    }
    
    func hasSelectedCurrency() -> Bool {
        return selectedCurrency != nil
    }
    
    func selectRubleAsFallback() {
        let selectedCurrency = Currency.createRuble()
        self.selectedCurrency = selectedCurrency
        view?.updateSelectedCurrency(selectedCurrency)
    }
    
    private func fetchCurrencies() {
        Task { @MainActor in
            view?.showLoading()
            
            do {
                let response = try await currencyFormatter.fetchCurrencies()
                handleSuccessResponse(response)
            } catch {
                handleFailure(error)
            }
            
            view?.hideLoading()
        }
    }
    
    private func handleSuccessResponse(_ response: CurrencyResponse) {
        // Добавляем рубль в начало списка
        var currencies = response.currencies
        let ruble = Currency.createRuble()
        currencies.insert(ruble, at: 0)
        
        allCurrencies = currencies
        filteredCurrencies = currencies
        
        view?.showCurrencies(currencies)
    }
    
    private func handleFailure(_ error: Error) {
        // При ошибке сети автоматически выбираем рубль
        let ruble = Currency.createRuble()
        allCurrencies = [ruble]
        filteredCurrencies = [ruble]
        
        view?.showCurrencies([ruble])
        view?.updateSelectedCurrency(ruble)
        view?.showError(error, fallbackToRuble: true)
    }
    
    func didSelectCurrency(_ currency: Currency) {
        selectedCurrency = currency
        view?.updateSelectedCurrency(currency)
    }
    
    func searchCurrency(with text: String) {
        guard !text.isEmpty else {
            clearSearch()
            return
        }
        
        isSearching = true
        let searchText = text.lowercased()
        
        filteredCurrencies = allCurrencies.filter { currency in
            currency.name.lowercased().contains(searchText) ||
            currency.charCode.lowercased().contains(searchText)
        }
        
        view?.showCurrencies(filteredCurrencies)
    }
    
    func clearSearch() {
        isSearching = false
        filteredCurrencies = allCurrencies
        view?.showCurrencies(allCurrencies)
    }
    
    func nextButtonTapped() {
        guard let selectedCurrency = selectedCurrency else { return }
        
        saveSelectedCurrency(selectedCurrency)
        
        coordinator?.showAccountAmountScreen()
    }
    
    private func saveSelectedCurrency(_ currency: Currency) {
        service.setCurrency(currency)
    }
}
