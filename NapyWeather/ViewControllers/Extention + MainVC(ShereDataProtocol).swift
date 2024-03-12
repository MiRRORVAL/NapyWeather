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
            self.tempLabel.text = "\(weather.main.temp) \(self.dataManager.scale)"
            self.tempFeelsLikeLabel.text = "\(weather.main.feelsLike) \(self.dataManager.scale)"
            self.windSpeedLable.text = "\(weather.wind.speed)"
            self.preshureLable.text = {
                let presshureCalc = Double(weather.main.pressure) / 0.75006375541921
                return "\(Int(presshureCalc))"
            }()
            self.humidityLable.text = "\(weather.main.humidity)"
            self.visibilityLable.text = "\(weather.visibility)"
            self.cloudLevelLable.text = "\(weather.clouds.all)"
            self.cityNameLabel.text = weather.name
            self.weatherDescriptionLable.text = {
                let weatherDescription = weather.weather.first!.description.firstCapitalized
                return weatherDescription
            }()
            
            let doubleSunrise = Double(weather.sys.sunrise)
            let dateOfSunrise = Date(timeIntervalSince1970: doubleSunrise)
            let doubleSunset = Double(weather.sys.sunset)
            let dateOfSunset = Date(timeIntervalSince1970: doubleSunset)
            let dateNow = Date()
            let formater = DateFormatter()
            formater.timeStyle = .short
            formater.dateStyle = .none
            formater.timeZone = .autoupdatingCurrent
            formater.locale = .autoupdatingCurrent
            formater.dateFormat = "HH:mm"
            
            self.dayStartLable.text = {
                let sunrise = formater.string(from: dateOfSunrise)
                return sunrise
            }()
            self.dayEndLable.text = {
                let sunset = formater.string(from: dateOfSunset)
                return sunset
            }()
            
            let timeLeftBeforeSunset = dateNow.distance(to: dateOfSunset)
            let dayLongest = dateOfSunrise.distance(to: dateOfSunset)
            let porcentLeft = (timeLeftBeforeSunset * 100) / dayLongest
            
            
            self.dayProgresSlider.setValue(Float(100 - porcentLeft), animated: true)

            if porcentLeft < 0 {
                self.dayProgresSlider.setThumbImage(UIImage(systemName: "moonphase.new.moon")?.withTintColor(.gray,
                    renderingMode: .alwaysOriginal), for: .normal)
            } else {
                self.dayProgresSlider.setThumbImage(UIImage(systemName: "sun.max")?.withTintColor(.orange,
                    renderingMode: .alwaysOriginal), for: .normal)
            }
            self.dayLonestLable.text = {
                let trim = String(format: "%.1f", (dayLongest / 60 / 60))
                return "\(trim)"
            }()
            
            self.statusImageView.image = {
                switch weather.weather.last!.id {
                case 200...232: return UIImage(systemName: "cloud.bolt.rain.circle")
                case 300...321: return UIImage(systemName: "cloud.drizzle")
                case 500...531: return UIImage(systemName: "cloud.rain")
                case 600...622: return UIImage(systemName: "cloud.snow")
                case 700...781: return UIImage(systemName: "cloud.fog")
                case 800: if porcentLeft > 0 {
                    return UIImage(systemName: "sun.max")
                } else {
                    return UIImage(systemName: "moon")
                }
                    
                case 801...804: return UIImage(systemName: "smoke")
                default:
                    return UIImage(systemName: "minus.circle")
                }
            }()
            
            self.searchHistoryTableView.reloadData()
            
        }
    }
}


