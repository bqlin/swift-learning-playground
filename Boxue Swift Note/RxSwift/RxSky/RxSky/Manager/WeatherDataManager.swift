//
//  WeatherDataManager.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/22.
//  Copyright © 2021 Bq. All rights reserved.
//

import Foundation
import RxSwift

enum DataManagerError: Error {
    case failedRequest
    case invalidResponse
    case unknown
}

// 封装数据请求逻辑
final class WeatherDataManager {
    private let baseURL: URL
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }

    static let shared = WeatherDataManager(baseURL: API.authenticatedURL)

    // UI更新需要在主线程中自行切换
    typealias CompletionHandler = (WeatherData?, DataManagerError?) -> Void

    func requestWeatherDataAt(latitude: Double,
                              longitude: Double,
                              completion: @escaping CompletionHandler)
    {
        let url = baseURL.appendingPathComponent("\(latitude), \(longitude)")
        var request = URLRequest(url: url)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            self.didFinishRequestingWeatherData(data: data, response: response, error: error, completion: completion)
        }.resume()
    }

    func didFinishRequestingWeatherData(data: Data?,
                                        response: URLResponse?,
                                        error: Error?,
                                        completion: CompletionHandler)
    {
        guard error == nil else {
            completion(nil, .failedRequest)
            return
        }

        guard let data = data else {
            completion(nil, .unknown)
            return
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            completion(nil, .failedRequest)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            completion(weatherData, nil)
        } catch {
            completion(nil, .invalidResponse)
        }
    }
}
