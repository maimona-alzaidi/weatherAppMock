//
//  WeatherMetricCardView.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 22/09/1447 AH.
//
import UIKit

final class WeatherMetricCardView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: WeatherDetailItem) {
        titleLabel.text = item.title.uppercased()
        valueLabel.text = item.value
        subtitleLabel.text = item.subtitle
    }

    private func setupView() {
        backgroundColor = UIColor.white.withAlphaComponent(0.12)
        layer.cornerRadius = 22
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        clipsToBounds = true

        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        titleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = .white.withAlphaComponent(0.72)

        valueLabel.font = .systemFont(ofSize: 28, weight: .medium)
        valueLabel.textColor = .white
        valueLabel.numberOfLines = 2

        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .white.withAlphaComponent(0.85)
        subtitleLabel.numberOfLines = 0

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
}

