//
//  MainViewController 2.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 27.12.2025.
//
import UIKit
import DGCharts
import CurrencyFormatter
import SnapKit
import FSCalendar
import Domain

class MainScreenViewController: UIViewController {
    private var mainView = MainScreenView()
    var presenter: MainScreenPresenterProtocol?
    private(set) lazy var collectionDataSource: TransactionsDataSource = {
        TransactionsDataSource()
    }()
    
    private(set) lazy var collectionDelegate: TransactionsDelegate = {
        TransactionsDelegate(dataSource: collectionDataSource)
    }()
    
    private var isShowingLineChart = false
    private var currentRange: DateInterval = {
        let now = Date()
        return DateInterval(start: now.startOfDay(), duration: 86400)
    }()

    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTransactions()
        mainView.amountLabel.text = "\(presenter?.getCurrentBudget() ?? 0) " + (presenter?.getCurrencySymbol() ?? "")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCollectionSwipe(_:)))
        panGesture.delegate = self
        mainView.collectionView.addGestureRecognizer(panGesture)
        mainView.delegate = self
        
        setupActions()
        setupCollectionView()
        updateDisplayedPeriod(for: currentRange)
        
        collectionDelegate.onCategoryTapped = { [weak self] category in
            guard let self = self, let category = category else { return }
            self.presenter?.openTransactionsCategoryScreen(categoryId: category.category.id, interval: self.currentRange)
        }
    }

    private func setupActions() {
        mainView.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }

    private func setupCollectionView() {
        mainView.collectionView.delegate = collectionDelegate
        mainView.collectionView.dataSource = collectionDataSource
    }

    @objc private func addTapped() {
        presenter?.showTransactionManageScreen()
    }

    private func updateChartForIncome() {
        let entries = [
            PieChartDataEntry(value: 50000, label: "Зарплата"),
            PieChartDataEntry(value: 15000, label: "Фриланс"),
            PieChartDataEntry(value: 3500, label: "Инвестиции"),
            PieChartDataEntry(value: 10000, label: "Дивиденды")
        ]
        mainView.updatePieChartData(entries: entries, colors: [.systemGreen, .systemTeal, .systemCyan, .systemMint])
    }
    
    private func updateCharts(transactions: [TransactionsByCategory]) {
        let entries = transactions.map { PieChartDataEntry(value: $0.amount, label: $0.category.name)}
        mainView.updatePieChartData(entries: entries, colors: transactions.map { UIColor(hexData: $0.category.color) ?? .primary })
    }

    // MARK: - Period Display & Navigation
    private func updateDisplayedPeriod(for range: DateInterval) {
        currentRange = range
        
        let formatter = DateFormatter()
        let start = range.start
        let end = range.end
        
        switch mainView.currentPeriodIndex {
        case 0: // День
            formatter.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
            mainView.periodLabel.text = formatter.string(from: start)
        case 1: // Неделя
            let startStr = DateFormatter.localizedString(from: start, dateStyle: .medium, timeStyle: .none)
            let endStr = DateFormatter.localizedString(from: end, dateStyle: .medium, timeStyle: .none)
            mainView.periodLabel.text = "\(startStr) – \(endStr)"
        case 2: // Месяц
            formatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
            mainView.periodLabel.text = formatter.string(from: start)
        case 3: // Год
            formatter.setLocalizedDateFormatFromTemplate("yyyy")
            mainView.periodLabel.text = formatter.string(from: start)
        default:
            mainView.periodLabel.text = "Сегодня"
        }
    }

    private func updatePeriodForCurrentType() {
        let range = rangeForType(mainView.currentPeriodIndex, anchorDate: currentRange.start)
        updateDisplayedPeriod(for: range)
        updateTransactions()
    }

    private func rangeForType(_ periodIndex: Int, anchorDate: Date) -> DateInterval {
        switch periodIndex {
        case 0: return DateInterval(start: anchorDate.startOfDay(), duration: 86400)
        case 1: return anchorDate.weekInterval()
        case 2: return anchorDate.monthInterval()
        case 3: return anchorDate.yearInterval()
        default: return DateInterval(start: anchorDate.startOfDay(), duration: 86400)
        }
    }

    @objc private func handleCollectionSwipe(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: mainView.collectionView)
        switch gesture.state {
        case .ended:
            let offsetY = translation.y
            if offsetY <= 50 && !isShowingLineChart {
                mainView.showLineChart()
                isShowingLineChart = true
            } else if offsetY > 50 && isShowingLineChart {
                mainView.showPieChart()
                isShowingLineChart = false
            }
        default: break
        }
    }
}

// MARK: - Gesture Delegate
extension MainScreenViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - MainScreenViewDelegate
extension MainScreenViewController: MainScreenViewDelegate {
    
    func updateTransactions() {
        let transactionsByCategory = presenter?.formTransactionsByCategories(type: mainView.isIncomeSelected ? .INCOME : .EXPENSE, for: currentRange) ?? []
        collectionDataSource.setExpenses(expenses: transactionsByCategory)
        updateCharts(transactions: transactionsByCategory)
        mainView.collectionView.reloadData()
    }
    
    func didTapIncome() {
        updateTransactions()
    }
    
    func didTapExpense() {
        updateTransactions()
    }
    
    func periodTypeChanged(to index: Int) {
        mainView.setSelectedPeriod(index)
        updatePeriodForCurrentType()
    }

    func didTapSelectDate() {
        let calendarVC = CalendarPickerViewController()
        calendarVC.initialDate = currentRange.start
        calendarVC.rangeMode = calendarRangeMode(from: mainView.currentPeriodIndex)
        calendarVC.configureCalendarScope()
        calendarVC.delegate = self
        calendarVC.modalPresentationStyle = .pageSheet
        if let sheet = calendarVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(calendarVC, animated: true)
    }

    func navigatePeriodBackward() {
        let newStart = Calendar.current.date(byAdding: periodComponent, value: -1, to: currentRange.start)!
        let newRange = rangeForType(mainView.currentPeriodIndex, anchorDate: newStart)
        updateDisplayedPeriod(for: newRange)
        updateTransactions()
    }

    func navigatePeriodForward() {
        let newStart = Calendar.current.date(byAdding: periodComponent, value: 1, to: currentRange.start)!
        let newRange = rangeForType(mainView.currentPeriodIndex, anchorDate: newStart)
        updateDisplayedPeriod(for: newRange)
        updateTransactions()
    }

    private var periodComponent: Calendar.Component {
        switch mainView.currentPeriodIndex {
        case 0: return .day
        case 1: return .weekOfYear
        case 2: return .month
        case 3: return .year
        default: return .day
        }
    }

    private func calendarRangeMode(from periodIndex: Int) -> CalendarRangeMode {
        switch periodIndex {
        case 0: return .day
        case 1: return .week
        case 2: return .month
        case 3: return .year
        default: return .day
        }
    }
}

// MARK: - CalendarPickerViewControllerDelegate
extension MainScreenViewController: CalendarPickerViewControllerDelegate {
    func calendarPickerViewController(_ controller: CalendarPickerViewController, didSelectRange range: DateInterval) {
        updateDisplayedPeriod(for: range)
        updateTransactions()
    }
}
