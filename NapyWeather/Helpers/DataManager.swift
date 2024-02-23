//
//  DataMeneger.swift
//  NapyWeather
//
//  Created by Nur on 2/8/24.
//

import UIKit
import CoreLocation

class DataManager {
    
    var listOfSearchedCityNames: [Citys] = []
    
    static let shared = DataManager()
    
    var delegateByProtocol: ShareWeatherDataProtocol?
    var delegateTableByProtocol: ShareWeatherDataListProtocol?
    
    
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

    
    func fetchDataByCoordinate(_ latitude: String, _ longitude: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(APIKey)&units=metric&lang=ru"
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
    
    
    func fetchLast(_ city: String) {
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
    
    func fetchAllOfBookmarkedCitysList() {
        for city in listOfSearchedCityNames {
            if city.isFavorite {
                let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city.name)&appid=\(APIKey)&units=metric&lang=ru"
                guard let url = URL(string: url) else { return }
                let dataTask = URLSession.shared.dataTask(with: url) { (data, responce, error) in
                    guard let data = data, error == nil else { return }
                    do {
                        let decodedData = try JSONDecoder().decode(WeatherRightNow.self, from: data)
                        self.delegateTableByProtocol?.updateUIWithNewData(decodedData)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
                dataTask.resume()
            }
        }
    }

//    ToDo -- Нужно проверить есть ли город уже в списке
//    func IsItNewData(_ name: String) -> Bool {
//        var finalResolt = true
//        for city in listOfSearchedCityNames {
//            if city.name == name {
//                finalResolt = false
//            }
//        }
//            if finalResolt {
//                return true
//            } else {
//                return false
//        }
//    }
    
    func sortSearchedValues(_ list: [Citys]) {
        var sortedList = list
        sortedList.sort {
            $0.date > $1.date
        }
        listOfSearchedCityNames = sortedList
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
    }
    
    
    func loadData() {
        guard let decodedCityNames = UserDefaults.standard.object(forKey: "listOfCityNames") as? Data else {
            print("First strt")
            
            return
        }
        guard let cityNames = try? JSONDecoder().decode([Citys].self,
                                                         from: decodedCityNames) else { return }
        sortSearchedValues(cityNames)
        guard let name = listOfSearchedCityNames.first?.name else { return }
        fetchLast(name)
        print(decodedCityNames, "is loaded")
    }
    
    
}



