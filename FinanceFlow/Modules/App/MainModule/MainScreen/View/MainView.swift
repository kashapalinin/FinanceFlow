import UIKit
import SnapKit
import DGCharts

class MainView: UIView {
    // MARK: - Existing Properties
    private let backgroundFillView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        view.clipsToBounds = false
        return view
    }()

    private let contentContainer: UIView = {
        let view = UIView()
        return view
    }()

    let budgetLabel: UILabel = {
        let label = UILabel()
        label.text = "Бюджет"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "12 500"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    let expensesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Расходы", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    let incomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Доходы", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let tabStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        return stack
    }()

    // MARK: - New Properties
    let statsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 8
        return view
    }()

    let periodTabStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()

    let dayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("День", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    let weekButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Неделя", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    let monthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Месяц", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    let yearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Год", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    let periodUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        return view
    }()

    let pieChartView: UIView = {
        let view = PieChartView()
        return view
    }()

    let lineChartView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()

    let chartCenterLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет расходов"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let chartAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "₽0"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .secondary
        button.tintColor = .black
        button.layer.cornerRadius = 28
        
        let config = UIImage.SymbolConfiguration(pointSize: 16)
        let plusImage = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(plusImage, for: .normal)
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ExpenseCell.self, forCellWithReuseIdentifier: "ExpenseCell")
        return collectionView
    }()

    private var isLineChartVisible = false
    private var isIncomeSelected = false
    private var currentPeriodIndex = 0

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupActions()
        setSelectedTab(false, animated: false)
        setSelectedPeriod(0, animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupViews() {
        backgroundColor = .systemBackground

        addSubview(backgroundFillView)
        addSubview(contentContainer)
        addSubview(statsContainer)
        addSubview(collectionView)

        tabStack.addArrangedSubview(expensesButton)
        tabStack.addArrangedSubview(incomeButton)

        periodTabStack.addArrangedSubview(dayButton)
        periodTabStack.addArrangedSubview(weekButton)
        periodTabStack.addArrangedSubview(monthButton)
        periodTabStack.addArrangedSubview(yearButton)

        contentContainer.addSubview(budgetLabel)
        contentContainer.addSubview(amountLabel)
        contentContainer.addSubview(tabStack)
        contentContainer.addSubview(underlineView)

        statsContainer.addSubview(periodTabStack)
        statsContainer.addSubview(periodUnderlineView)
        statsContainer.addSubview(pieChartView)
        statsContainer.addSubview(lineChartView)
        statsContainer.addSubview(chartCenterLabel)
        statsContainer.addSubview(chartAmountLabel)
        statsContainer.addSubview(addButton)

        // Add chart visualization
        setupCharts()
    }

    private func setupConstraints() {
        backgroundFillView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(calculateBannerTotalHeight())
        }

        contentContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(120)
        }

        budgetLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }

        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(budgetLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        tabStack.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(32)
        }

        underlineView.snp.makeConstraints { make in
            make.top.equalTo(tabStack.snp.bottom).offset(4)
            make.leading.equalTo(expensesButton.snp.leading)
            make.trailing.equalTo(expensesButton.snp.trailing)
            make.height.equalTo(4)
        }

        statsContainer.snp.makeConstraints { make in
            make.top.equalTo(backgroundFillView.snp.bottom).offset(-25)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }

        periodTabStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }

        periodUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(periodTabStack.snp.bottom).offset(2)
            make.leading.equalTo(dayButton.snp.leading)
            make.trailing.equalTo(dayButton.snp.trailing)
            make.height.equalTo(4)
        }

        pieChartView.snp.makeConstraints { make in
            make.top.equalTo(periodUnderlineView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }

        lineChartView.snp.makeConstraints { make in
            make.top.equalTo(periodUnderlineView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(150)
        }

        chartCenterLabel.snp.makeConstraints { make in
            make.center.equalTo(pieChartView)
            make.leading.trailing.equalTo(pieChartView).inset(20)
        }

        chartAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(lineChartView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-24)
            make.width.height.equalTo(56)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(statsContainer.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func setupActions() {
        expensesButton.addTarget(self, action: #selector(expensesButtonTapped), for: .touchUpInside)
        incomeButton.addTarget(self, action: #selector(incomeButtonTapped), for: .touchUpInside)
        
        dayButton.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        weekButton.addTarget(self, action: #selector(weekButtonTapped), for: .touchUpInside)
        monthButton.addTarget(self, action: #selector(monthButtonTapped), for: .touchUpInside)
        yearButton.addTarget(self, action: #selector(yearButtonTapped), for: .touchUpInside)
    }

    private func setupCharts() {
        // Setup pie chart layers
        let pieLayer = CAShapeLayer()
        pieLayer.path = createPieChartPath().cgPath
        pieLayer.fillColor = UIColor.clear.cgColor
        pieLayer.strokeColor = UIColor.primary.cgColor
        pieLayer.lineWidth = 20
        pieChartView.layer.addSublayer(pieLayer)

        // Setup line chart
        let lineLayer = CAShapeLayer()
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = UIColor.primary.cgColor
        lineLayer.lineWidth = 3
        lineChartView.layer.addSublayer(lineLayer)
    }

    // MARK: - Actions
    @objc private func expensesButtonTapped() {
        setSelectedTab(false)
    }

    @objc private func incomeButtonTapped() {
        setSelectedTab(true)
    }

    @objc private func dayButtonTapped() {
        setSelectedPeriod(0)
    }

    @objc private func weekButtonTapped() {
        setSelectedPeriod(1)
    }

    @objc private func monthButtonTapped() {
        setSelectedPeriod(2)
    }

    @objc private func yearButtonTapped() {
        setSelectedPeriod(3)
    }

    // MARK: - Public Methods
    func setSelectedTab(_ isIncome: Bool, animated: Bool = true) {
        guard isIncome != isIncomeSelected else { return }
        isIncomeSelected = isIncome

        let selectedColor = UIColor.white
        let deselectedColor = UIColor.white.withAlphaComponent(0.6)

        if isIncome {
            incomeButton.setTitleColor(selectedColor, for: .normal)
            expensesButton.setTitleColor(deselectedColor, for: .normal)
            chartCenterLabel.text = "Нет доходов"
        } else {
            expensesButton.setTitleColor(selectedColor, for: .normal)
            incomeButton.setTitleColor(deselectedColor, for: .normal)
            chartCenterLabel.text = "Нет расходов"
        }

        underlineView.snp.remakeConstraints { make in
            make.top.equalTo(tabStack.snp.bottom).offset(4)
            make.height.equalTo(4)
            if isIncome {
                make.leading.equalTo(incomeButton.snp.leading)
                make.trailing.equalTo(incomeButton.snp.trailing)
            } else {
                make.leading.equalTo(expensesButton.snp.leading)
                make.trailing.equalTo(expensesButton.snp.trailing)
            }
        }

        if animated {
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }

    func setSelectedPeriod(_ index: Int, animated: Bool = true) {
        currentPeriodIndex = index
        let buttons = [dayButton, weekButton, monthButton, yearButton]
        let selectedColor = UIColor.primary
        let deselectedColor = UIColor.gray

        buttons.enumerated().forEach { buttonIndex, button in
            button.setTitleColor(buttonIndex == index ? selectedColor : deselectedColor,
                               for: .normal)
        }

        guard let selectedButton = buttons[safe: index] else { return }
        
        periodUnderlineView.snp.remakeConstraints { make in
            make.top.equalTo(periodTabStack.snp.bottom).offset(2)
            make.leading.equalTo(selectedButton.snp.leading)
            make.trailing.equalTo(selectedButton.snp.trailing)
            make.height.equalTo(2)
        }

        if animated {
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        } else {
            layoutIfNeeded()
        }
    }

    func showLineChart() {
        guard !isLineChartVisible else { return }
        isLineChartVisible = true
        
        pieChartView.isHidden = true
        lineChartView.isHidden = false
        chartCenterLabel.isHidden = true
        chartAmountLabel.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.pieChartView.alpha = 0
            self.lineChartView.alpha = 1
            self.chartCenterLabel.alpha = 0
            self.chartAmountLabel.alpha = 1
        }
    }

    func showPieChart() {
        guard isLineChartVisible else { return }
        isLineChartVisible = false
        
        lineChartView.isHidden = true
        pieChartView.isHidden = false
        chartAmountLabel.isHidden = true
        chartCenterLabel.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.pieChartView.alpha = 1
            self.lineChartView.alpha = 0
            self.chartCenterLabel.alpha = 1
            self.chartAmountLabel.alpha = 0
        }
    }

    private func calculateBannerTotalHeight() -> CGFloat {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return 170 + statusBarHeight
    }

    private func createPieChartPath() -> UIBezierPath {
        let center = CGPoint(x: 100, y: 100)
        let radius: CGFloat = 80
        let path = UIBezierPath(arcCenter: center,
                               radius: radius,
                               startAngle: -CGFloat.pi / 2,
                               endAngle: 3 * CGFloat.pi / 2,
                               clockwise: true)
        return path
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyBottomRoundedCorners()
    }

    private func applyBottomRoundedCorners() {
        let radius: CGFloat = 20
        let path = UIBezierPath(
            roundedRect: backgroundFillView.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        backgroundFillView.layer.mask = maskLayer
    }
}

// MARK: - Cell Class
class ExpenseCell: UICollectionViewCell {
    let categoryIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .primary
        return imageView
    }()

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()

    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4

        contentView.addSubview(categoryIcon)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(dateLabel)
    }

    private func setupConstraints() {
        categoryIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryIcon.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(12)
            make.trailing.equalTo(amountLabel.snp.leading).offset(-8)
        }

        amountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(categoryLabel)
            make.width.equalTo(100)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryLabel.snp.leading)
            make.top.equalTo(categoryLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
    }

    func configure(with expense: Expense) {
        categoryIcon.image = UIImage(systemName: expense.iconName)
        categoryLabel.text = expense.category
        amountLabel.text = expense.amount
        dateLabel.text = expense.date
    }
}

// MARK: - Models
struct Expense {
    let id = UUID()
    let category: String
    let amount: String
    let date: String
    let iconName: String
}

// MARK: - Array Extension
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
