//
//  LoadingAppViewController.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 29.11.2025.
//

import UIKit
import SnapKit
import Lottie

class LoadingAppViewController: UIViewController {
    var presenter: LoadingAppPresenterProtocol?
    
    lazy var animationCoinView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.animation = LottieAnimation.named("coinAnimation")
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary
        setupLayout()
        animateCoin()
    }
    
    private func setupLayout() {
        view.addSubview(animationCoinView)
        
        animationCoinView.snp.makeConstraints { make in
            make.width.equalTo(205)
            make.height.equalTo(205)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func animateCoin() {
        animationCoinView.play { [weak self] _ in
            self?.transitionToMainApp()
        }
    }
    
    private func transitionToMainApp() {
        presenter?.goToMainPart()
    }
}

