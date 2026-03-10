//
//  WeatherViewController.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 19/09/1447 AH.
//
import UIKit

final class WeatherViewController: UIViewController {

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
            city: "Riyadh",
            temperature: "32°",
            condition: "Sunny",
            highLow: "H: 36°  L: 24°"
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
            return 2
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
            return cell

        case .daily:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DailyForecastCell.reuseIdentifier,
                for: indexPath
            ) as! DailyForecastCell
            return cell
            
        case .details:
            return UITableViewCell()
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
