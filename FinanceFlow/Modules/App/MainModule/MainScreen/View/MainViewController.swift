//
//  MainViewController 2.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 27.12.2025.
//
import UIKit
import CurrencyFormatter

class MainViewController: UIViewController {
    private lazy var mainView = MainView()
    
    private var expenses: [Expense] = [
        Expense(category: "Продукты", amount: "-₽2 500", date: "Сегодня, 14:30", iconName: "cart.fill"),
        Expense(category: "Транспорт", amount: "-₽850", date: "Сегодня, 09:15", iconName: "car.fill"),
        Expense(category: "Кафе", amount: "-₽1 200", date: "Вчера, 19:45", iconName: "fork.knife"),
        Expense(category: "Развлечения", amount: "-₽3 000", date: "26 дек", iconName: "film.fill"),
        Expense(category: "Одежда", amount: "-₽4 800", date: "25 дек", iconName: "tshirt.fill")
    ]
    
    private var isShowingLineChart = false

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupCollectionView()
    }

    private func setupActions() {
        mainView.expensesButton.addTarget(self, action: #selector(expensesTapped), for: .touchUpInside)
        mainView.incomeButton.addTarget(self, action: #selector(incomeTapped), for: .touchUpInside)
        mainView.addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }

    private func setupCollectionView() {
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        // Add scroll view delegate for chart transformation
        mainView.collectionView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }

    @objc private func expensesTapped() {
        mainView.setSelectedTab(false)
        updateChartLabel(forExpenses: true)
        expenses = getSampleExpenses(forType: .expense)
        mainView.collectionView.reloadData()
    }

    @objc private func incomeTapped() {
        mainView.setSelectedTab(true)
        updateChartLabel(forExpenses: false)
        expenses = getSampleExpenses(forType: .income)
        mainView.collectionView.reloadData()
    }

    @objc private func addTapped() {
        let alert = UIAlertController(title: "Добавить",
                                    message: "Выберите тип операции",
                                    preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Расход", style: .default, handler: { _ in
            self.showAddExpenseScreen(isIncome: false)
        }))
        
        alert.addAction(UIAlertAction(title: "Доход", style: .default, handler: { _ in
            self.showAddExpenseScreen(isIncome: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
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

    private func updateChartLabel(forExpenses: Bool) {
        if expenses.isEmpty {
            mainView.chartCenterLabel.text = forExpenses ? "Нет расходов" : "Нет доходов"
            mainView.chartAmountLabel.text = "₽0"
        } else {
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
            
            mainView.chartCenterLabel.text = forExpenses ? "Расходы" : "Доходы"
            mainView.chartAmountLabel.text = "₽\(Int(total))"
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

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset", let scrollView = object as? UIScrollView {
            let offsetY = scrollView.contentOffset.y
            
            if offsetY > 50 && !isShowingLineChart {
                mainView.showLineChart()
                isShowingLineChart = true
            } else if offsetY <= 50 && isShowingLineChart {
                mainView.showPieChart()
                isShowingLineChart = false
            }
        }
    }

    deinit {
        mainView.collectionView.removeObserver(self, forKeyPath: "contentOffset")
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

// MARK: - Expense Type Enum
enum ExpenseType {
    case expense
    case income
}
