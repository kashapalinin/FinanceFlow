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

class MainScreenViewController: UIViewController {
    private lazy var mainView = MainScreenView()
    var presenter: MainScreenPresenterProtocol?
    private var expenses: [Expense] = [
    ]
    
    private var isShowingLineChart = false

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCollectionSwipe(_:)))
        panGesture.delegate = self
        
        mainView.amountLabel.text = "\(presenter?.getCurrentBudget() ?? 0) " + (presenter?.getCurrencySymbol() ?? "")
        mainView.collectionView.addGestureRecognizer(panGesture)
        
        setupActions()
        setupCollectionView()
        setupTestData()
    }

    private func setupActions() {
        mainView.expensesButton.addTarget(self, action: #selector(expensesTapped), for: .touchUpInside)
        mainView.incomeButton.addTarget(self, action: #selector(incomeTapped), for: .touchUpInside)
        mainView.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        // Добавляем действия для кнопок периода
        mainView.dayButton.addTarget(self, action: #selector(periodButtonTapped(_:)), for: .touchUpInside)
        mainView.weekButton.addTarget(self, action: #selector(periodButtonTapped(_:)), for: .touchUpInside)
        mainView.monthButton.addTarget(self, action: #selector(periodButtonTapped(_:)), for: .touchUpInside)
        mainView.yearButton.addTarget(self, action: #selector(periodButtonTapped(_:)), for: .touchUpInside)
    }

    private func setupCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }

    private func setupTestData() {
        // Тестовые данные для круговой диаграммы
        let pieEntries = [
            PieChartDataEntry(value: 2500, label: "Продукты"),
            PieChartDataEntry(value: 850, label: "Транспорт"),
            PieChartDataEntry(value: 1200, label: "Кафе"),
            PieChartDataEntry(value: 3000, label: "Развлечения"),
            PieChartDataEntry(value: 4800, label: "Одежда")
        ]
        
        mainView.updatePieChartData(entries: pieEntries)
    }

    @objc private func expensesTapped() {
        mainView.setSelectedTab(false)
        updateChartForExpenses()
        expenses = getSampleExpenses(forType: .expense)
        mainView.collectionView.reloadData()
    }

    @objc private func incomeTapped() {
        mainView.setSelectedTab(true)
        updateChartForIncome()
        expenses = getSampleExpenses(forType: .income)
        mainView.collectionView.reloadData()
    }

    @objc private func addTapped() {
        presenter?.showTransactionManageScreen()
    }

    @objc private func periodButtonTapped(_ sender: UIButton) {
        let periods = [mainView.dayButton, mainView.weekButton, mainView.monthButton, mainView.yearButton]
        guard let index = periods.firstIndex(of: sender) else { return }
        
        mainView.setSelectedPeriod(index)
    }

    private func updateChartForExpenses() {
        // Обновляем круговую диаграмму для расходов
        let currentPeriod = mainView.currentPeriodIndex
        mainView.updateChartForPeriod(currentPeriod)
    }

    private func updateChartForIncome() {
        // Обновляем круговую диаграмму для доходов
        let entries = [
            PieChartDataEntry(value: 50000, label: "Зарплата"),
            PieChartDataEntry(value: 15000, label: "Фриланс"),
            PieChartDataEntry(value: 3500, label: "Инвестиции"),
            PieChartDataEntry(value: 10000, label: "Дивиденды")
        ]
        
        mainView.updatePieChartData(entries: entries, colors: [.systemGreen, .systemTeal, .systemCyan, .systemMint])
    }

    private func showAddExpenseScreen(isIncome: Bool) {
        let title = isIncome ? "Добавить доход" : "Добавить расход"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Категория"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Сумма"
            textField.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { _ in
            guard let category = alert.textFields?[0].text, !category.isEmpty,
                  let amount = alert.textFields?[1].text, !amount.isEmpty else { return }
            
            let prefix = isIncome ? "+" : "-"
            let newExpense = Expense(
                category: category,
                amount: "\(prefix)₽\(amount)",
                date: "Сегодня",
                iconName: isIncome ? "arrow.down.circle.fill" : "arrow.up.circle.fill"
            )
            
            self.expenses.insert(newExpense, at: 0)
            self.mainView.collectionView.reloadData()
            self.updateTotalAmount()
            self.updateChartsWithNewData(isIncome: isIncome)
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }

    private func updateTotalAmount() {
        let total = expenses.reduce(0) { result, expense in
            let amountString = expense.amount
                .replacingOccurrences(of: "+", with: "")
                .replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: "₽", with: "")
                .replacingOccurrences(of: " ", with: "")
            
            if let amount = Double(amountString) {
                return result + amount
            }
            return result
        }
        
        mainView.amountLabel.text = "₽\(Int(total))"
    }

    private func updateChartsWithNewData(isIncome: Bool) {
        if isIncome {
            updateChartForIncome()
        } else {
            updateChartForExpenses()
        }
    }

    private func getSampleExpenses(forType type: ExpenseType) -> [Expense] {
        switch type {
        case .expense:
            return [
                Expense(category: "Продукты", amount: "-₽2 500", date: "Сегодня, 14:30", iconName: "cart.fill"),
                Expense(category: "Транспорт", amount: "-₽850", date: "Сегодня, 09:15", iconName: "car.fill"),
                Expense(category: "Кафе", amount: "-₽1 200", date: "Вчера, 19:45", iconName: "fork.knife"),
                Expense(category: "Развлечения", amount: "-₽3 000", date: "26 дек", iconName: "film.fill"),
                Expense(category: "Одежда", amount: "-₽4 800", date: "25 дек", iconName: "tshirt.fill")
            ]
        case .income:
            return [
                Expense(category: "Зарплата", amount: "+₽50 000", date: "25 дек", iconName: "creditcard.fill"),
                Expense(category: "Фриланс", amount: "+₽15 000", date: "20 дек", iconName: "laptopcomputer"),
                Expense(category: "Инвестиции", amount: "+₽3 500", date: "18 дек", iconName: "chart.line.uptrend.xyaxis")
            ]
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

        default:
            break
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expenses.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpenseCell", for: indexPath) as! ExpenseCell
        let expense = expenses[indexPath.row]
        cell.configure(with: expense)
        
        // Set color based on income/expense
        if expense.amount.hasPrefix("+") {
            cell.amountLabel.textColor = .systemGreen
        } else {
            cell.amountLabel.textColor = .systemRed
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 72)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 100, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let expense = expenses[indexPath.row]
        let alert = UIAlertController(title: expense.category,
                                    message: "Сумма: \(expense.amount)\nДата: \(expense.date)",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MainScreenViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Expense Type Enum
enum ExpenseType {
    case expense
    case income
}
