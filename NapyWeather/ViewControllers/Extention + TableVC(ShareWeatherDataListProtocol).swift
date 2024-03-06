//
//  Extention + TableVC(ShareWeatherDataListProtocol).swift
//  NapyWeather
//
//  Created by Nur on 2/14/24.
//

import Foundation

extension TableViewController: ShareWeatherDataListProtocol {
    
    func updateUIWithNewData(_ weather: [WeatherRightNow]) {
        citys = weather
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
