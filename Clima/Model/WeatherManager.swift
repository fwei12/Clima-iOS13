//
//  WeatherManager.swift
//  Clima
//
//  Created by fengwei on 4/28/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=80e6e274f20c0556ab7096c886ec07e6&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitute: CLLocationDegrees, longitute: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitute)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // Step 1 Create a URL
        if let url = URL(string: urlString) {
            // Step 2 Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            // Step 3 Give URLSession a task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            // Step 4 Start the task
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temp: temp)
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
