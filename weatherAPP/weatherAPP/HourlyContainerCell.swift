//
//  HourlyContainerCell.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 21/09/1447 AH.
//

import UIKit

final class HourlyContainerCell: UITableViewCell {
    static let reuseIdentifier = "HourlyContainerCell"

    private var items: [HourlyItemViewData] = []
    var onItemSelected: ((Date) -> Void)?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 84, height: 130)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: HourlyForecastCell.reuseIdentifier)
        return collectionView
    }()

    private let cardView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(items: [HourlyItemViewData]) {
        self.items = items
        collectionView.reloadData()
    }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        cardView.layer.cornerRadius = 24
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        contentView.addSubview(cardView)
        cardView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            collectionView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            collectionView.heightAnchor.constraint(equalToConstant: 132)
        ])
    }
}

extension HourlyContainerCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCell.reuseIdentifier, for: indexPath) as! HourlyForecastCell
        cell.configure(with: items[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onItemSelected?(items[indexPath.item].date)
    }
}

