//
//  DataMeneger.swift
//  NapyWeather
//
//  Created by Nur on 2/8/24.
//

import Foundation

class DataManager {
    
    var listOfAddedCitys: [WeatherRightNow] = []
    var listOfSearchedCityNames: [Citys] = []
    
    static let shared = DataManager()
    
    var delegateByProtocol: ShareWeatherDataProtocol?
    
    
    func fetchData(_ city: String) {
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
                self.saveData(decodedData.name)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }

 
    func saveData(_ name: String) {
//        listOfAddedCitys.append(data)
        let city = Citys(name: name, date: Date())
        for city in listOfSearchedCityNames {
            if city.name == name {
                guard let findIndex = listOfSearchedCityNames.firstIndex(of: city) else {
                return
                }
                listOfSearchedCityNames.remove(at: findIndex)
            }
        }
        listOfSearchedCityNames.append(city)
        guard let dataEncodedCitys = try? JSONEncoder().encode(listOfSearchedCityNames) else { return }
        UserDefaults.standard.setValue(dataEncodedCitys, forKey: "listOfCityNames")
        print(dataEncodedCitys, "is saved")
    }
    
    
    func loadData() {
        guard let decodedCityNames = UserDefaults.standard.object(forKey: "listOfCityNames") as? Data else {
            return }
        guard let cityNames = try? JSONDecoder().decode([Citys].self,
                                                         from: decodedCityNames) else { return }
        listOfSearchedCityNames = cityNames
        guard let name = listOfSearchedCityNames.last?.name else { return }
        fetchData(name)
        print(decodedCityNames, "is loaded")
    }
    
    
    
}



