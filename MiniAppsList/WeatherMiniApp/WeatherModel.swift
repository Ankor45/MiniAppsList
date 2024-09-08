//
//  WeatherModel.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 08.09.2024.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let current: Current
}

// MARK: - Current
struct Current: Codable {
    let gustKph: Double
    let precipMm: Int
    let cloud: Int
    let pressureIn: Double
    
    let heatindexC: Double
    
    enum CodingKeys: String, CodingKey {
        case gustKph = "gust_kph"
        case precipMm = "precip_mm"
        case cloud
        case pressureIn = "pressure_in"
        case heatindexC = "heatindex_c"
    }
}

