//
//  APICaller.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 07.09.2024.
//

import Foundation
enum Coins: String {
    case btc = "BTC"
    case eth = "ETH"
    case ton = "TON"
}

final class APICaller {
    static let shared = APICaller()
    
    public func getCryptoPrice(for coun: Coins,completion: @escaping (Coin) -> Void) {
        guard let url = URL(string: "https://api.coinbase.com/v2/exchange-rates?currency=\(coun.rawValue)") else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let jsonData = try JSONDecoder().decode(Coin.self, from: data)
                completion(jsonData)
            }
            catch {
                print("Error: \(error)")
            }
        }.resume()
    }
}
