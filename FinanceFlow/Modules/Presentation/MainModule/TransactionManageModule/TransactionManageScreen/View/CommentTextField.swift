//
//  CommentTextFieldDelegate.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 03.01.2026.
//


import UIKit
import SnapKit

protocol CommentTextFieldDelegate: AnyObject {
    func commentTextFieldDidChange(_ text: String)
    func commentTextFieldDidReturn()
    func commentTextFieldDidBeginEditing()
    func commentTextFieldDidEndEditing()
}

class CommentTextField: UIView {
    private let maxLength: Int
    private let placeholderText: String
    weak var delegate: CommentTextFieldDelegate?
        
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .label
        textField.tintColor = .systemBlue
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .sentences
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.8)
        return view
    }()
    
    private lazy var activeUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        view.alpha = 0
        return view
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.alpha = 0
        return label
    }()
    
    private lazy var characterCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
        
    init(maxLength: Int = 100, placeholder: String = "Комментарий") {
        self.maxLength = maxLength
        self.placeholderText = placeholder
        super.init(frame: .zero)
        setupView()
        setupPlaceholder()
        updateCharacterCount()
        
        textField.addTarget(
                    self,
                    action: #selector(updateUnderlineState),
                    for: .editingChanged
                )
    }
    
    required init?(coder: NSCoder) {
        self.maxLength = 100
        self.placeholderText = "Комментарий"
        super.init(coder: coder)
        setupView()
        setupPlaceholder()
        updateCharacterCount()
    }
        
    private func setupView() {
        addSubview(textField)
        addSubview(underlineView)
        addSubview(activeUnderlineView)
        addSubview(placeholderLabel)
        addSubview(characterCountLabel)
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.edges.equalTo(textField)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        
        activeUnderlineView.snp.makeConstraints { make in
            make.edges.equalTo(underlineView)
        }
        
        characterCountLabel.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom).offset(4)
            make.trailing.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.bottom.equalToSuperview().offset(-4)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    private func setupPlaceholder() {
        placeholderLabel.text = placeholderText
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: UIColor.lightGray.withAlphaComponent(0.8),
                .font: UIFont.systemFont(ofSize: 16, weight: .regular)
            ]
        )
    }
    
    func setText(_ text: String) {
        textField.text = text
        updatePlaceholderVisibility()
        updateCharacterCount()
        delegate?.commentTextFieldDidChange(text)
    }
    
    func getText() -> String {
        return textField.text ?? ""
    }
    
    func clear() {
        textField.text = ""
        updatePlaceholderVisibility()
        updateCharacterCount()
        delegate?.commentTextFieldDidChange("")
    }
    
    func setFocus() {
        textField.becomeFirstResponder()
    }
    
    func removeFocus() {
        textField.resignFirstResponder()
    }
    
    private func updatePlaceholderVisibility() {
        let isEmpty = textField.text?.isEmpty ?? true
        
        UIView.animate(withDuration: 0.2) {
            self.placeholderLabel.alpha = isEmpty ? 1 : 0
            self.textField.attributedPlaceholder = isEmpty ? 
                NSAttributedString(
                    string: self.placeholderText,
                    attributes: [
                        .foregroundColor: UIColor.systemGray3,
                        .font: UIFont.systemFont(ofSize: 16, weight: .regular)
                    ]
                ) : nil
        }
    }
    
    private func updateCharacterCount() {
        let count = textField.text?.count ?? 0
        characterCountLabel.text = "\(count)/\(maxLength)"
        
        if count > maxLength * 8 / 10 {
            characterCountLabel.textColor = .systemOrange
        } else if count > maxLength {
            characterCountLabel.textColor = .systemRed
        } else {
            characterCountLabel.textColor = .systemGray
        }
    }
    
    @objc private func updateUnderlineState() {
        let hasText = !(textField.text?.isEmpty ?? true)
        if hasText {
            animateUnderline(isActive: true)
        } else {
            animateUnderline(isActive: false)
        }
    }
    
    private func animateUnderline(isActive: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.activeUnderlineView.alpha = isActive ? 1 : 0
            self.underlineView.alpha = isActive ? 0 : 1
        }
    }
    
    @objc private func textFieldDidChange() {
        guard let text = textField.text else { return }
        
        if text.count > maxLength {
            textField.text = String(text.prefix(maxLength))
        }
        
        updatePlaceholderVisibility()
        updateCharacterCount()
        delegate?.commentTextFieldDidChange(textField.text ?? "")
    }
}

extension CommentTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.commentTextFieldDidReturn()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= maxLength
    }
}
