//
//  Model.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 07.09.2024.
//

import Foundation

struct Coin: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let currency: String
    let rates: [String: String]
}
