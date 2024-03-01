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
        dayProgresSlider.layer.cornerRadius = 10
        dayProgresSlider.layer.borderWidth = 15
        dayProgresSlider.layer.borderColor = CGColor(gray: 1, alpha: 0.2)
        
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
        self.navigationItem.rightBarButtonItem?.image = image
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
                self.navigationItem.rightBarButtonItem?.image = image
                self.searchTextField.becomeFirstResponder()
                if !self.dataManager.listOfSearchedCityNames.isEmpty {
                    self.searchHistoryTableView.isHidden = false
                }
            }
        }
    }
    
    func isDataLoaded() {
        if dataManager.listOfSearchedCityNames.isEmpty {
            serchLocation()
        }
    }
    
    private func showAlert(_ text: String) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func serchLocation() {
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
        serchLocation()
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
        searchIsDone()
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchIsDone()
    }
    
    
    
    @IBAction func gotoTheBookmarkTableViewBattonePressed(_ sender: UIBarButtonItem) {
        dataManager.fetchAllOfBookmarkedCitysList()
        hideSearchStack()
        performSegue(withIdentifier: "goTwo", sender: nil)
    }
    
    
    func searchIsDone() {
        self.searchTextField.resignFirstResponder()
        guard let inputSrting = searchTextField.text, inputSrting != "" else { return }
        dataManager.fetchData(inputSrting, false)
    }
}
    
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        dataManager.fetchDataByCoordinate("\(latitude)", "\(longitude)")
    }
    
    
    private func checkLocationAuthorization(){
        switch locationManager.authorizationStatus{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.showAlert("Определение геопозиции ограничено")
        case .denied:
            self.showAlert("Пользователь запретил использование геопозиции")
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager.requestLocation()
        default:
            break
        }
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
