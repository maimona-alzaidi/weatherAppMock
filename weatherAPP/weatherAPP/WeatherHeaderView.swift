//
//  WeatherHeaderView.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 20/09/1447 AH.
//
import UIKit

final class WeatherHeaderView: UIView {
    private let stackView = UIStackView()
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let conditionLabel = UILabel()
    private let highLowLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(city: String, temperature: String, condition: String, highLow: String) {
        cityLabel.text = city
        temperatureLabel.text = temperature
        conditionLabel.text = condition
        highLowLabel.text = highLow
    }
    func apply(progress: CGFloat) {
        let clamped = max(0, min(1, progress))

        let cityScale = 1 - (0.22 * clamped)
        let tempScale = 1 - (0.35 * clamped)

        cityLabel.transform = CGAffineTransform(scaleX: cityScale, y: cityScale)
            .translatedBy(x: 0, y: -12 * clamped)
        temperatureLabel.transform = CGAffineTransform(scaleX: tempScale, y: tempScale)
            .translatedBy(x: 0, y: -18 * clamped)
        conditionLabel.alpha = 1 - clamped
        highLowLabel.alpha = 1 - clamped
    }

    private func setupView() {
        backgroundColor = .clear

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        cityLabel.font = .systemFont(ofSize: 34, weight: .medium)
        cityLabel.textColor = .white
        cityLabel.textAlignment = .center
        cityLabel.numberOfLines = 2

        temperatureLabel.font = .systemFont(ofSize: 82, weight: .thin)
        temperatureLabel.textColor = .white
        temperatureLabel.textAlignment = .center

        conditionLabel.font = .systemFont(ofSize: 22, weight: .medium)
        conditionLabel.textColor = .white.withAlphaComponent(0.95)
        conditionLabel.textAlignment = .center

        highLowLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        highLowLabel.textColor = .white.withAlphaComponent(0.95)
        highLowLabel.textAlignment = .center

        [cityLabel, temperatureLabel, conditionLabel, highLowLabel].forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20)
        ])
    }
}
