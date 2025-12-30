//
//  ButtonFactory.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.12.2025.
//
import UIKit

enum ButtonStyle {
    case primary
    case secondary
    case danger
    case success
    case outline
    case ghost
    case icon(image: UIImage)
    case custom(
        backgroundColor: UIColor,
        titleColor: UIColor,
        font: UIFont,
        cornerRadius: CGFloat
    )
    
    var backgroundColor: UIColor {
        switch self {
        case .primary:
            return .secondary
        case .secondary:
            return .systemGray
        case .danger:
            return .systemRed
        case .success:
            return .systemGreen
        case .outline, .ghost:
            return .clear
        case .icon:
            return .clear
        case .custom(let backgroundColor, _, _, _):
            return backgroundColor
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .primary, .secondary, .danger, .success:
            return .primaryText
        case .outline:
            return .systemBlue
        case .ghost:
            return .systemGray
        case .icon:
            return .label
        case .custom(_, let titleColor, _, _):
            return titleColor
        }
    }

    var font: UIFont {
        switch self {
        case .custom(_, _, let font, _):
            return font
        default:
            return .systemFont(ofSize: 16, weight: .medium)
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .custom(_, _, _, let cornerRadius):
            return cornerRadius
        default:
            return 8
        }
    }
}

final class ButtonFactory {
    
    static func createButton(
        title: String = "",
        style: ButtonStyle = .primary,
        action: (() -> Void)? = nil
    ) -> UIButton {
        let button = UIButton(type: .system)
        
        button.isEnabled = true
        
        applyStyle(style, to: button)
        
        if !title.isEmpty {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = style.font
            button.setTitleColor(style.titleColor, for: .normal)
            button.setTitleColor(style.titleColor.withAlphaComponent(0.7), for: .highlighted)
            button.setTitleColor(style.titleColor.withAlphaComponent(0.5), for: .disabled)
        }
        
        if let action = action {
            button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        }
        
        return button
    }
    
    private static func applyStyle(_ style: ButtonStyle, to button: UIButton) {
        button.backgroundColor = style.backgroundColor
        button.layer.cornerRadius = style.cornerRadius
        button.clipsToBounds = true
        
        configureStates(for: button, style: style)
    }
    
    private static func configureStates(for button: UIButton, style: ButtonStyle) {
        // Highlighted state
        button.addAction(UIAction { _ in
            UIView.animate(withDuration: 0.1) {
                button.alpha = 0.8
                button.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            }
        }, for: .touchDown)
        
        button.addAction(UIAction { _ in
            UIView.animate(withDuration: 0.1) {
                button.alpha = 1.0
                button.transform = .identity
            }
        }, for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        button.setBackgroundColor(style.backgroundColor.withAlphaComponent(0.5), for: .disabled)
    }
}

extension ButtonFactory {
    static func createPrimaryButton(title: String, action: (() -> Void)? = nil) -> UIButton {
        createButton(title: title, style: .primary, action: action)
    }
}
