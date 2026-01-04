//
//  CategoryCell.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 02.01.2026.
//

import SnapKit
import UIKit
import Domain

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30 
        view.clipsToBounds = true
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.clear.cgColor
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Properties
    
    private var category: TransactionCategory?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    // MARK: - Setup
    
    private func setupCell() {
        contentView.addSubview(containerView)
        containerView.addSubview(circleView)
        circleView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        circleView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(60)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    // MARK: - Configuration
    
    func configure(with category: TransactionCategory, isSelected: Bool = false) {
        self.category = category
        
        // Установка цвета фона
        if let color = UIColor(hexData: category.color) {
            circleView.backgroundColor = color
            circleView.tintColor = .white
        } else {
            circleView.backgroundColor = .systemGray6
            iconImageView.tintColor = .label
        }
        
        if let icon = UIImage(data: category.icon) {
            iconImageView.image = icon.withRenderingMode(.alwaysTemplate)
        }
        
        nameLabel.text = category.name
        
        if isSelected {
            circleView.layer.borderColor = UIColor.systemBlue.cgColor
            circleView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            nameLabel.font = .systemFont(ofSize: 12, weight: .bold)
        } else {
            circleView.layer.borderColor = UIColor.clear.cgColor
            circleView.transform = .identity
            nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        circleView.backgroundColor = nil
        iconImageView.image = nil
        nameLabel.text = nil
        circleView.transform = .identity
        circleView.layer.borderColor = UIColor.clear.cgColor
    }
}

extension CategoryCollectionViewCell {
    static let reuseIdentifier = "CategoryCollectionViewCell"
}
