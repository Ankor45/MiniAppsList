//
//  WeatherMiniApp.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 08.09.2024.
//

import UIKit

class WeatherMiniApp: UIViewController {
    // MARK: - Properties
    private let city: Citys
    private let titleLabel = UILabel()
    private let segmentController = UISegmentedControl()
    private let subTitleLabel = UILabel()
    private var weather: WeatherModel?
    // MARK: - Init
    init(city: Citys, weather: WeatherModel? = nil) {
        self.city = city
        self.weather = weather
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeather()
    }
    //MARK: - Methods
    private func fetchWeather() {
        APIWeatherColler.shared.getWeather(for: city) { [weak self] result in
            self?.weather = result
            DispatchQueue.main.async {
                self?.setupLayout()
            }
        }
    }
    @objc private func changeSegment() {
        guard let weather else { return }
        
        let index = segmentController.selectedSegmentIndex
        switch index {
        case 0:
            subTitleLabel.text = "Температура воздуха \(weather.current.heatindexC) °C"
        case 1:
            let percip = weather.current.precipMm
            if percip == 0 {
                subTitleLabel.text = "Осадков нет"
            } else {
                subTitleLabel.text = "Осадки: \(weather.current.precipMm) мм"
            }
        case 2:
            subTitleLabel.text = "Порывы ветра до \(weather.current.gustKph) км/ч"
        case 3:
            subTitleLabel.text = "Давление \(Int(weather.current.pressureIn * 25.399997)) мм рт.ст."
        case 4:
            let cloud = weather.current.cloud
            if cloud < 3 {
                subTitleLabel.text = "На улице ясно"
            } else if cloud < 5 {
                subTitleLabel.text = "На улице переменная облачность"
            } else {
                subTitleLabel.text = "На улице пасмурно"
            }
        default:
            break
        }
    }
}

//MARK: - Layout
extension WeatherMiniApp {
    private func setupLayout() {
        view.backgroundColor = .white
        
        setupTitleLabel()
        setupSegmentController()
        setupSubtitleLabel()
    }
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        switch city {
        case .mos:
            titleLabel.text = "Погода в Москве"
        case .spb:
            titleLabel.text = "Погода в Санкт-Петербурге"
        case .cup:
            titleLabel.text = "Погода в Купертино"
        }
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -view.frame.height / 3),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    private func setupSegmentController() {
        view.addSubview(segmentController)
        segmentController.insertSegment(with: UIImage(systemName: "thermometer.medium"), at: 0, animated: true)
        segmentController.insertSegment(with: UIImage(systemName: "drop.fill"), at: 1, animated: true)
        segmentController.insertSegment(with: UIImage(systemName: "wind"), at: 2, animated: true)
        segmentController.insertSegment(with: UIImage(systemName: "gauge.with.dots.needle.bottom.100percent"), at: 3, animated: true)
        segmentController.insertSegment(with: UIImage(systemName: "cloud.sun"), at: 4, animated: true)
        segmentController.addTarget(self, action: #selector(changeSegment), for: .valueChanged)
        segmentController.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentController.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentController.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
    private func setupSubtitleLabel() {
        view.addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: segmentController.bottomAnchor),
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
