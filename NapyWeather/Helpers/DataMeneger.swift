//
//  DataMeneger.swift
//  NapyWeather
//
//  Created by Nur on 2/8/24.
//

import Foundation

class DataMeneger {
    
    
    func fetchData(_ city: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey)&units=metric"
        guard let url = URL(string: url) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Non")
                return
            }
            do {
                let decoded = try JSONDecoder().decode(WeatherRightNow.self, from: data)
                print(decoded.name)
                print(decoded.main.temp)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}


