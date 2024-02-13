//
//  DataMeneger.swift
//  NapyWeather
//
//  Created by Nur on 2/8/24.
//

import UIKit

class DataManager {
    
    var listOfAddedCitys: [WeatherRightNow] = []
    var listOfSearchedCityNames: [Citys] = []
    
    static let shared = DataManager()
    
    var delegateByProtocol: ShareWeatherDataProtocol?
    
    
    func fetchData(_ city: String, _ isFavorite: Bool) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey)&units=metric&lang=ru"
        guard let url = URL(string: url) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard let data = data, error == nil else { return }
            do {
                let decodedData = try JSONDecoder().decode(WeatherRightNow.self, from: data)
                self.delegateByProtocol?.updateUIWithNewData(decodedData)
                self.correctData(decodedData.name, isFavorite)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    
    func fetchFirst(_ city: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey)&units=metric&lang=ru"
        guard let url = URL(string: url) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard let data = data, error == nil else { return }
            do {
                let decodedData = try JSONDecoder().decode(WeatherRightNow.self, from: data)
                self.delegateByProtocol?.updateUIWithNewData(decodedData)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }


    func IsItNewData(_ name: String) -> Bool {
        var finalResolt = true
        for city in listOfSearchedCityNames {
            if city.name == name {
                finalResolt = false
            }
        }
            if finalResolt {
                return true
            } else {
                return false
            
        }
    }
    
    func sortSearchedValues(_ list: [Citys]) {
        var sortedList = list
        sortedList.sort {
            $0.date > $1.date
        }
        listOfSearchedCityNames = sortedList
    }
 
    func saveNewData(_ name: String) {
        let city = Citys(name: name, date: Date(), isFavorite: false)
        listOfSearchedCityNames.insert(city, at: 0)
        updateData()
    }
    
    func correctData(_ name: String, _ isFavorite: Bool) {
        let city = Citys(name: name, date: Date(), isFavorite: isFavorite)
        listOfSearchedCityNames.insert(city, at: 0)
        updateData()
    }
    
    func updateData() {
        guard let dataEncodedCitys = try? JSONEncoder().encode(listOfSearchedCityNames) else { return }
        UserDefaults.standard.setValue(dataEncodedCitys, forKey: "listOfCityNames")
        print(dataEncodedCitys, "is updated")
        print(listOfSearchedCityNames)
    }
    
    
    func loadData() {
        guard let decodedCityNames = UserDefaults.standard.object(forKey: "listOfCityNames") as? Data else {
            return }
        guard let cityNames = try? JSONDecoder().decode([Citys].self,
                                                         from: decodedCityNames) else { return }
        sortSearchedValues(cityNames)
        print(cityNames)
        guard let name = listOfSearchedCityNames.first?.name else { return }
        fetchFirst(name)
        print(decodedCityNames, "is loaded")
    }
     
}



