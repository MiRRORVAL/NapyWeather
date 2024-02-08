//
//  ViewController.swift
//  NapyWeather
//
//  Created by Nur on 2/7/24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var searchTextField: UITextField!
    
    let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegateByProtocol = self
        
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let searchInput = searchTextField.text
        guard let searchInput = searchInput, searchInput != "" else { return }
        dataManager.fetchData(searchInput)
    }
    
}

extension MainViewController: ShareWeatherDataProtocol {
    func updateUIWithNewData(_ weather: WeatherRightNow) {
        
    }
    
    
}

