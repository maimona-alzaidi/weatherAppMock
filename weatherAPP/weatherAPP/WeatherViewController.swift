//
//  WeatherViewController.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 19/09/1447 AH.
//
import UIKit

final class WeatherViewController: UIViewController {

    private let viewModel = WeatherViewModel()
    private enum Section: Int, CaseIterable {
        case hourly
        case daily
        case details

        var title: String {
            switch self {
            case .hourly:
                return "Hourly Forecast"
            case .daily:
                return "10-Day Forecast"
            case .details:
                return "Weather Details"
            }
        }
    }

    private let headerView = WeatherHeaderView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let detailItems: [WeatherDetailItem] = [
        WeatherDetailItem(title: "Wind", value: "12 km/h", subtitle: "Light breeze"),
        WeatherDetailItem(title: "Humidity", value: "48%", subtitle: "Comfortable"),
        WeatherDetailItem(title: "UV Index", value: "5", subtitle: "Moderate"),
        WeatherDetailItem(title: "Rain", value: "0 mm", subtitle: "No rain expected")
    ]
    private let expandedHeaderHeight: CGFloat = 220

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavigation()
        setupTableView()
        setupHeaderView()
        configureHeader()
    }

    private func setupBackground() {
        view.backgroundColor = .black
    }

    private func setupNavigation() {
        title = "Weather"
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self

        tableView.contentInset = UIEdgeInsets(top: expandedHeaderHeight, left: 0, bottom: 24, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: expandedHeaderHeight, left: 0, bottom: 0, right: 0)

       tableView.register(HourlyContainerCell.self, forCellReuseIdentifier: HourlyContainerCell.reuseIdentifier)
      tableView.register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.reuseIdentifier)
        tableView.register(DetailPairCell.self, forCellReuseIdentifier: DetailPairCell.reuseIdentifier)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: expandedHeaderHeight)
        ])
    }

    private func configureHeader() {
        headerView.configure(
            city: viewModel.cityName,
            temperature: viewModel.temperature,
            condition: viewModel.condition,
            highLow: viewModel.highLow
        
        )
    }
}

extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }

        switch sectionType {
        case .hourly:
            return 1
        case .daily:
            return 3
        case .details:
            return Int(ceil(Double(detailItems.count) / 2.0))
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch section {
        case .hourly:

            let cell = tableView.dequeueReusableCell(
                withIdentifier: HourlyContainerCell.reuseIdentifier,
                for: indexPath
            ) as! HourlyContainerCell

            let mockItems: [HourlyItemViewData] = [
                HourlyItemViewData(date: Date(), timeText: "3 PM", temperatureText: "32°", symbolName: "sun.max", precipitationText: "0%"),
                HourlyItemViewData(date: Date(), timeText: "4 PM", temperatureText: "31°", symbolName: "sun.max", precipitationText: "0%"),
                HourlyItemViewData(date: Date(), timeText: "5 PM", temperatureText: "30°", symbolName: "cloud.sun", precipitationText: "10%")
            ]

            cell.configure(items: mockItems)

            return cell

        case .daily:
        let cell = tableView.dequeueReusableCell(
        withIdentifier: DailyForecastCell.reuseIdentifier,
        for: indexPath
        ) as! DailyForecastCell

        let mockItems = [
        DailyItemViewData(
        date: Date(),
        weekdayText: "Today",
        lowText: "24°",
        highText: "36°",
        symbolName: "sun.max",
        normalizedStart: 0.2,
        normalizedEnd: 0.8
        ),
        DailyItemViewData(
        date: Date().addingTimeInterval(86400),
        weekdayText: "Tue",
        lowText: "22°",
        highText: "34°",
        symbolName: "cloud.sun",
        normalizedStart: 0.3,
        normalizedEnd: 0.7
        ),
        DailyItemViewData(
        date: Date().addingTimeInterval(172800),
        weekdayText: "Wed",
        lowText: "20°",
        highText: "30°",
        symbolName: "cloud.rain",
        normalizedStart: 0.4,
        normalizedEnd: 0.6
        )
        ]

            cell.configure(with: mockItems[indexPath.row])
        return cell
            
        case .details:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailPairCell.reuseIdentifier,
                for: indexPath
            ) as! DetailPairCell

            let firstIndex = indexPath.row * 2
            let left = detailItems[firstIndex]
            let right = (firstIndex + 1 < detailItems.count) ? detailItems[firstIndex + 1] : nil

            cell.configure(left: left, right: right)
            return cell
        }
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = Section(rawValue: section) else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier) as! SectionHeaderView
        header.configure(title: sectionType.title)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return 44 }

        switch section {
        case .hourly:
            return 160
        case .daily:
            return 72
        case .details:
            return 144
        }
    }
}
