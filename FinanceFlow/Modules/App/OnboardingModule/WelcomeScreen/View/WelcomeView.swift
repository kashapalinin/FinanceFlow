//
//  OnboardingView.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 03.12.2025.
//
import SnapKit
import UIKit

class WelcomeView: UIView {
    private enum Constants {
        static let nextButtonTitle = "Далее"
        static let titleText = "Добро пожаловать в Finance Flow!"
        static let subtitleText = "Finance Flow - приложение для простого управления доходами и расходами"
        static let coinSize: CGFloat = 150
        static let buttonWidth: CGFloat = 200
        static let buttonHeight: CGFloat = 50
        static let horizontalPadding: CGFloat = 40
        static let verticalSpacing: CGFloat = 32
    }
    
    private var coinImage: UIImageView = {
        let imageView = UIImageView(image: .coin)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = .systemFont(ofSize: FontConstants.title.rawValue, weight: .heavy)
        label.textColor = .primary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.subtitleText
        label.font = .systemFont(ofSize: FontConstants.default.rawValue)
        label.textColor = .primaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private(set) var nextButton: UIButton = {
        let button = ButtonFactory.createPrimaryButton(title: Constants.nextButtonTitle)
        button.layer.cornerRadius = Constants.buttonHeight / 2
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let containerView = UIView()
        addSubview(containerView)
        
        // Добавляем элементы в контейнер
        containerView.addSubview(coinImage)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(nextButton)
        
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.leading.trailing.equalToSuperview()
        }
        
        // Картинка - сверху контейнера
        coinImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constants.coinSize)
        }
        
        // Заголовок - под картинкой с большим отступом
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coinImage.snp.bottom).offset(Constants.verticalSpacing * 1.5)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalPadding)
        }
        
        // Подзаголовок - под заголовком с отступом
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.verticalSpacing)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalPadding)
        }
        
        // Кнопка - под подзаголовком с большим отступом и фиксированной шириной
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(Constants.verticalSpacing * 1.5)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.buttonWidth)
            make.height.equalTo(Constants.buttonHeight)
            make.bottom.equalToSuperview()
        }
    }
}
