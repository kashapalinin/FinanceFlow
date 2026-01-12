//
//  TransactionManageView.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 30.12.2025.
//

import UIKit
import SnapKit

protocol TransactionManageDelegate: AnyObject {
    func didTapIncome()
    func didTapExpense()
    func didAddButtonTapped()
    func didBackButtonTapped()
}

class TransactionManageView: UIView {
    private enum Constants {
        static let floatingButtonHeight: CGFloat = 56
        static let floatingButtonWidth: CGFloat = 200
        static let horizontalPadding: CGFloat = 16
        static let verticalSpacing: CGFloat = 16
    }
    
    private lazy var customNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        view.clipsToBounds = false 
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()

    private lazy var navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Операции"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var expensesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Расходы", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    private lazy var incomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Доходы", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    private lazy var tabStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        return stack
    }()

    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var amountStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .lastBaseline
        stack.distribution = .fill
        return stack
    }()
    
    private(set) lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.font = UIFont.systemFont(ofSize: 40)
        textField.textColor = .label
        textField.keyboardType = .decimalPad
        textField.textAlignment = .right
        textField.borderStyle = .none
        textField.adjustsFontSizeToFitWidth = true
        textField.contentScaleFactor = 0.5
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        textField.accessibilityIdentifier = "amountTextField"
        return textField
    }()
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "USD"
        label.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var underlineTextView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.8)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.keyboardDismissMode = .interactive
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Категории"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        return collectionView
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "Комментарий"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private(set) lazy var commentTextField = CommentTextField(maxLength: 4096, placeholder: "Комментарий")
    
    private(set) lazy var addButton: UIButton = {
        let button = ButtonFactory.createPrimaryButton(title: "Добавить")
        button.layer.cornerRadius = 56 / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.15
        return button
    }()
    
    private(set) lazy var datePicker: DateRangePickerView = {
        DateRangePickerView()
    }()

    var isIncomeSelected = false
    weak var delegate: TransactionManageDelegate?

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
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        amountStackView.addArrangedSubview(amountTextField)
        amountStackView.addArrangedSubview(currencyLabel)
        
        mainContainerView.addSubview(amountStackView)
        mainContainerView.addSubview(underlineTextView)
        
        contentView.addSubview(mainContainerView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(datePicker)
        contentView.addSubview(commentLabel)
        contentView.addSubview(commentTextField)
        
        addSubview(addButton)
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
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        mainContainerView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        amountStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        
        underlineTextView.snp.makeConstraints { make in
            make.top.equalTo(amountStackView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(amountStackView)
            make.height.equalTo(3)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(mainContainerView.snp.bottom).offset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        datePicker.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.trailing.leading.equalToSuperview().inset(16)
            make.top.equalTo(collectionView.snp.bottom).offset(16)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(datePicker.snp.bottom).offset(16)
        }
        
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(100)
            make.bottom.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-Constants.verticalSpacing )
            make.width.equalTo(Constants.floatingButtonWidth)
            make.height.equalTo(Constants.floatingButtonHeight)
        }
    }

    private func setupActions() {
        expensesButton.addTarget(self, action: #selector(expensesButtonTapped), for: .touchUpInside)
        incomeButton.addTarget(self, action: #selector(incomeButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    @objc private func expensesButtonTapped() {
        setSelectedTab(false)
        delegate?.didTapExpense()
    }

    @objc private func incomeButtonTapped() {
        setSelectedTab(true)
        delegate?.didTapIncome()
    }
    
    @objc private func addButtonTapped() {
        delegate?.didAddButtonTapped()
    }
    
    @objc private func backButtonTapped() {
        delegate?.didBackButtonTapped()
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
    
    func showActiveState() {
        UIView.animate(withDuration: 0.3) {
            self.underlineTextView.backgroundColor = .primary
            self.underlineTextView.transform = CGAffineTransform(scaleX: 1.02, y: 1.0)
        }
    }
    
    func showInactiveState() {
        UIView.animate(withDuration: 0.3) {
            self.underlineTextView.backgroundColor = .lightGray.withAlphaComponent(0.8)
            self.underlineTextView.transform = .identity
        }
    }
    
    func updateAddButton(enabled: Bool) {
        addButton.isEnabled = enabled
        addButton.alpha = enabled ? 1.0 : 0.5
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
    
    func configure(with currencyCode: String) {
        currencyLabel.text = currencyCode
    }
}
