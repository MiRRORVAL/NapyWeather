//
//  SettingsTableViewController.swift
//  NapyWeather
//
//  Created by Nur on 3/12/24.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet var unitsButton: UIButton!
    @IBOutlet var languageButton: UIButton!
    let dataMeneger = DataManager.shared
    var scale: String?
    var language: String?
    @IBOutlet var languageSelector: UIButton!
    @IBOutlet var unitSelector: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUnitsButton()
        setLanguageButton()
        
        unitSelector.setTitle(dataMeneger.scale, for: .normal)
        languageSelector.setTitle(dataMeneger.language, for: .normal)
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    func setUnitsButton() {
        let unitsList: [String : String] = ["°C": "metric", "°K": "standart", "°F": "imperial"]
        let optionClosure = { (action : UIAction) in
            self.dataMeneger.unit = unitsList[action.title]!
            self.dataMeneger.scale = action.title
        }
        
        let image = UIImage(systemName: "poweroff")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
            self.unitsButton.menu = UIMenu (children : [
            UIAction(title: "°C", image: image, handler: optionClosure),
            UIAction(title: "°K", image: image, handler: optionClosure),
            UIAction(title: "°F", image: image, handler: optionClosure),
        ])
    }
    
    func setLanguageButton() {
        let languagesList: [String : String] = ["Руский": "ru", "Английский": "en", "Французкий": "fr","Индуский": "hi", "Итальянский": "it", "Испанский": "sp","Украинский": "ua", "Турецкий": "tr"]
        let optionClosure = { (action : UIAction) in
            self.dataMeneger.language = languagesList[action.title] ?? "en"
        }
        let image = UIImage(systemName: "poweroff")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        
        languageButton.menu = UIMenu (children : [
            UIAction(title: "Руский", image: image, handler: optionClosure),
            UIAction(title: "Английский", image: image, handler: optionClosure),
            UIAction(title: "Французкий", image: image, handler: optionClosure),
            UIAction(title: "Индуский", image: image, handler: optionClosure),
            UIAction(title: "Итальянский", image: image, handler: optionClosure),
            UIAction(title: "Испанский", image: image, handler: optionClosure),
            UIAction(title: "Украинский", image: image, handler: optionClosure),
            UIAction(title: "Турецкий", image: image, handler: optionClosure)
        ])
    }
    
}


