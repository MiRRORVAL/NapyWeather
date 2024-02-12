//
//  ViewController.swift
//  NapyWeather
//
//  Created by Nur on 2/7/24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var tempFeelsLikeLabel: UILabel!
    @IBOutlet var windSpeedLable: UILabel!
    @IBOutlet var preshureLable: UILabel!
    @IBOutlet var humidityLable: UILabel!
    @IBOutlet var dayLonestLable: UILabel!
    @IBOutlet var visibilityLable: UILabel!
    @IBOutlet var cloudLevelLable: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var weatherDescriptionLable: UILabel!
    
    @IBOutlet var searchStackView: UIStackView!
    
    @IBOutlet var baseStackView: UIStackView!
    
    @IBOutlet var statusImageView: UIImageView!
    
    @IBOutlet var searchTextField: UITextField!
    
    let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegateByProtocol = self
        searchStackView.isHidden = true
        baseStackView.isHidden = true
        searchTextField.returnKeyType = .search
        dataManager.loadData()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func serchTheCity() {
        let searchInput = searchTextField.text
        guard let searchInput = searchInput, searchInput != "" else { return }
        dataManager.fetchData(searchInput)
    }
    
    @IBAction func showSearchButtonePressed(_ sender: UIBarButtonItem) {
        searchStackView.isHidden = !searchStackView.isHidden
        if searchStackView.isHidden == true {
            let image = UIImage(systemName: "magnifyingglass")
            navigationItem.rightBarButtonItem?.image = image
        } else {
            let image = UIImage(systemName: "xmark.app")
            navigationItem.rightBarButtonItem?.image = image
            searchTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func searchTextFieldWriteStarted(_ sender: UITextField) {
        serchTheCity()
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        serchTheCity()
    }
    
    
}

