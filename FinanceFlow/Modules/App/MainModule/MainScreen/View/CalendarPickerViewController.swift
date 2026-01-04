//
//  CalendarPickerViewControllerDelegate.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 01.01.2026.
//
// CalendarPickerViewController.swift
import UIKit
import FSCalendar
import SnapKit

enum CalendarRangeMode {
    case day
    case week
    case month
    case year
}

protocol CalendarPickerViewControllerDelegate: AnyObject {
    func calendarPickerViewController(_ controller: CalendarPickerViewController, didSelectRange range: DateInterval)
}

class CalendarPickerViewController: UIViewController {
    
    // MARK: - Private Enums
    private enum Constants {
        static let calendarHeight: CGFloat = 320
        static let calendarInset: CGFloat = 16
        static let buttonHeight: CGFloat = 44
        static let buttonStackSpacing: CGFloat = 16
        static let verticalSpacing: CGFloat = 20
        static let titleFontSize: CGFloat = 16
        static let headerFontSize: CGFloat = 18
        static let weekdayFontSize: CGFloat = 14
        static let buttonFontSize: CGFloat = 17
        static let oneDayInSeconds: TimeInterval = 86400
        static let firstWeekday: Int = 2
        
        enum Colors {
            static let primary = UIColor.primary
            static let label = UIColor.label
            static let secondaryLabel = UIColor.secondaryLabel
            static let white = UIColor.white
            static let systemBackground = UIColor.systemBackground
        }
        
        enum Strings {
            static let doneButtonTitle = "Готово"
            static let cancelButtonTitle = "Отмена"
            static let screenTitle = "Выберите период"
        }
    }
    
    // MARK: - Properties
    weak var delegate: CalendarPickerViewControllerDelegate?
    var initialDate: Date = Date()
    var rangeMode: CalendarRangeMode = .day
    
    // MARK: - UI Components
    private lazy var calendar: FSCalendar = {
        let cal = FSCalendar()
        cal.locale = Locale.current
        cal.firstWeekday = 2 // Понедельник (для РФ)
        cal.scope = .month
        cal.allowsMultipleSelection = false
        cal.allowsSelection = true
        
        cal.appearance.titleFont = .systemFont(ofSize: Constants.titleFontSize)
        cal.appearance.headerTitleFont = .systemFont(ofSize: Constants.headerFontSize, weight: .semibold)
        cal.appearance.weekdayFont = .systemFont(ofSize: Constants.weekdayFontSize)
        cal.appearance.titleDefaultColor = Constants.Colors.label
        cal.appearance.titleSelectionColor = Constants.Colors.white
        cal.appearance.selectionColor = Constants.Colors.primary
        cal.appearance.headerTitleColor = Constants.Colors.label
        cal.appearance.weekdayTextColor = Constants.Colors.secondaryLabel
        
        return cal
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.doneButtonTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: Constants.buttonFontSize, weight: .semibold)
        button.setTitleColor(Constants.Colors.primary, for: .normal)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.cancelButtonTitle, for: .normal)
        button.setTitleColor(Constants.Colors.secondaryLabel, for: .normal)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = Constants.buttonStackSpacing
        return stack
    }()
    
    private var selectedRange: DateInterval?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.systemBackground
        title = Constants.Strings.screenTitle
        
        setupViews()
        setupConstraints()
        setupActions()
        
        selectRangeContaining(initialDate)
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.addSubview(calendar)
        view.addSubview(buttonStack)
        
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(doneButton)
        
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    private func setupConstraints() {
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.calendarInset)
            make.leading.trailing.equalToSuperview().inset(Constants.calendarInset)
            make.height.equalTo(Constants.calendarHeight).priority(.high)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(calendar.snp.bottom).offset(Constants.verticalSpacing)
            make.leading.trailing.equalToSuperview().inset(Constants.calendarInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.calendarInset)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonHeight)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    private func setupActions() {
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func doneTapped() {
        if let range = selectedRange {
            delegate?.calendarPickerViewController(self, didSelectRange: range)
        }
        dismiss(animated: true)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Range Logic
    private func selectRangeContaining(_ date: Date) {
        let range: DateInterval
        
        switch rangeMode {
        case .day:
            range = DateInterval(start: date.startOfDay(), duration: Constants.oneDayInSeconds)
        case .week:
            range = date.weekInterval()
        case .month:
            range = date.monthInterval()
        case .year:
            range = date.yearInterval()
        }
        
        selectedRange = range
        calendar.reloadData()
    }
    
    func configureCalendarScope() {
        calendar.scope = (rangeMode == .week) ? .week : .month
    }
}

// MARK: - FSCalendarDelegate
extension CalendarPickerViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectRangeContaining(date)
    }
}

// MARK: - FSCalendarDataSource
extension CalendarPickerViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        guard let range = selectedRange else { return nil }
        let dateDay = date.startOfDay()
        let rangeStart = range.start.startOfDay()
        let rangeEnd = range.end.startOfDay()
        
        if dateDay >= rangeStart && dateDay <= rangeEnd {
            return Constants.Colors.primary.withAlphaComponent(0.3)
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        guard let range = selectedRange else { return nil }
        let dateDay = date.startOfDay()
        let rangeStart = range.start.startOfDay()
        let rangeEnd = range.end.startOfDay()
        
        if dateDay >= rangeStart && dateDay <= rangeEnd {
            return Constants.Colors.white
        }
        return nil
    }
}
