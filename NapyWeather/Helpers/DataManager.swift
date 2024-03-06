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
    
    
    func fetchData(_ city: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey)&units=metric&lang=ru"
        guard let url = URL(string: url) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard let data = data, error == nil else { return }
            do {
                let decodedData = try JSONDecoder().decode(WeatherRightNow.self, from: data)
                self.delegateByProtocol?.updateUIWithNewData(decodedData)
                self.updateData(decodedData.name)

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
    
    func fetchAllBookmarkedCitys() {
        let filteredFavorites = listOfSearchedCityNames.filter {
            $0.isFavorite == true
        }
        var weatherForAllCitys: [WeatherRightNow] = []
        var counter = 0
        
        for city in filteredFavorites {
                let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city.name)&appid=\(APIKey)&units=metric&lang=ru"
                guard let url = URL(string: url) else { return }
                let dataTask = URLSession.shared.dataTask(with: url) { (data, responce, error) in
                    guard let data = data, error == nil else { return }
                    do {
                        let decodedData = try JSONDecoder().decode(WeatherRightNow.self, from: data)
                        weatherForAllCitys.append(decodedData)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    
                    if counter == filteredFavorites.count - 1 {
                        self.delegateTableByProtocol?.updateTableViewWithBookmarkedCitys(weatherForAllCitys)
                    }
                    
                    counter += 1
                }
                dataTask.resume()
        }
    }
    
    func sortSearchedValues(_ list: [Citys]) {
        var sortedList = list
        sortedList.sort {
            $0.date > $1.date
        }
        listOfSearchedCityNames = sortedList
    }
    
    func updateData(_ name: String) {
        var counter = 0
        
        for city in listOfSearchedCityNames {
            if city.name == name {
                let city = Citys(name: name, date: Date(), isFavorite: city.isFavorite)
                listOfSearchedCityNames.remove(at: counter)
                listOfSearchedCityNames.insert(city, at: 0)
                saveData()
                return
            } else {
                counter += 1
            }
        }
        let city = Citys(name: name, date: Date(), isFavorite: false)
        listOfSearchedCityNames.insert(city, at: 0)
        saveData()
    }
    
    func saveData() {
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



