//
//  CitySearchViewController.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 27/09/1447 AH.
//
import UIKit

final class CitySearchViewController: UIViewController {
    private var searchTask: Task<Void, Never>?
    private var cities: [City] = []

    var onCitySelected: ((City) -> Void)?

    private let searchBar = UISearchBar()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let emptyLabel = UILabel()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Change City"
        view.backgroundColor = .systemBackground
        setupSearchBar()
        setupTableView()
        setupEmptyLabel()
    }

    deinit {
        searchTask?.cancel()
    }

    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search city"
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupEmptyLabel() {
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "Type a city name to search."
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.font = .systemFont(ofSize: 16)
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func search(for query: String) {
        searchTask?.cancel()

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else {
            cities = []
            tableView.reloadData()
            emptyLabel.text = "Type at least 2 letters to search."
            emptyLabel.isHidden = false
            return
        }

        activityIndicator.startAnimating()
        emptyLabel.text = "Searching..."
        emptyLabel.isHidden = false
/*
        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 350_000_000)
            guard let self, !Task.isCancelled else { return }

            do {
                let result = try await service.searchCities(query: trimmed)
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                    self.cities = result
                    self.tableView.reloadData()
                    self.emptyLabel.text = result.isEmpty ? "No cities found." : nil
                    self.emptyLabel.isHidden = !result.isEmpty
                }
            } catch {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                    self.cities = []
                    self.tableView.reloadData()
                    self.emptyLabel.text = "Search failed. Please try again."
                    self.emptyLabel.isHidden = false
                }
            }
        }
 */
        let dummyCities: [City] = [
            City(id: nil, name: "Riyadh", latitude: 24.7, longitude: 46.7, country: "SA", admin1: "Riyadh", timezone: nil),
            City(id: nil, name: "Jeddah", latitude: 21.5, longitude: 39.2, country: "SA", admin1: "Makkah", timezone: nil),
            City(id: nil, name: "Makkah", latitude: 21.4, longitude: 39.8, country: "SA", admin1: "Makkah", timezone: nil)
        ]

        self.activityIndicator.stopAnimating()

        self.cities = dummyCities.filter {
            $0.name.lowercased().contains(trimmed.lowercased())
        }

        self.tableView.reloadData()
        self.emptyLabel.isHidden = !cities.isEmpty
    }
}

extension CitySearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(for: searchText)
    }
}

extension CitySearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let city = cities[indexPath.row]
        content.text = city.name
        content.secondaryText = city.displayName
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = cities[indexPath.row]
        onCitySelected?(city)
        navigationController?.popViewController(animated: true)
    }
}

