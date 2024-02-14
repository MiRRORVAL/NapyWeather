//
//  Extention + StringProtocol.swift
//  NapyWeather
//
//  Created by Nur on 2/14/24.
//

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
