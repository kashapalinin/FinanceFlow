//
//  StarRatingView.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 07.01.2026.
//
import UIKit
import SnapKit

final class StarRatingView: UIView {
    
    private var buttons: [UIButton] = []
    private(set) var rating: Int = 0 {
        didSet {
            updateUI()
        }
    }
    
    init(maxStars: Int) {
        super.init(frame: .zero)
        setup(maxStars: maxStars)
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setup(maxStars: Int) {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .center
        addSubview(stack)
        
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()       // ← центрируем содержимое
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        for index in 1...maxStars {
            let button = UIButton(type: .custom)
            
            let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
            let normal = UIImage(systemName: "star", withConfiguration: config)
            let selected = UIImage(systemName: "star.fill", withConfiguration: config)
            
            button.setImage(normal?.withTintColor(.systemGray3, renderingMode: .alwaysOriginal), for: .normal)
            button.setImage(selected?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal), for: .selected)
            
            button.tag = index
            button.addTarget(self, action: #selector(didTapStar), for: .touchUpInside)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.snp.makeConstraints {
                $0.width.height.equalTo(40)
            }
            
            buttons.append(button)
            stack.addArrangedSubview(button)
        }
        
        updateUI()
    }
    
    @objc private func didTapStar(_ sender: UIButton) {
        rating = sender.tag
    }
    
    private func updateUI() {
        buttons.forEach {
            $0.isSelected = $0.tag <= rating
        }
    }
}
