//
//  Extention + MainViewControllers.swift
//  NapyWeather
//
//  Created by Nur on 2/9/24.
//

import UIKit

extension MainViewController: ShareWeatherDataProtocol {
    func updateUIWithNewData(_ weather: WeatherRightNow) {
        DispatchQueue.main.async {
            self.baseStackView.isHidden = false
            self.tempLabel.text = "\(weather.main.temp) °С"
            self.tempFeelsLikeLabel.text = "\(weather.main.feelsLike) °С"
            self.windSpeedLable.text = "\(weather.wind.speed)"
            self.preshureLable.text = {
                let presshureCalc = Double(weather.main.pressure) / 0.75006375541921
                return "\(Int(presshureCalc))"
            }()
            self.humidityLable.text = "\(weather.main.humidity)"
            self.dayLonestLable.text = {
                var dayTime = weather.sys.sunset - weather.sys.sunrise
                dayTime /= 60
                dayTime /= 60
                return "\(dayTime) ч"
            }()
            self.visibilityLable.text = "\(weather.visibility)"
            self.cloudLevelLable.text = "\(weather.clouds.all)"
            self.cityNameLabel.text = weather.name
            self.weatherDescriptionLable.text = {
                let weatherDescription = weather.weather.first!.description.firstCapitalized
                return weatherDescription
            }()
            self.statusImageView.image = {
                switch weather.weather.first!.id {
                case 200...232: return UIImage(systemName: "cloud.bolt.rain.circle")
                case 300...321: return UIImage(systemName: "cloud.drizzle")
                case 500...531: return UIImage(systemName: "cloud.rain")
                case 600...622: return UIImage(systemName: "cloud.snow")
                case 700...781: return UIImage(systemName: "cloud.fog")
                case 800: return UIImage(systemName: "sun.max")
                case 801...804: return UIImage(systemName: "smoke")
                default:
                    return UIImage(systemName: "minus.circle")
                }
            }()
            self.sortSearchedValues()
            self.searchHistoryTableView.reloadData()
            
        }
    }
    
    func sortSearchedValues(){
        dataManager.listOfSearchedCityNames.sort {
            $0.date > $1.date
        }
    }
    
    
    func serchTheCity() {
        let searchInput = searchTextField.text
        guard let searchInput = searchInput, searchInput != "" else { return }
        dataManager.fetchData(searchInput)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let counter = dataManager.listOfSearchedCityNames.count
        return counter
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataManager.listOfSearchedCityNames[indexPath.row].name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityNameToSearch = dataManager.listOfSearchedCityNames[indexPath.row]
        searchTextField.text = cityNameToSearch.name
        dataManager.listOfSearchedCityNames.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
        serchTheCity()
    }
    
}

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
