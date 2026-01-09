//
//  ChooseCurrencyView.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.12.2025.
//

import UIKit
import SnapKit

class ChooseCurrencyView: UIView {
    private enum Constants {
        static let titleText = "Выберите валюту по умолчанию"
        static let searchPlaceholder = "Искать валюту..."
        static let nextButtonTitle = "Далее"
        static let rowHeight: CGFloat = 60
        static let searchBarHeight: CGFloat = 44
        static let floatingButtonHeight: CGFloat = 56
        static let floatingButtonWidth: CGFloat = 200
        static let horizontalPadding: CGFloat = 16
        static let verticalSpacing: CGFloat = 16
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = .systemFont(ofSize: FontConstants.title.rawValue, weight: .bold)
        label.textColor = .primaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        return view
    }()
    
    private(set) lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.searchPlaceholder
        textField.font = .systemFont(ofSize: FontConstants.default.rawValue)
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.autocorrectionType = .no
        return textField
    }()
    
    private(set) lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "magnifyingglass")
        button.setImage(image, for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.reuseIdentifier)
        tableView.rowHeight = Constants.rowHeight
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private(set) lazy var nextButton: UIButton = {
        let button = ButtonFactory.createPrimaryButton(title: Constants.nextButtonTitle)
        button.layer.cornerRadius = Constants.floatingButtonHeight / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.15
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
        setupKeyboardDismissal()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(searchContainer)
        addSubview(tableView)
        addSubview(nextButton)
        
        searchContainer.addSubview(searchTextField)
        searchContainer.addSubview(searchButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(Constants.verticalSpacing * 2)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalPadding)
        }
        
        searchContainer.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.verticalSpacing * 1.5)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalPadding)
            make.height.equalTo(Constants.searchBarHeight)
        }
        
        searchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Padding.medium.rawValue)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Padding.default.rawValue)
            make.trailing.equalTo(searchButton.snp.leading).offset(-Padding.small.rawValue)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchContainer.snp.bottom).offset(Constants.verticalSpacing)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-Constants.verticalSpacing * 2)
            make.width.equalTo(Constants.floatingButtonWidth)
            make.height.equalTo(Constants.floatingButtonHeight)
        }
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
    func updateNextButton(enabled: Bool) {
        nextButton.isEnabled = enabled
        nextButton.alpha = enabled ? 1.0 : 0.5
    }
    
    func scrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }
}
