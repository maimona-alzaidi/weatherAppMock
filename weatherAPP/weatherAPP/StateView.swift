//
//  StateView.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 12/10/1447 AH.
//
import UIKit

final class StateView: UIView {
    private let stackView = UIStackView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)

    var onRetry: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showLoading(message: String) {
        isHidden = false
        activityIndicator.startAnimating()
        titleLabel.text = "Loading"
        messageLabel.text = message
        retryButton.isHidden = true
    }

    func showError(message: String) {
        isHidden = false
        activityIndicator.stopAnimating()
        titleLabel.text = "Something went wrong"
        messageLabel.text = message
        retryButton.isHidden = false
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.15)

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white

        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.textColor = .white.withAlphaComponent(0.9)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        retryButton.setTitle("Retry", for: .normal)
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.backgroundColor = UIColor.white.withAlphaComponent(0.16)
        retryButton.layer.cornerRadius = 12
        retryButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 18, bottom: 12, right: 18)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)

        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(retryButton)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }

    @objc private func retryTapped() {
        onRetry?()
    }
}

