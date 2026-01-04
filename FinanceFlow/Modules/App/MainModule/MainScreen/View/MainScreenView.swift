import UIKit
import SnapKit
import DGCharts

// MARK: - Delegate
protocol MainScreenViewDelegate: AnyObject {
    func didTapSelectDate()
    func navigatePeriodBackward()
    func navigatePeriodForward()
    func periodTypeChanged(to index: Int)
    func didTapIncome()
    func didTapExpense()
}

class MainScreenView: UIView {
    // MARK: - Existing Properties
    private lazy var backgroundFillView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        view.clipsToBounds = false
        return view
    }()

    private lazy var contentContainer: UIView = {
        let view = UIView()
        return view
    }()

    lazy var budgetLabel: UILabel = {
        let label = UILabel()
        label.text = "Бюджет"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "12 500"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    lazy var expensesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Расходы", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    lazy var incomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Доходы", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    private lazy var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var tabStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 16
        return stack
    }()

    // MARK: - Chart Properties
    lazy var statsContainer: UIView = {
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

    lazy var periodTabStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()

    lazy var dayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("День", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    lazy var weekButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Неделя", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    lazy var monthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Месяц", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    lazy var yearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Год", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    lazy var periodUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        return view
    }()

    // MARK: - Period Navigation (под underline, над графиком)
    lazy var periodNavigationStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    lazy var periodLeftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .primary
        return button
    }()

    lazy var periodLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.text = "Сегодня"
        return label
    }()

    lazy var periodRightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .primary
        return button
    }()

    // MARK: - Chart Views
    lazy var pieChartView: PieChartView = {
        let chart = PieChartView()
        chart.holeColor = .clear
        chart.transparentCircleColor = .clear
        chart.holeRadiusPercent = 0.7
        chart.drawHoleEnabled = true
        chart.rotationEnabled = false
        chart.highlightPerTapEnabled = false
        chart.legend.enabled = false
        chart.drawEntryLabelsEnabled = false
        chart.noDataFont = .systemFont(ofSize: 14)
        chart.noDataTextColor = .gray
        return chart
    }()

    lazy var barChartContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()

    lazy var chartCenterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    lazy var chartAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "₽0"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    lazy var addButton: UIButton = {
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
    
    var statsContainerHeightConstraint: Constraint?
    var isLineChartVisible = false
    var isIncomeSelected = false
    var currentPeriodIndex = 0
    
    private var barLayers: [CAShapeLayer] = []
    private var currentBarData: [(value: Double, color: UIColor, label: String)] = []

    // MARK: - Delegate
    weak var delegate: MainScreenViewDelegate?

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
        backgroundColor = .background

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
        statsContainer.addSubview(periodNavigationStack)
        statsContainer.addSubview(pieChartView)
        statsContainer.addSubview(barChartContainer)
        statsContainer.addSubview(chartCenterLabel)
        statsContainer.addSubview(chartAmountLabel)
        statsContainer.addSubview(addButton)

        periodNavigationStack.addArrangedSubview(periodLeftButton)
        periodNavigationStack.addArrangedSubview(periodLabel)
        periodNavigationStack.addArrangedSubview(periodRightButton)
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
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }

        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(budgetLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        tabStack.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(8)
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
            statsContainerHeightConstraint = make.height.equalTo(320).constraint
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
            make.height.equalTo(2)
        }

        periodNavigationStack.snp.makeConstraints { make in
            make.top.equalTo(periodUnderlineView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }

        pieChartView.snp.makeConstraints { make in
            make.top.equalTo(periodNavigationStack.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }

        barChartContainer.snp.makeConstraints { make in
            make.top.equalTo(periodNavigationStack.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }

        chartCenterLabel.snp.makeConstraints { make in
            make.center.equalTo(pieChartView)
            make.leading.trailing.equalTo(pieChartView).inset(20)
        }

        chartAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(barChartContainer.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
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

        periodLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(periodLabelTapped))
        periodLabel.addGestureRecognizer(tapGesture)

        periodLeftButton.addTarget(self, action: #selector(periodLeftTapped), for: .touchUpInside)
        periodRightButton.addTarget(self, action: #selector(periodRightTapped), for: .touchUpInside)
    }

    // MARK: - Horizontal Bar Chart
    private func createHorizontalBarChart(_ data: [(value: Double, color: UIColor, label: String)]) {
        barLayers.forEach { $0.removeFromSuperlayer() }
        barLayers.removeAll()
        
        let total = data.reduce(0) { $0 + $1.value }
        let width = barChartContainer.bounds.width
        let height = barChartContainer.bounds.height
        
        if total == 0 || width == 0 { return }
        
        var currentX: CGFloat = 0
        for (index, segment) in data.enumerated() {
            let segmentWidth = CGFloat(segment.value / total) * width
            let rect = CGRect(x: currentX, y: 0, width: segmentWidth, height: height)
            let path = UIBezierPath(roundedRect: rect,
                                  byRoundingCorners: getCornersForSegment(at: index, total: data.count),
                                  cornerRadii: CGSize(width: 8, height: 8)).cgPath
            
            let layer = CAShapeLayer()
            layer.path = path
            layer.fillColor = segment.color.cgColor
            layer.strokeColor = UIColor.white.cgColor
            layer.lineWidth = 1
            
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = UIBezierPath(rect: CGRect(x: currentX, y: height/2, width: 0, height: 0)).cgPath
            animation.toValue = path
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            layer.add(animation, forKey: "pathAnimation")
            
            barChartContainer.layer.addSublayer(layer)
            barLayers.append(layer)
            currentX += segmentWidth
        }
    }
    
    private func getCornersForSegment(at index: Int, total: Int) -> UIRectCorner {
        if total == 1 { return [.allCorners] }
        if index == 0 { return [.topLeft, .bottomLeft] }
        if index == total - 1 { return [.topRight, .bottomRight] }
        return []
    }

    // MARK: - Public Methods for Chart Updates
    func updatePieChartData(entries: [PieChartDataEntry], colors: [UIColor]? = nil) {
        var processedEntries = entries
        var processedColors = colors ?? [.systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemRed]
        
        if entries.isEmpty {
            processedEntries = [PieChartDataEntry(value: 1, label: "")]
            processedColors = [.systemGray5]
        }

        let set = PieChartDataSet(entries: processedEntries, label: "")
        set.colors = processedColors
        set.drawValuesEnabled = false
        set.sliceSpace = 2
        set.selectionShift = 5

        let data = PieChartData(dataSet: set)
        pieChartView.data = data
        
        currentBarData = processedEntries.enumerated().map { index, entry in
            (value: entry.value, color: set.colors[index], label: entry.label ?? "")
        }
        createHorizontalBarChart(currentBarData)
        pieChartView.notifyDataSetChanged()
        
        // Обновляем центральный текст
        if entries.isEmpty {
            pieChartView.centerAttributedText = NSAttributedString(
                string: isIncomeSelected ? "Нет доходов" : "Нет расходов",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                    .foregroundColor: UIColor.gray
                ]
            )
        } else {
            let total = entries.reduce(0) { $0 + $1.value }
            let centerText = "\(Int(total))"
            pieChartView.centerAttributedText = NSAttributedString(
                string: centerText,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.gray
                ]
            )
        }
    }

    func updateChartForPeriod(_ periodIndex: Int) {
    }

    // MARK: - Actions (forward to delegate)
    @objc private func expensesButtonTapped() {
        setSelectedTab(false)
        delegate?.didTapExpense()
    }
    @objc private func incomeButtonTapped() {
        setSelectedTab(true)
        delegate?.didTapIncome()
    }
    
    @objc private func dayButtonTapped() { delegate?.periodTypeChanged(to: 0) }
    @objc private func weekButtonTapped() { delegate?.periodTypeChanged(to: 1) }
    @objc private func monthButtonTapped() { delegate?.periodTypeChanged(to: 2) }
    @objc private func yearButtonTapped() { delegate?.periodTypeChanged(to: 3) }

    @objc private func periodLabelTapped() { delegate?.didTapSelectDate() }
    @objc private func periodLeftTapped() { delegate?.navigatePeriodBackward() }
    @objc private func periodRightTapped() { delegate?.navigatePeriodForward() }

    // MARK: - Public Methods
    func setSelectedTab(_ isIncome: Bool, animated: Bool = true) {
        guard isIncome != isIncomeSelected else { return }
        isIncomeSelected = isIncome

        let selectedColor = UIColor.white
        let deselectedColor = UIColor.white.withAlphaComponent(0.6)

        if isIncome {
            incomeButton.setTitleColor(selectedColor, for: .normal)
            expensesButton.setTitleColor(deselectedColor, for: .normal)
        } else {
            expensesButton.setTitleColor(selectedColor, for: .normal)
            incomeButton.setTitleColor(deselectedColor, for: .normal)
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
            UIView.animate(withDuration: 0.25) { self.layoutIfNeeded() }
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
            button.setTitleColor(buttonIndex == index ? selectedColor : deselectedColor, for: .normal)
        }

        guard let selectedButton = buttons[safe: index] else { return }
        
        periodUnderlineView.snp.remakeConstraints { make in
            make.top.equalTo(periodTabStack.snp.bottom).offset(2)
            make.leading.equalTo(selectedButton.snp.leading)
            make.trailing.equalTo(selectedButton.snp.trailing)
            make.height.equalTo(2)
        }

        if animated {
            UIView.animate(withDuration: 0.25) { self.layoutIfNeeded() }
        } else {
            layoutIfNeeded()
        }
    }

    func showLineChart() {
        guard !isLineChartVisible else { return }
        isLineChartVisible = true
        
        pieChartView.isHidden = true
        barChartContainer.isHidden = false
        chartCenterLabel.isHidden = true
        statsContainerHeightConstraint?.update(offset: 210)
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        createHorizontalBarChart(currentBarData)
        UIView.animate(withDuration: 0.3) {
            self.pieChartView.alpha = 0
            self.barChartContainer.alpha = 1
            self.chartCenterLabel.alpha = 0
        }
    }

    func showPieChart() {
        guard isLineChartVisible else { return }
        isLineChartVisible = false
        
        barChartContainer.isHidden = true
        pieChartView.isHidden = false
        chartCenterLabel.isHidden = false
        statsContainerHeightConstraint?.update(offset: 320)
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            self.pieChartView.alpha = 1
            self.barChartContainer.alpha = 0
            self.chartCenterLabel.alpha = 1
        }
    }

    private func calculateBannerTotalHeight() -> CGFloat {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return 150 + statusBarHeight
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyBottomRoundedCorners()
        if !barChartContainer.isHidden {
            createHorizontalBarChart(currentBarData)
        }
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

// MARK: - Delegate Extension
extension MainScreenView {
    // Делегат теперь сообщает о смене типа периода
}

// MARK: - Array Extension
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
