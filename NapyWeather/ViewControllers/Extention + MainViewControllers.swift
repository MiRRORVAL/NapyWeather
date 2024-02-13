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
//            self.dataManager.sortSearchedValues(self.dataManager.listOfSearchedCityNames)
            self.searchHistoryTableView.reloadData()
            
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let counter = dataManager.listOfSearchedCityNames.count
        return counter
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        cell.cityNameLable?.text = dataManager.listOfSearchedCityNames[indexPath.row].name
        cell.cellFavoriteBattone.tintColor = .orange
        if dataManager.listOfSearchedCityNames[indexPath.row].isFavorite == true {
            let image = UIImage(systemName: "star.fill")
            cell.cellFavoriteBattone.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "star")
            cell.cellFavoriteBattone.setImage(image, for: .normal)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityNameToSearch = dataManager.listOfSearchedCityNames[indexPath.row]
        searchTextField.text = cityNameToSearch.name
        guard let inputSrting = searchTextField.text, inputSrting != "" else { return }
        let one = cityNameToSearch.name
        let two = cityNameToSearch.isFavorite
        self.dataManager.listOfSearchedCityNames.remove(at: indexPath.row)
        dataManager.fetchData(one, two)
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataManager.listOfSearchedCityNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dataManager.updateData()
        }
    }  
}

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
