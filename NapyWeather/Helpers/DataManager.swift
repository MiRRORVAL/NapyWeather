//
//  DataMeneger.swift
//  NapyWeather
//
//  Created by Nur on 2/8/24.
//

import Foundation

class DataManager {
    
    var listOfAddedCitys: [WeatherRightNow] = []
    static let shared = DataManager()
    
    var delegateByProtocol: ShareWeatherDataProtocol?
    
    
    func fetchData(_ city: String) {
        print(city)
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey)&units=metric&lang=ru"
        guard let url = URL(string: url) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Non")
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(WeatherRightNow.self, from: data)
                self.delegateByProtocol?.updateUIWithNewData(decodedData)
                self.saveData(decodedData)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }

 
    func saveData(_ data: WeatherRightNow) {
        listOfAddedCitys.append(data)
        guard let dataEncoded = try? JSONEncoder().encode(data) else { return }
        UserDefaults.standard.setValue(dataEncoded, forKey: "savedData")
        print(dataEncoded, "is saved")
    }
    
    
    func loadData() {
        guard let savedData = UserDefaults.standard.object(forKey: "savedData") as? Data else {
            return }
        guard let decodedData = try? JSONDecoder().decode(WeatherRightNow.self,
                                                         from: savedData) else { return }
        listOfAddedCitys.append(decodedData)
        self.delegateByProtocol?.updateUIWithNewData(decodedData)
        print(savedData, "is loaded")
    }
    
    
    
}



