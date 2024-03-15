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
    
    var listOfSearchedCityNames: [City] = []
    var settings: Settings!
    var wasChangedAtCurrentSession = false
    
    static let shared = DataManager()
    
    var delegateByProtocol: ShareWeatherDataProtocol?
    var delegateTableByProtocol: ShareWeatherDataListProtocol?
    
    
    func fetchData(_ city: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey)&units=\(settings.unit)&lang=\(settings.languageID)"
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
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(APIKey)&units=\(settings.unit)&lang=\(settings.languageID)"
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
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(lastcity)&appid=\(APIKey)&units=\(settings.unit)&lang=\(settings.languageID)"
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
            let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city.name)&appid=\(APIKey)&units=\(settings.unit)&lang=\(settings.languageID)"
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
    
    func sortSearchedValues(_ list: [City]) {
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
                let city = City(name: name, date: Date(), isFavorite: city.isFavorite)
                listOfSearchedCityNames.remove(at: counter)
                listOfSearchedCityNames.insert(city, at: 0)
                saveData()
                saveIntoDB()
                return
            } else {
                counter += 1
            }
        }
        let city = City(name: name, date: Date(), isFavorite: false)
        listOfSearchedCityNames.insert(city, at: 0)
        saveData()
        saveIntoDB()
    }
    
    func saveData() {
        guard let dataEncodedCitys = try? JSONEncoder().encode(listOfSearchedCityNames) else { return }
        UserDefaults.standard.setValue(dataEncodedCitys, forKey: "listOfCityNames")
        wasChangedAtCurrentSession = true
//        print(dataEncodedCitys, "is updated")
    }
    
    func loadData() -> Bool {
        guard let decodedCityNames = UserDefaults.standard.object(forKey: "listOfCityNames") as? Data else {
            print("First start")
            return false
        }
        guard let cityNames = try? JSONDecoder().decode([City].self, from: decodedCityNames) else {
            return false
        }
        sortSearchedValues(cityNames)
        fetchLast()
//        print(decodedCityNames, "is loaded")
        return true
    }
    
    func saveSettings() {
        let save = Settings(language: settings.language, languageID: settings.languageID, scale: settings.scale, unit: settings.unit)
        guard let encodeData = try? JSONEncoder().encode(save) else { return }
        UserDefaults.standard.setValue(encodeData, forKey: "settings")
    }
    
    func loadSettings() {
        guard let loadedSettings = UserDefaults.standard.object(forKey: "settings") as? Data else {
            let newSettings = Settings(language: "Руский", languageID: "ru", scale: "°C", unit: "metric")
            self.settings = newSettings
            return
        }
        guard let decodedSettings = try? JSONDecoder().decode(Settings.self,
                                                         from: loadedSettings) else { return }
        let newSettings = Settings(language: decodedSettings.language, languageID: decodedSettings.languageID, scale: decodedSettings.scale, unit: decodedSettings.unit)
        self.settings = newSettings
    }
    
    func saveIntoDB() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard !listOfSearchedCityNames.isEmpty else { return }
        let citys: [String : String] = {
            var temporary:  [String : String] = [:]
            for city in listOfSearchedCityNames {
                if city.isFavorite {
                    temporary[city.name] = "true"
                } else {
                    temporary[city.name] = "false"
                }
            }
            return temporary
        }()
        let settingsLayer: [String : String] = ["language": settings.language,
                                              "languageID" : settings.languageID,
                                              "scale" : settings.scale,
                                              "unit" : settings.unit]
        let layerOne = ["citys": citys, "settings": settingsLayer]
        let userData = [uid : layerOne]
        Database.database().reference().child("users").updateChildValues(userData) { error, _ in
            if let error = error {
                print(error)
            } else {
//                print("DB updated")
            }
        }
    }
    
    func fetchFromDB() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference()
            .child("users")
            .child(uid).observeSingleEvent(of: .value) { dataSnapshot in
                guard let userData = dataSnapshot.value as? [String: [String: String]] else { return }
                for identification in userData {
                    if identification.key == "settings" {
                        var listOfSettings: [String: String] = [:]
                        listOfSettings = identification.value
                        guard listOfSettings["language"] != nil,
                              listOfSettings["languageID"] != nil,
                              listOfSettings["scale"] != nil,
                              listOfSettings["unit"] != nil else { return }
                        self.settings.language = listOfSettings["language"]!
                        self.settings.languageID = listOfSettings["languageID"]!
                        self.settings.scale = listOfSettings["scale"]!
                        self.settings.unit = listOfSettings["unit"]!
                    }
                    if identification.key == "citys" {
                        var finalList: [City] = []
                        let listOfFetchedCitys: [String: String] = identification.value
                        guard !listOfFetchedCitys.isEmpty else { return }
                        for fetchedCity in listOfFetchedCitys {
                            let isFavorite = fetchedCity.value == "true" ? true : false
                            let city = City(name: fetchedCity.key, date: Date(), isFavorite: isFavorite)
                            finalList.append(city)
                        }
                        self.listOfSearchedCityNames = finalList
                        self.saveData()
                        self.saveSettings()
                    }
                }
            } withCancel: { error in
                print(error)
            }
    }
}




