//
//  DayPickerViewController.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 14/10/1447 AH.
//
import UIKit

final class DayPickerViewController: UIViewController {
    private let datePicker = UIDatePicker()
    private let doneButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let minimumDate: Date
    private let maximumDate: Date
    private let initialDate: Date
    private let onSelect: (Date) -> Void

    init(minimumDate: Date, maximumDate: Date, initialDate: Date, onSelect: @escaping (Date) -> Void) {
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.initialDate = initialDate
        self.onSelect = onSelect
        super.init(nibName: nil, bundle: nil)

        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.text = "Select a day"

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .systemFont(ofSize: 15)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = "Choose a date to show the weather summary for that day."

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        datePicker.date = initialDate

        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Show Summary", for: .normal)
        doneButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        doneButton.backgroundColor = .systemBlue
        doneButton.tintColor = .white
        doneButton.layer.cornerRadius = 14
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(datePicker)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            datePicker.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    @objc private func doneTapped() {
        dismiss(animated: true) { [onSelect, date = datePicker.date] in
            onSelect(date)
        }
    }
}

