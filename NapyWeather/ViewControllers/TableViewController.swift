//
//  TableViewController.swift
//  NapyWeather
//
//  Created by Nur on 2/8/24.
//

import UIKit

class TableViewController: UITableViewController {
    
    var citys: [WeatherRightNow] = []

    let dataManager = DataManager.shared
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegateTableByProtocol = self
        activityIndicator.hidesWhenStopped = true
        if !citys.isEmpty {
            activityIndicator.startAnimating()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBookmark", for: indexPath)
        cell.textLabel?.text = citys[indexPath.row].name
        cell.detailTextLabel?.text = "\(citys[indexPath.row].main.temp) \(dataManager.settings.scale)"
        if indexPath.row == citys.count - 1 {
            activityIndicator.stopAnimating()
        }
        return cell
    }
}

extension TableViewController: ShareWeatherDataListProtocol {
    
    func updateTableViewWithBookmarkedCitys(_ weather: [WeatherRightNow]) {
        citys = weather
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

