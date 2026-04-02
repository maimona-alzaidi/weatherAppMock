//
//  DailyForecastCell.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 21/09/1447 AH.
//
import UIKit

final class DailyForecastCell: UITableViewCell {
    static let reuseIdentifier = "DailyForecastCell"

    private let cardView = UIView()
    private let dayLabel = UILabel()
    private let iconView = UIImageView()
    private let lowLabel = UILabel()
    private let highLabel = UILabel()
    private let rangeTrackView = UIView()
    private let rangeFillView = UIView()
    private var fillLeadingConstraint: NSLayoutConstraint?
    private var fillWidthConstraint: NSLayoutConstraint?
    private var pendingStart: CGFloat = 0
    private var pendingEnd: CGFloat = 1

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cardView.layer.cornerRadius = 20
        applyRangeLayout()
    }

    func configure(with item: DailyItemViewData) {
        dayLabel.text = item.weekdayText
        iconView.image = UIImage(systemName: item.symbolName)
        lowLabel.text = item.lowText
        highLabel.text = item.highText
        pendingStart = max(0, min(1, item.normalizedStart))
        pendingEnd = max(0, min(1, item.normalizedEnd))
        setNeedsLayout()
    }

    private func applyRangeLayout() {
        let trackWidth = max(rangeTrackView.bounds.width, 1)
        fillLeadingConstraint?.constant = trackWidth * pendingStart
        fillWidthConstraint?.constant = max(trackWidth * (pendingEnd - pendingStart), 10)
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        contentView.addSubview(cardView)

        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        dayLabel.textColor = .white

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        iconView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)

        lowLabel.translatesAutoresizingMaskIntoConstraints = false
        lowLabel.font = .systemFont(ofSize: 17, weight: .medium)
        lowLabel.textColor = .white.withAlphaComponent(0.82)

        highLabel.translatesAutoresizingMaskIntoConstraints = false
        highLabel.font = .systemFont(ofSize: 17, weight: .bold)
        highLabel.textColor = .white

        rangeTrackView.translatesAutoresizingMaskIntoConstraints = false
        rangeTrackView.backgroundColor = UIColor.white.withAlphaComponent(0.20)
        rangeTrackView.layer.cornerRadius = 3
        rangeTrackView.clipsToBounds = true

        rangeFillView.translatesAutoresizingMaskIntoConstraints = false
        rangeFillView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.95)
        rangeFillView.layer.cornerRadius = 3
        rangeTrackView.addSubview(rangeFillView)

        cardView.addSubview(dayLabel)
        cardView.addSubview(iconView)
        cardView.addSubview(lowLabel)
        cardView.addSubview(rangeTrackView)
        cardView.addSubview(highLabel)

        fillLeadingConstraint = rangeFillView.leadingAnchor.constraint(equalTo: rangeTrackView.leadingAnchor)
        fillWidthConstraint = rangeFillView.widthAnchor.constraint(equalToConstant: 40)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            dayLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            dayLabel.widthAnchor.constraint(equalToConstant: 90),

            iconView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 12),
            iconView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            lowLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            lowLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            lowLabel.widthAnchor.constraint(equalToConstant: 40),

            rangeTrackView.leadingAnchor.constraint(equalTo: lowLabel.trailingAnchor, constant: 12),
            rangeTrackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            rangeTrackView.heightAnchor.constraint(equalToConstant: 6),

            highLabel.leadingAnchor.constraint(equalTo: rangeTrackView.trailingAnchor, constant: 12),
            highLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            highLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            highLabel.widthAnchor.constraint(equalToConstant: 40),

            fillLeadingConstraint!,
            rangeFillView.topAnchor.constraint(equalTo: rangeTrackView.topAnchor),
            rangeFillView.bottomAnchor.constraint(equalTo: rangeTrackView.bottomAnchor),
            fillWidthConstraint!,

            rangeTrackView.trailingAnchor.constraint(equalTo: highLabel.leadingAnchor, constant: -12)
        ])
    }
}
