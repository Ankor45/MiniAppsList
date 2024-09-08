//
//  APIWeatherColler.swift
//  MiniAppsList
//
//  Created by Andrei Kovryzhenko on 08.09.2024.
//

import Foundation

enum Citys: String {
    case mos = "Moscow"
    case spb = "Saint_Petersburg"
    case cup = "Cupertino"
}

final class APIWeatherColler {
    static let shared = APIWeatherColler()
    
    public func getWeather(for city: Citys,completion: @escaping (WeatherModel) -> Void) {
        let headers = [
            "x-rapidapi-key": "e2256a78c7msh2565e62a7c689acp126325jsnf7a4f5af5159",
            "x-rapidapi-host": "weatherapi-com.p.rapidapi.com"
        ]
        guard let url = URL(string: "https://weatherapi-com.p.rapidapi.com/current.json?q=\(city.rawValue)") else { return }
        let request = NSMutableURLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let jsonData = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(jsonData)
            }
            catch {
                print("Error: \(error)")
            }
        }.resume()
    }
}



