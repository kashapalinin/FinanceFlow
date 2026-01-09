//
//  CommentInputView.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 07.01.2026.
//
import UIKit
import SnapKit

final class CommentInputView: UITextView {

    let placeholderText: String
    private let placeholderColor = UIColor.systemGray2
    private let normalTextColor = UIColor.label

    init(placeholder: String) {
        self.placeholderText = placeholder
        super.init(frame: .zero, textContainer: nil)
        setup(placeholder: placeholder)
    }

    required init?(coder: NSCoder) { nil }

    private func setup(placeholder: String) {
        text = placeholder
        textColor = placeholderColor
        font = .systemFont(ofSize: 16)
        textContainer.lineFragmentPadding = 0
        textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        layer.borderWidth = 1
        layer.cornerRadius = 12
        layer.borderColor = UIColor.systemGray5.cgColor
        backgroundColor = UIColor.systemBackground

        // Обработка ввода
        delegate = self
        snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(80)
                $0.height.lessThanOrEqualTo(150)
            }
    }
}

extension CommentInputView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text = nil
            textView.textColor = normalTextColor
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = placeholderColor
        }
    }
}
