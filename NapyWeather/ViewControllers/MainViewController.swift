//
//  ViewController.swift
//  NapyWeather
//
//  Created by Nur on 2/7/24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var searchTextField: UITextField!
    let dataMeneger = DataMeneger()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataMeneger.delegateByProtocol = self
        
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let searchInput = searchTextField.text
        guard let searchInput = searchInput, searchInput != "" else { return }
        dataMeneger.fetchData(searchInput)
    }
    
}

extension MainViewController: ShareWeatherDataProtocol {
    func updateUIWithNewData(_ weather: WeatherRightNow) {
        print(weather.name)
    }
    
    
}

