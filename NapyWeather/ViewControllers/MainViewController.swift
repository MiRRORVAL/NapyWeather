//
//  ViewController.swift
//  NapyWeather
//
//  Created by Nur on 2/7/24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var tempFeelsLikeLabel: UILabel!
    @IBOutlet var windSpeedLable: UILabel!
    @IBOutlet var preshureLable: UILabel!
    @IBOutlet var humidityLable: UILabel!
    @IBOutlet var dayLonestLable: UILabel!
    @IBOutlet var visibilityLable: UILabel!
    @IBOutlet var cloudLevelLable: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    
    
    @IBOutlet var searchStackView: UIStackView!
    
    @IBOutlet var baseStackView: UIStackView!
    
    @IBOutlet var statusImageView: UIImageView!
    
    @IBOutlet var searchTextField: UITextField!
    
    let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegateByProtocol = self
        searchStackView.isHidden = true
        baseStackView.isHidden = true
        dataManager.loadData()
    }

    
    @IBAction func showSearchButtonePressed(_ sender: UIBarButtonItem) {
        searchStackView.isHidden = !searchStackView.isHidden
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let searchInput = searchTextField.text
        guard let searchInput = searchInput, searchInput != "" else { return }
        dataManager.fetchData(searchInput)
    }
    
}

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
        }
    }
}
