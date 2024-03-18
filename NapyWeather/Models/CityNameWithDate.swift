//
//  CityNameList.swift
//  NapyWeather
//
//  Created by Nur on 2/12/24.
//

import Foundation

struct City: Codable, Hashable {
    
    let name: String
    let date: Date
    let id: Int
    var isFavorite: Bool
}
