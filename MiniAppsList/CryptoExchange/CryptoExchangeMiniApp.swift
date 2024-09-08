//
//  CryptoExchangeRate.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 07.09.2024.
//

import UIKit

enum Currency: String {
    case rub = "RUB"
    case usd = "USD"
    case eur = "EUR"
}

class CryptoExchangeMiniApp: UIViewController {
    // MARK: - Properties
    let coin: Coins
    private let coinPriceLabel = UILabel()
    private let titleLabel = UILabel()
    private let changeButton = UIButton()
    private var prices = [String: String]()
    // MARK: - Init
    init(coin: Coins, prices: [String : String] = [String: String]()) {
        self.coin = coin
        self.prices = prices
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPrice()
//        setupLayout()
    }
    //MARK: - Methods
    private func fetchPrice() {
        APICoinbaseCaller.shared.getCryptoPrice(for: coin) { [weak self] result in
            self?.prices = result.data.rates
            DispatchQueue.main.async {
                self?.setupLayout()
            }
        }
    }
    
    private func setCost(for currency: Currency) {
        var monetarySign = ""
        switch currency {
        case .rub:
            monetarySign = " ₽"
        case .usd:
            monetarySign = " $"
        case .eur:
            monetarySign = " €"
        }
        if let stringPrice = prices[currency.rawValue], let price = Double(stringPrice) {
            coinPriceLabel.text = String(format: "%.2f", price) + monetarySign
        }
    }
}

//MARK: - Layout
extension CryptoExchangeMiniApp {
    private func setupLayout() {
        view.backgroundColor = .white
        
        setupTitleLabel()
        setupPriceLabel()
        setupChangeButton()
    }
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        switch coin {
        case .btc:
            titleLabel.text = "Стоимость Bitcoin"
        case .eth:
            titleLabel.text = "Стоимость Ethereum"
        case .ton:
            titleLabel.text = "Стоимость Toncoin"
        }
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = .zero
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 4)
        ])
    }
    private func setupPriceLabel() {
        view.addSubview(coinPriceLabel)
        setCost(for: .rub)
        coinPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coinPriceLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            coinPriceLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
    private func setupChangeButton() {
        view.addSubview(changeButton)
        changeButton.setTitleColor(.black, for: .normal)
        changeButton.backgroundColor = .white
        changeButton.layer.cornerRadius = 12
        changeButton.layer.shadowOpacity = 0.3
        changeButton.layer.shadowRadius = 3
        changeButton.layer.shadowOffset = .zero
        changeButton.showsMenuAsPrimaryAction = true
        changeButton.changesSelectionAsPrimaryAction = true
        changeButton.menu = UIMenu(children: [
            UIAction(title: "Рубли") { [weak self] _ in
                self?.setCost(for: .rub)
            },
            UIAction(title: "Доллары") { [weak self] _ in
                self?.setCost(for: .usd)
            },
            UIAction(title: "Евро") { [weak self] _ in
                self?.setCost(for: .eur)
            }
        ])
        
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeButton.centerYAnchor.constraint(equalTo: coinPriceLabel.centerYAnchor),
            changeButton.leadingAnchor.constraint(equalTo: coinPriceLabel.trailingAnchor, constant: 20),
            changeButton.widthAnchor.constraint(equalToConstant: view.frame.width / 4)
        ])
    }
}
