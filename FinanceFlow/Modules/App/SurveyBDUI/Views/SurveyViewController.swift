//
//  SurveyViewController.swift
//  FinanceFlow
//
//  Created by Павел Калинин on 07.01.2026.
//
import UIKit
import SnapKit
import Domain

final class SurveyViewController: UIViewController {

    private let dto: SurveyPageDTO
    private let starView: StarRatingView
    private let commentView: CommentInputView?
    private let submitButton = UIButton(type: .system)
    
    var presenter: SurveyBDUIPresenterProtocol?

    init(dto: SurveyPageDTO) {
        self.dto = dto
        self.starView = StarRatingView(maxStars: dto.rating.maxStars)
        self.commentView = dto.comment.enabled
            ? CommentInputView(placeholder: dto.comment.placeholder)
            : nil
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismissal()
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true

        let titleLabel = UILabel()
        titleLabel.text = dto.title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        submitButton.setTitle(dto.submitButton.title, for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        submitButton.backgroundColor = UIColor.primary
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 12
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)

        var mainSubviews: [UIView] = [titleLabel, starView]
        if let commentView = commentView {
            mainSubviews.append(commentView)
        }

        let stackView = UIStackView(arrangedSubviews: mainSubviews)
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let contentStack = UIStackView(arrangedSubviews: [stackView, submitButton])
        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentStack)

        contentStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

    @objc private func submit() {
        guard let identifier = UIDevice.current.identifierForVendor else { return }

        let comment = commentView?.text == commentView?.placeholderText
            ? nil
            : commentView?.text

        let result = SurveyResult(
            surveyId: dto.id,
            deviceId: identifier.uuidString,
            rating: starView.rating,
            comment: comment
        )
        
        if starView.rating != 0 {
            presenter?.sendResult(result)
            dismiss(animated: true)
        }
    }
}
