//
//  CurrencyCell.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 05.12.2025.
//
import UIKit
import SnapKit
import CurrencyFormatter

class CurrencyCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var charCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private lazy var selectionIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(selectionIndicator)
        contentView.addSubview(nameLabel)
        contentView.addSubview(charCodeLabel)
        
        selectionIndicator.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        charCodeLabel.snp.makeConstraints { make in
            make.leading.equalTo(selectionIndicator.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(charCodeLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with currency: Currency, isSelected: Bool) {
        nameLabel.text = currency.name
        charCodeLabel.text = currency.charCode
        selectionIndicator.isHidden = !isSelected
    }
}


extension CurrencyCell {
    static let reuseIdentifier = "CurrencyCell"
}
