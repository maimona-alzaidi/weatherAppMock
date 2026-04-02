//
//  DetailPairCell.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 22/09/1447 AH.

import UIKit

final class DetailPairCell: UITableViewCell {
    static let reuseIdentifier = "DetailPairCell"

    private let horizontalStack = UIStackView()
    private let leftCard = WeatherMetricCardView()
    private let rightCard = WeatherMetricCardView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(left: WeatherDetailItem, right: WeatherDetailItem?) {
        leftCard.configure(with: left)
        if let right {
            rightCard.isHidden = false
            rightCard.configure(with: right)
        } else {
            rightCard.isHidden = true
        }
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 12
        horizontalStack.distribution = .fillEqually
        contentView.addSubview(horizontalStack)

        horizontalStack.addArrangedSubview(leftCard)
        horizontalStack.addArrangedSubview(rightCard)

        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            leftCard.heightAnchor.constraint(equalToConstant: 132)
        ])
    }
    
}
