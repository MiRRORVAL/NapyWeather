//
//  ViewController.swift
//  NapyWeather
//
//  Created by Nur on 2/7/24.
//

import UIKit
import CoreLocation

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
    @IBOutlet var serchLocationButton: UIButton!
    @IBOutlet var weatherDescriptionLable: UILabel!
    @IBOutlet var searchHistoryTableView: UITableView!
    

    @IBOutlet var dayProgresSlider: UISlider!
    @IBOutlet var dayStartLable: UILabel!
    @IBOutlet var dayEndLable: UILabel!
    
    @IBOutlet var searchStackView: UIStackView!
    
    @IBOutlet var baseStackView: UIStackView!
    
    @IBOutlet var statusImageView: UIImageView!
    
    @IBOutlet var searchTextField: UITextField!
    
    var replicator: CAReplicatorLayer!
    var sourceLayer: CALayer!
    
    let dataManager = DataManager.shared
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchStackView.isHidden = true
        baseStackView.isHidden = true
        searchHistoryTableView.isHidden = true
        
        searchHistoryTableView.delegate = self
        searchHistoryTableView.dataSource = self
        dataManager.delegateByProtocol = self
        searchHistoryTableView.layer.borderWidth = 2
        searchHistoryTableView.layer.borderColor = CGColor(gray: 0.5, alpha: 0.2)
        dayProgresSlider.layer.cornerRadius = 100
        dayProgresSlider.layer.borderWidth = 15
        let color = UIColor.init(red: 1, green: 1, blue: 0.5, alpha: 0.1).cgColor
        dayProgresSlider.layer.borderColor = color
        
        searchTextField.returnKeyType = .search
        
        dataManager.loadData()
        
        isDataLoaded()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func hideSearchStack() {
        searchStackView.isHidden = true
        searchHistoryTableView.isHidden = true
        let image = UIImage(systemName: "magnifyingglass")
        self.navigationItem.leftBarButtonItem?.image = image
        self.searchTextField.text = .none
        self.searchTextField.resignFirstResponder()
    }
    
    @IBAction func showSearchButtonePressed(_ sender: UIBarButtonItem) {
        searchStackView.isHidden = !searchStackView.isHidden
        if searchStackView.isHidden == true {
            hideSearchStack()
        } else {
            UIView.animate(withDuration: 0.5, delay: 0) {
                let image = UIImage(systemName: "xmark.app")
                self.navigationItem.leftBarButtonItem?.image = image
                self.searchTextField.becomeFirstResponder()
                if !self.dataManager.listOfSearchedCityNames.isEmpty {
                    self.searchHistoryTableView.isHidden = false
                }
            }
        }
    }
    
    func isDataLoaded() {
        if dataManager.listOfSearchedCityNames.isEmpty {
            searchLocation()
        }
    }
    
    func showAlert(_ text: String) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func searchLocation() {
        DispatchQueue.global().async {
            CLLocationManager.locationServicesEnabled()
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.checkLocationAuthorization()
                }
            } else {
                self.showAlert("Не получено разрешение на использование геопозиции от пользователя")
            }
        }
    }
    
    @IBAction func serchLocationButtonPressed(_ sender: UIButton) {
        searchLocation()
        hideSearchStack()
    }
    
    @IBAction func searchTextFieldWrireStrted(_ sender: UITextField) {
        if searchTextField.text == "" {
            serchLocationButton.isHidden = false
        } else {
            serchLocationButton.isHidden = true
        }
    }
    
    @IBAction func primaryActionforReturnKey(_ sender: UITextField) {
        searchIsStarted()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchIsStarted()
    }
    @IBAction func openSettingsButtonePushed(_ sender: UIButton) {
        performSegue(withIdentifier: "openSettings", sender: nil)
    }
    
    @IBAction func gotoTheBookmarkTableViewBattonePressed(_ sender: UIBarButtonItem) {
        dataManager.fetchAllBookmarkedCitys()
        hideSearchStack()
        performSegue(withIdentifier: "goTwo", sender: nil)
    }
    
    func searchIsStarted() {
        self.searchTextField.resignFirstResponder()
        guard let inputSrting = searchTextField.text, inputSrting != "" else { return }
        dataManager.fetchData(inputSrting)
    }
    
}

    

