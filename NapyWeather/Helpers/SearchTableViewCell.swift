//
//  SearchTableViewCell.swift
//  NapyWeather
//
//  Created by Nur on 2/13/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet var cellFavoriteBattone: UIButton!
    @IBOutlet var cityNameLable: UILabel!
    @IBOutlet var cellImage: UIImageView!
    
    let dataManager = DataManager.shared
    

    @IBAction func cellFavoriteBattonePressed(_ sender: UIButton) {
        guard let superview = self.superview as? UITableView else { return }
        guard let indexPath = superview.indexPath(for: self) else { return }
        dataManager.listOfSearchedCityNames[indexPath.row].isFavorite.toggle()
        dataManager.saveData()
        superview.reloadData()
    }
}
