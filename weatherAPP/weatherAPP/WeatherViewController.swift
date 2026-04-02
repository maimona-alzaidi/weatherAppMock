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
    private let viewModel: WeatherViewModel
    private var screenData: WeatherScreenData?
    
    private let backgroundView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let headerView = WeatherHeaderView()
    private let stateView = StateView()
    
    private var headerHeightConstraint: NSLayoutConstraint!
    private var didApplyInitialOffset = false
    
    private let expandedHeaderHeight: CGFloat = 240
    private let collapsedHeaderHeight: CGFloat = 96
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavigation()
        setupTableView()
        setupHeaderView()
        setupStateView()
        bindViewModel()
        viewModel.loadWeather()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        
        if !didApplyInitialOffset {
            tableView.setContentOffset(CGPoint(x: 0, y: -tableView.adjustedContentInset.top), animated: false)
            didApplyInitialOffset = true
        }
    }
    
    private func setupBackground() {
        view.backgroundColor = .black
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        backgroundView.pinToEdges(of: view)
        
        gradientLayer.colors = WeatherGradientProvider.colors(isDay: true)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        backgroundView.layer.addSublayer(gradientLayer)
    }
    
    private func setupNavigation() {
        title = "Weather"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(changeCityTapped)
        )
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
        tableView.pinToEdges(of: view)
    }
    
    private func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: expandedHeaderHeight)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerHeightConstraint
        ])
    }
    private func setupStateView() {
        stateView.translatesAutoresizingMaskIntoConstraints = false
        stateView.isHidden = true
        stateView.onRetry = { [weak self] in
            self?.viewModel.loadWeather()
        }
        view.addSubview(stateView)
        stateView.pinToEdges(of: view)
    }
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .idle:
                break
            case .loading:
                self.stateView.showLoading(message: "Fetching weather for \(self.viewModel.selectedCity.name)...")
            case .loaded(let data):
                self.screenData = data
                self.headerView.configure(
                    city: data.cityName,
                    temperature: data.currentTemperatureText,
                    condition: data.conditionText,
                    highLow: data.highLowText
                )
                self.stateView.isHidden = true
                self.updateBackground(isDay: data.isDay)
                self.tableView.reloadData()
            case .error(let message):
                self.stateView.showError(message: message)
            }
        }
    }
    private func updateBackground(isDay: Bool) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.35)
        gradientLayer.colors = WeatherGradientProvider.colors(isDay: isDay)
        CATransaction.commit()
    }
    
    @objc private func changeCityTapped() {
        let searchVC = CitySearchViewController()
        searchVC.onCitySelected = { [weak self] city in
            self?.didApplyInitialOffset = false
            self?.tableView.setContentOffset(CGPoint(x: 0, y: -(self?.tableView.adjustedContentInset.top ?? 0)), animated: false)
            self?.viewModel.updateCity(city)
        }
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func presentDayPicker(initialDate: Date?) {
        guard
            let response = viewModel.latestResponse,
            let firstDateString = response.daily.time.first,
            let lastDateString = response.daily.time.last,
            let minDate = WeatherDateFormatter.dailyDate(from: firstDateString, timezoneID: response.timezone),
            let maxDate = WeatherDateFormatter.dailyDate(from: lastDateString, timezoneID: response.timezone)
        else {
            return
        }
        
        let chosenInitialDate = initialDate ?? minDate
        let pickerVC = DayPickerViewController(
            minimumDate: minDate,
            maximumDate: maxDate,
            initialDate: chosenInitialDate
        ) { [weak self] selectedDate in
            self?.showDaySummary(for: selectedDate)
        }
        present(pickerVC, animated: true)
    }
    
    private func showDaySummary(for date: Date) {
        let summary = viewModel.daySummary(for: date)
        let alert = UIAlertController(
            title: summary?.title ?? "No data",
            message: summary?.message ?? "Weather data is not available for that date.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func detailItemPair(for row: Int) -> (WeatherDetailItem, WeatherDetailItem?)? {
        guard let items = screenData?.detailItems else { return nil }
        
        let firstIndex = row * 2
        guard firstIndex < items.count else { return nil }
        
        let left = items[firstIndex]
        let right = (firstIndex + 1) < items.count ? items[firstIndex + 1] : nil
        return (left, right)
    }
    
}
    extension WeatherViewController: UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            Section.allCases.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard let sectionType = Section(rawValue: section), let data = screenData else { return 0 }
            switch sectionType {
            case .hourly:
                return data.hourlyItems.isEmpty ? 0 : 1
                
            case .daily:
                return data.dailyItems.count
                
            case .details:
                return Int(ceil(Double(data.detailItems.count) / 2.0))
            }
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            guard let section = Section(rawValue: indexPath.section),
                  let data = screenData else {
                return UITableViewCell()
            }
            
            switch section {
            case .hourly:
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: HourlyContainerCell.reuseIdentifier,
                    for: indexPath
                ) as! HourlyContainerCell
                cell.configure(items: data.hourlyItems)
                cell.onItemSelected = { [weak self] date in
                    self?.presentDayPicker(initialDate: date)
                }
                return cell
                
            case .daily:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: DailyForecastCell.reuseIdentifier,
                    for: indexPath
                ) as! DailyForecastCell
                cell.configure(with: data.dailyItems[indexPath.row])
                return cell
                
            case .details:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: DetailPairCell.reuseIdentifier,
                    for: indexPath
                ) as! DetailPairCell
                if let pair = detailItemPair(for: indexPath.row) {
                    cell.configure(left: pair.0, right: pair.1)
                }
                return cell
            }
        }
    }
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = Section(rawValue: section), numberOfRows(in: sectionType) > 0 else { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier) as! SectionHeaderView
        header.configure(title: sectionType.title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = Section(rawValue: section), numberOfRows(in: sectionType) > 0 else { return 0.01 }
        return 34
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = Section(rawValue: indexPath.section), let data = screenData else { return }
        switch section {
        case .hourly:
            let fallbackDate = data.hourlyItems.first?.date
            presentDayPicker(initialDate: fallbackDate)
        case .daily:
            presentDayPicker(initialDate: data.dailyItems[indexPath.row].date)
        case .details:
            presentDayPicker(initialDate: data.dailyItems.first?.date)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        let collapseRange = expandedHeaderHeight - collapsedHeaderHeight
        
        if offsetY < 0 {
            headerHeightConstraint.constant = expandedHeaderHeight - offsetY
        } else {
            headerHeightConstraint.constant = max(collapsedHeaderHeight, expandedHeaderHeight - offsetY)
        }
        
        let progress = min(max(offsetY / collapseRange, 0), 1)
        headerView.apply(progress: progress)
    }
    
    private func numberOfRows(in section: Section) -> Int {
        guard let data = screenData else { return 0 }
        switch section {
        case .hourly:
            return data.hourlyItems.isEmpty ? 0 : 1
        case .daily:
            return data.dailyItems.count
        case .details:
            return Int(ceil(Double(data.detailItems.count) / 2.0))
        }
    }
}
