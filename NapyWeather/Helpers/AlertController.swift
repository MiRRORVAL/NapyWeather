//
//  AlertController.swift
//  NapyWeather
//
//  Created by Nur on 3/14/24.
//

import UIKit

class AlertController {
    static func showAlert(_ text: String) -> UIAlertController {
        let alert = UIAlertController(title: "",
                                      message: text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        return alert
    }
}

