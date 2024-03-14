//
//  DataMeneger.swift
//  NapyWeather
//
//  Created by Nur on 2/8/24.
//

import UIKit
import CoreLocation
import FirebaseAuth
import FirebaseDatabase

class DataManager {
    
    var listOfSearchedCityNames: [Citys] = []
    var language = "Английский"
    var languageID = "en"
    var scale = "°C"
    var unit = "metric"

    
    static let shared = DataManager()
    
    var delegateByProtocol: ShareWeatherDataProtocol?
    var delegateTableByProtocol: ShareWeatherDataListProtocol?
    
    
    func fetchData(_ city: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey)&units=\(unit)&lang=\(languageID)"
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
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(APIKey)&units=\(unit)&lang=\(languageID)"
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
    
    func fetchLast() {
        guard let lastcity = listOfSearchedCityNames.first?.name else { return }
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(lastcity)&appid=\(APIKey)&units=\(unit)&lang=\(languageID)"
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
                let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city.name)&appid=\(APIKey)&units=\(unit)&lang=\(languageID)"
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
    
    func loadData() -> Bool {
        guard let decodedCityNames = UserDefaults.standard.object(forKey: "listOfCityNames") as? Data else {
            print("First start")
            return false
        }
        guard let cityNames = try? JSONDecoder().decode([Citys].self, from: decodedCityNames) else {
            return false
        }
        sortSearchedValues(cityNames)
        fetchLast()
        print(decodedCityNames, "is loaded")
        return true
    }
    
    func saveSettings() {
        let save = Settings(language: language, languageID: languageID, scale: scale, unit: unit)
        guard let encodeData = try? JSONEncoder().encode(save) else { return }
        UserDefaults.standard.setValue(encodeData, forKey: "settings")
    }
    
    func loadSettings() {
        guard let decodedSettings = UserDefaults.standard.object(forKey: "settings") as? Data else {
            return
        }
        guard let settings = try? JSONDecoder().decode(Settings.self,
                                                         from: decodedSettings) else { return }
        languageID = settings.languageID
        language = settings.language
        scale = settings.scale
        unit = settings.unit
    }
    
    
    func saveIntoDB() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let citys: [String : Bool] = {
            var temporary:  [String : Bool] = [:]
            for city in listOfSearchedCityNames {
                temporary[city.name] = city.isFavorite
            }
            return temporary
        }()
        let settingsLayer: [String : Bool] = [language: true, unit : true]
        var layerOne = ["citys": citys, "settings": settingsLayer]
        let userData = [uid : layerOne]
        Database.database().reference().child("users").updateChildValues(userData) { error, _ in
            if let error = error {
                print(error)
                print("DB is NOT saved")
//                self.present(self.alert("\(error.localizedDescription )"), animated: true)
            } else {
                print("DB is saved")
            }
        }
    }
    
}




