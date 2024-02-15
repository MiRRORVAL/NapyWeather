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
    @IBOutlet var searchHistoryTableView: UITableView!
    

    @IBOutlet var dayProgresSlider: UISlider!
    @IBOutlet var dayStartLable: UILabel!
    @IBOutlet var dayEndLable: UILabel!
    
    @IBOutlet var searchStackView: UIStackView!
    
    @IBOutlet var baseStackView: UIStackView!
    
    @IBOutlet var statusImageView: UIImageView!
    
    @IBOutlet var searchTextField: UITextField!
    
    let dataManager = DataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchStackView.isHidden = true
        baseStackView.isHidden = true
        searchHistoryTableView.isHidden = true
        
        searchHistoryTableView.delegate = self
        searchHistoryTableView.dataSource = self
        dataManager.delegateByProtocol = self
        
        searchTextField.returnKeyType = .search

        
        dataManager.loadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func showSearchButtonePressed(_ sender: UIBarButtonItem) {
        searchStackView.isHidden = !searchStackView.isHidden
        if searchStackView.isHidden == true {
                let image = UIImage(systemName: "magnifyingglass")
                self.navigationItem.rightBarButtonItem?.image = image
                self.searchTextField.resignFirstResponder()
                self.searchHistoryTableView.isHidden = true

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
    
    
    @IBAction func primaryActionforReturnKey(_ sender: UITextField) {
        searchIsDone()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchIsDone()
    }
    

    @IBAction func gotoTheBookmarkTableViewBattonePressed(_ sender: UIBarButtonItem) {
        dataManager.fetchAllOfBookmarkedCitysList()
        searchStackView.isHidden = true
        searchHistoryTableView.isHidden = true
        let image = UIImage(systemName: "magnifyingglass")
        self.navigationItem.rightBarButtonItem?.image = image
        self.searchTextField.resignFirstResponder()
        performSegue(withIdentifier: "goTwo", sender: nil)
    }
    
    func searchIsDone() {
        self.searchTextField.resignFirstResponder()
        guard let inputSrting = searchTextField.text, inputSrting != "" else { return }
        dataManager.fetchData(inputSrting, false)
    }
}
    

