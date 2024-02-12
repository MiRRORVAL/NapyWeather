//
//  CityNameList.swift
//  NapyWeather
//
//  Created by Nur on 2/12/24.
//

import Foundation

struct Citys: Codable, Hashable {
    
    let name: String
    var date: Date
    
    init(name: String, date: Date) {
        self.name = name
        self.date = Date()
    }
}
