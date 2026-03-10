//
//  HourlyForecastCell.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 21/09/1447 AH.
//
import UIKit

final class HourlyForecastCell: UICollectionViewCell {
    static let reuseIdentifier = "HourlyForecastCell"

    private let timeLabel = UILabel()
    private let iconView = UIImageView()
    private let temperatureLabel = UILabel()
    private let precipitationLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: HourlyItemViewData) {
        timeLabel.text = item.timeText
        iconView.image = UIImage(systemName: item.symbolName)
        temperatureLabel.text = item.temperatureText
        precipitationLabel.text = item.precipitationText
    }

    private func setupView() {
        contentView.backgroundColor = .clear

        let stackView = UIStackView(arrangedSubviews: [timeLabel, iconView, temperatureLabel, precipitationLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        timeLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        timeLabel.textColor = .white

        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        iconView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        iconView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 26).isActive = true

        temperatureLabel.font = .systemFont(ofSize: 20, weight: .bold)
        temperatureLabel.textColor = .white

        precipitationLabel.font = .systemFont(ofSize: 12, weight: .medium)
        precipitationLabel.textColor = UIColor(red: 0.55, green: 0.86, blue: 1.0, alpha: 1)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}

