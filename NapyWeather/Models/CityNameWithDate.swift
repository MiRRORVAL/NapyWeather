//
//  CityNameList.swift
//  NapyWeather
//
//  Created by Nur on 2/12/24.
//

import Foundation

struct Citys: Codable, Hashable {
    
    let name: String
    let date: Date
    var isFavorite: Bool
    
    init(name: String, date: Date, isFavorite: Bool) {
        self.name = name
        self.date = Date()
        self.isFavorite = isFavorite
    }
}
