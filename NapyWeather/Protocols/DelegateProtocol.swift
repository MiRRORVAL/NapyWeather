//
//  DelegateProtocol.swift
//  NapyWeather
//
//  Created by Nur on 2/8/24.
//

import Foundation

protocol ShareWeatherDataProtocol {
    func updateUIWithNewData(_ weather: WeatherRightNow)
}
