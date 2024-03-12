//
//  Settings.swift
//  NapyWeather
//
//  Created by Nur on 3/12/24.
//

import Foundation

struct Settings: Codable, Hashable {
    let language: String
    let languageID: String
    let scale: String
    var unit: String
}
