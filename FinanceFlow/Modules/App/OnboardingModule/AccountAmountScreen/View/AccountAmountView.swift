import UIKit
import SnapKit

final class AccountAmountView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите сумму вашего бюджета"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let mainContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let amountStackView: UIStackView = {
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
        return textField
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "USD"
        label.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.8)
        return view
    }()
    
    private(set) lazy var nextButton: UIButton = {
        let button = ButtonFactory.createPrimaryButton(title: "Далее")
        button.layer.cornerRadius = 56 / 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.15
        return button
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupConstraints()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        amountStackView.addArrangedSubview(amountTextField)
        amountStackView.addArrangedSubview(currencyLabel)
        
        mainContainerView.addSubview(amountStackView)
        mainContainerView.addSubview(underlineView)
        
        addSubview(titleLabel)
        addSubview(mainContainerView)
        addSubview(nextButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(60)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        mainContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        amountStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(60)
        }
        
        // Одна линия под всей строкой
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(amountStackView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(amountStackView)
            make.height.equalTo(3)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-32)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
    }
    
    private func setupAppearance() {
        underlineView.layer.cornerRadius = 1.5
        underlineView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Лёгкая тень для подчёркивания
        underlineView.layer.shadowColor = UIColor.systemBlue.cgColor
        underlineView.layer.shadowOffset = CGSize(width: 0, height: 2)
        underlineView.layer.shadowRadius = 4
        underlineView.layer.shadowOpacity = 0.2
    }
    
    // MARK: - Public API
    
    func getEnteredAmount() -> String? {
        return amountTextField.text
    }
    
    func clearTextField() {
        amountTextField.text = nil
    }
    
    func setCurrency(_ currency: String) {
        currencyLabel.text = currency
    }
    
    func showActiveState() {
        UIView.animate(withDuration: 0.3) {
            self.underlineView.backgroundColor = .primary
            self.underlineView.transform = CGAffineTransform(scaleX: 1.02, y: 1.0)
        }
    }
    
    func showInactiveState() {
        UIView.animate(withDuration: 0.3) {
            self.underlineView.backgroundColor = .lightGray.withAlphaComponent(0.8)
            self.underlineView.transform = .identity
        }
    }
}
