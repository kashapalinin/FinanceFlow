//
//  DateRangePickerView.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 03.01.2026.
//
import UIKit
import SnapKit

class DateRangePickerView: UIView {
    
    var selectedDate: Date? {
        didSet {
            updateDisplayText()
            updateVisualState()
        }
    }
    
    var onDateSelected: ((Date) -> Void)?
    
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let iconSize: CGFloat = 22
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 14
        static let spacing: CGFloat = 12
        static let animationDuration: TimeInterval = 0.2
        static let highlightAlpha: CGFloat = 0.9
        static let chevronSize: CGFloat = 14
        static let dateStatusCornerRadius: CGFloat = 6
        static let dateStatusInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        static let dateStatusMinWidth: CGFloat = 80
        static let dateStatusHeight: CGFloat = 28
    }
    
    private lazy var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.borderColor = UIColor.primary.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var highlightView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.alpha = 0
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    private lazy var calendarIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .primary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.text = "Выберите дату"
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .primary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var dateStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary.withAlphaComponent(0.1)
        view.layer.cornerRadius = Constants.dateStatusCornerRadius
        view.isHidden = true
        return view
    }()
    
    private lazy var dateStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .primary
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.spacing
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupGesture()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        dateStatusView.addSubview(dateStatusLabel)
        
        dateStatusLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constants.dateStatusInsets)
        }
        
        addSubview(mainContainerView)
        mainContainerView.addSubview(highlightView)
        mainContainerView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(calendarIconImageView)
        contentStackView.addArrangedSubview(dateLabel)
        contentStackView.addArrangedSubview(dateStatusView)
        contentStackView.addArrangedSubview(chevronImageView)
        
        calendarIconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        chevronImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dateStatusView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        mainContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        highlightView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Constants.verticalPadding)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalPadding)
        }
        
        calendarIconImageView.snp.makeConstraints { make in
            make.size.equalTo(Constants.iconSize)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.size.equalTo(Constants.chevronSize)
        }
        
        dateStatusView.snp.makeConstraints { make in
            make.height.equalTo(Constants.dateStatusHeight)
            make.width.greaterThanOrEqualTo(Constants.dateStatusMinWidth)
        }
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func handleTap() {
        animateTap()
        showCalendarPicker()
    }
    
    private func animateTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.highlightView.alpha = Constants.highlightAlpha
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.highlightView.alpha = 0
                self.transform = .identity
            })
        }
    }
    
    @objc private func showCalendarPicker() {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let calendarVC = CalendarPickerViewController()
        calendarVC.initialDate = selectedDate ?? Date()
        calendarVC.delegate = self
        
        let nav = UINavigationController(rootViewController: calendarVC)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = Constants.cornerRadius
        }
        
        rootVC.present(nav, animated: true)
    }
    
    private func updateDisplayText() {
        guard let date = selectedDate else {
            dateLabel.text = "Выберите дату"
            dateLabel.textColor = .secondaryLabel
            dateStatusView.isHidden = true
            return
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM yyyy"
        dateLabel.text = formatter.string(from: date)
        dateLabel.textColor = .label
        
        updateDateStatus(for: date)
    }
    
    private func updateDateStatus(for date: Date) {
        let calendar = Calendar.current
        let now = Date()
        
        dateStatusView.isHidden = false
        
        if calendar.isDateInToday(date) {
            dateStatusLabel.text = "Сегодня"
            dateStatusView.backgroundColor = .systemGreen.withAlphaComponent(0.1)
            dateStatusLabel.textColor = .systemGreen
        } else if calendar.isDateInYesterday(date) {
            dateStatusLabel.text = "Вчера"
            dateStatusView.backgroundColor = .systemOrange.withAlphaComponent(0.1)
            dateStatusLabel.textColor = .systemOrange
        } else if let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: now),
                  calendar.isDate(date, inSameDayAs: twoDaysAgo) {
            dateStatusLabel.text = "Позавчера"
            dateStatusView.backgroundColor = .systemOrange.withAlphaComponent(0.1)
            dateStatusLabel.textColor = .systemOrange
        } else if date > now {
            dateStatusLabel.text = "Будущее"
            dateStatusView.backgroundColor = .systemBlue.withAlphaComponent(0.1)
            dateStatusLabel.textColor = .systemBlue
        } else {
            dateStatusLabel.text = "Прошедшая"
            dateStatusView.backgroundColor = .systemGray.withAlphaComponent(0.1)
            dateStatusLabel.textColor = .secondaryLabel
        }
        
        dateStatusLabel.sizeToFit()
        
        if dateStatusView.alpha == 0 {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.dateStatusView.alpha = 1
            }
        }
    }
    
    private func updateVisualState() {
        let hasSelection = selectedDate != nil
        
        UIView.animate(withDuration: Constants.animationDuration) {
            if hasSelection {
                self.calendarIconImageView.tintColor = .primary
                self.chevronImageView.tintColor = .primary
            } else {
                self.calendarIconImageView.tintColor = .primary
                self.chevronImageView.tintColor = .primary
            }
        }
    }
    
    func setCustomDateStatus(_ text: String, color: UIColor = .systemBlue) {
        dateStatusLabel.text = text
        dateStatusView.backgroundColor = color.withAlphaComponent(0.1)
        dateStatusLabel.textColor = color
        dateStatusView.isHidden = false
        dateStatusLabel.sizeToFit()
    }
}

extension DateRangePickerView: CalendarPickerViewControllerDelegate {
    func calendarPickerViewController(_ controller: CalendarPickerViewController, didSelectRange range: DateInterval) {
        selectedDate = range.start
        onDateSelected?(range.start)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.highlightView.backgroundColor = .systemBlue.withAlphaComponent(0.1)
            self.highlightView.alpha = Constants.highlightAlpha
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.highlightView.alpha = 0
                self.highlightView.backgroundColor = .systemGray6
            }
        }
    }
}
