//
//  Extention + MainVC(source and delegate).swift
//  NapyWeather
//
//  Created by Nur on 2/14/24.
//

import UIKit

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let counter = dataManager.listOfSearchedCityNames.count
        return counter
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        searchHistoryTableView.separatorColor = .white
        cell.cityNameLable.textColor = .white
        cell.cityNameLable?.text = dataManager.listOfSearchedCityNames[indexPath.row].name
        cell.cellFavoriteBattone.tintColor = .white
        if dataManager.listOfSearchedCityNames[indexPath.row].isFavorite == true {
            let image = UIImage(systemName: "star.fill")
            cell.cellFavoriteBattone.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "star")
            cell.cellFavoriteBattone.setImage(image, for: .normal)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityNameToSearch = dataManager.listOfSearchedCityNames[indexPath.row]
        self.dataManager.listOfSearchedCityNames.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
        dataManager.fetchData(cityNameToSearch.name, cityNameToSearch.isFavorite)
        tableView.reloadData()
        searchStackView.isHidden = true
        searchHistoryTableView.isHidden = true
        let image = UIImage(systemName: "magnifyingglass")
        self.navigationItem.rightBarButtonItem?.image = image
        self.searchTextField.resignFirstResponder()
        }
    
    
    func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataManager.listOfSearchedCityNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dataManager.updateData()
        }
    }
}
