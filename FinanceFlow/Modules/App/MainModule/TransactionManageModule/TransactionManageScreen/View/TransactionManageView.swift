//
//  TransactionManageView.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//

import UIKit
import SnapKit

class TransactionManageView: UIView {

    // MARK: - Custom Navigation Bar
    private let customNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        view.clipsToBounds = false // важно: маска будет применена отдельно
        return view
    }()

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()

    let navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Операции"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    let expensesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Расходы", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    let incomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Доходы", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    let tabStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        return stack
    }()

    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    var isIncomeSelected = false

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupActions()
        setSelectedTab(false, animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .background

        addSubview(customNavBar)

        tabStack.addArrangedSubview(expensesButton)
        tabStack.addArrangedSubview(incomeButton)

        customNavBar.addSubview(backButton)
        customNavBar.addSubview(navTitleLabel)
        customNavBar.addSubview(tabStack)
        customNavBar.addSubview(underlineView)
    }

    private func setupConstraints() {
        customNavBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(calculateCustomNavBarTotalHeight())
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.width.height.equalTo(44)
        }

        navTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }

        tabStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(backButton.snp.bottom).offset(12)
            make.height.equalTo(32)
        }

        underlineView.snp.makeConstraints { make in
            make.top.equalTo(tabStack.snp.bottom).offset(4)
            make.leading.equalTo(expensesButton.snp.leading)
            make.trailing.equalTo(expensesButton.snp.trailing)
            make.height.equalTo(4)
            make.bottom.lessThanOrEqualTo(customNavBar.snp.bottom).offset(-8)
        }
    }

    private func setupActions() {
        expensesButton.addTarget(self, action: #selector(expensesButtonTapped), for: .touchUpInside)
        incomeButton.addTarget(self, action: #selector(incomeButtonTapped), for: .touchUpInside)
    }

    @objc private func expensesButtonTapped() {
        setSelectedTab(false)
    }

    @objc private func incomeButtonTapped() {
        setSelectedTab(true)
    }

    func setSelectedTab(_ isIncome: Bool, animated: Bool = true) {
        guard isIncome != isIncomeSelected else { return }
        isIncomeSelected = isIncome

        let selectedColor = UIColor.white
        let deselectedColor = UIColor.white.withAlphaComponent(0.6)

        if isIncome {
            incomeButton.setTitleColor(selectedColor, for: .normal)
            expensesButton.setTitleColor(deselectedColor, for: .normal)
        } else {
            expensesButton.setTitleColor(selectedColor, for: .normal)
            incomeButton.setTitleColor(deselectedColor, for: .normal)
        }

        underlineView.snp.remakeConstraints { make in
            make.top.equalTo(tabStack.snp.bottom).offset(4)
            make.height.equalTo(4)
            make.bottom.lessThanOrEqualTo(customNavBar.snp.bottom).offset(-8)
            if isIncome {
                make.leading.equalTo(incomeButton.snp.leading)
                make.trailing.equalTo(incomeButton.snp.trailing)
            } else {
                make.leading.equalTo(expensesButton.snp.leading)
                make.trailing.equalTo(expensesButton.snp.trailing)
            }
        }

        if animated {
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        }
    }

    private func calculateCustomNavBarTotalHeight() -> CGFloat {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return statusBarHeight + 100 
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyBottomRoundedCorners()
    }

    private func applyBottomRoundedCorners() {
        let radius: CGFloat = 20
        let path = UIBezierPath(
            roundedRect: customNavBar.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        customNavBar.layer.mask = maskLayer
    }
}
