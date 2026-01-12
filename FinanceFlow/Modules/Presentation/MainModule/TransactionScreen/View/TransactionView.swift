import UIKit
import SnapKit

protocol TransactionViewDelegate: AnyObject {
    func didBackButtonTapped()
    func didDeleteButtonTapped()
}

class TransactionView: UIView {

    private lazy var customNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()

    private lazy var navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Детали транзакции"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        return view
    }()

    private let amountStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .label
        return label
    }()

    lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .label
        return label
    }()

    private let categoryContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 12
        return view
    }()

    private let categoryStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()

    private let categoryIconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()

    lazy var categoryIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let dateContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 12
        return view
    }()

    private let dateStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    private let dateIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        return label
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить транзакцию", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 12
        return button
    }()

    weak var delegate: TransactionViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .background

        addSubview(customNavBar)
        addSubview(contentScrollView)
        contentScrollView.addSubview(contentView)

        customNavBar.addSubview(backButton)
        customNavBar.addSubview(navTitleLabel)

        contentView.addSubview(amountStackView)
        amountStackView.addArrangedSubview(amountLabel)
        amountStackView.addArrangedSubview(currencyLabel)

        contentView.addSubview(categoryContainerView)
        categoryContainerView.addSubview(categoryStackView)

        categoryIconContainer.addSubview(categoryIconImageView)
        categoryStackView.addArrangedSubview(categoryIconContainer)
        categoryStackView.addArrangedSubview(categoryNameLabel)
        categoryStackView.addArrangedSubview(UIView())

        contentView.addSubview(dateContainerView)
        dateContainerView.addSubview(dateStackView)

        dateStackView.addArrangedSubview(dateIconImageView)
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(UIView())

        contentView.addSubview(deleteButton)
    }

    private func setupConstraints() {
        customNavBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(calculateCustomNavBarTotalHeight())
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.size.equalTo(44)
        }

        navTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }

        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        amountStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
        }

        categoryContainerView.snp.makeConstraints { make in
            make.top.equalTo(amountStackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        categoryStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        categoryIconContainer.snp.makeConstraints { make in
            make.size.equalTo(40)
        }

        categoryIconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(24)
        }

        dateContainerView.snp.makeConstraints { make in
            make.top.equalTo(categoryContainerView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }

        dateStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        dateIconImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }

        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(dateContainerView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(32)
        }
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }

    @objc private func backButtonTapped() {
        delegate?.didBackButtonTapped()
    }

    @objc private func deleteButtonTapped() {
        delegate?.didDeleteButtonTapped()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyBottomRoundedCorners()
    }

    private func applyBottomRoundedCorners() {
        let radius: CGFloat = 20
        let path = UIBezierPath(
            roundedRect: customNavBar.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        customNavBar.layer.mask = maskLayer
    }

    private func calculateCustomNavBarTotalHeight() -> CGFloat {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return statusBarHeight + 70
    }

    func configure(with state: TransactionViewState) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        amountLabel.text = formatter.string(from: NSNumber(value: state.amount))
        currencyLabel.text = state.currencySign
        categoryNameLabel.text = state.categoryName
        categoryIconContainer.backgroundColor = UIColor(hexData: state.categoryColor)
        categoryIconImageView.image = UIImage(data: state.categoryIcon)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateLabel.text = dateFormatter.string(from: state.date)
    }
}

extension UIColor {
    static func fromData(_ data: Data) -> UIColor? {
        guard data.count == 4 else { return nil }
        let rgba = [UInt8](data)
        return UIColor(
            red: CGFloat(rgba[0]) / 255.0,
            green: CGFloat(rgba[1]) / 255.0,
            blue: CGFloat(rgba[2]) / 255.0,
            alpha: CGFloat(rgba[3]) / 255.0
        )
    }
}

struct TransactionViewState {
    let amount: Double
    let currencySign: String
    let categoryName: String
    let categoryIcon: Data
    let categoryColor: Data
    let date: Date
}
