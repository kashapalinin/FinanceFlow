//
//  OnboardingViewController.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 03.12.2025.
//

import UIKit

class WelcomeViewController: UIViewController {
    private let welcomeView = WelcomeView()
    var presenter: WelcomeScreenPresenterProtocol?
    
    override func loadView() {
        view = welcomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeView.nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
    }
    
    @objc private func goNext() {
        presenter?.showCurrencyScreen()
    }
}
