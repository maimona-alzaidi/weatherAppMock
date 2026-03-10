//
//  WeatherHeaderView.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 20/09/1447 AH.
//
import UIKit

final class WeatherHeaderView: UIView {

    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let conditionLabel = UILabel()
    private let highLowLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        cityLabel.font = .systemFont(ofSize: 28, weight: .bold)
        cityLabel.textAlignment = .center
        cityLabel.textColor = .white

        temperatureLabel.font = .systemFont(ofSize: 52, weight: .thin)
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = .white

        conditionLabel.font = .systemFont(ofSize: 20, weight: .medium)
        conditionLabel.textAlignment = .center
        conditionLabel.textColor = .white

        highLowLabel.font = .systemFont(ofSize: 16, weight: .regular)
        highLowLabel.textAlignment = .center
        highLowLabel.textColor = .lightGray

        let stack = UIStackView(arrangedSubviews: [
            cityLabel,
            temperatureLabel,
            conditionLabel,
            highLowLabel
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    func configure(city: String, temperature: String, condition: String, highLow: String) {
        cityLabel.text = city
        temperatureLabel.text = temperature
        conditionLabel.text = condition
        highLowLabel.text = highLow
    }
}
