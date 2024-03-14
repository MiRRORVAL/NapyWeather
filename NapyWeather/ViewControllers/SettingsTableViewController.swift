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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUnitsButton()
        setLanguageButton()
        tableView.rowHeight = 50
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
        var resaltList: [UIAction] = []
        
        let optionClosure = { (action : UIAction) in
            self.dataMeneger.unit = unitsList[action.title]!
            self.dataMeneger.scale = action.title
            self.setUnitsButton()
        }
        
        let image = UIImage(systemName: "circle.dotted.circle")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        let checkmarkImage = UIImage(systemName: "circle.dotted.circle.fill")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        
        
        for selection in unitsList.keys {
            if selection == dataMeneger.scale {
                resaltList.insert(UIAction(title: dataMeneger.scale, image: checkmarkImage, state: .on, handler: optionClosure), at: 0)
            } else {
                resaltList.append(UIAction(title: selection, image: image, handler: optionClosure))
            }
        }
        self.unitsButton.menu = UIMenu (children : resaltList)
    }

    
    func setLanguageButton() {
        let languagesList: [String: String] = ["Руский": "ru", "Английский": "en", "Французкий": "fr", "Индуский": "hi", "Итальянский": "it", "Испанский": "sp", "Украинский": "ua", "Турецкий": "tr"]
        var resaltList: [UIAction] = []
        
        let optionClosure = { (action : UIAction) in
            self.dataMeneger.languageID = languagesList[action.title]!
            self.dataMeneger.language = action.title
            self.setLanguageButton()
        }
        
        let image = UIImage(systemName: "circle.dotted.circle")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        let checkmarkImage = UIImage(systemName: "circle.dotted.circle.fill")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        
        for selection in languagesList.keys {
            if selection == dataMeneger.language {
                resaltList.insert(UIAction(title: dataMeneger.language, image: checkmarkImage, state: .on, handler: optionClosure), at: 0)
            } else {
                resaltList.append(UIAction(title: selection, image: image, handler: optionClosure))
            }
        }
        self.languageButton.menu = UIMenu (children : resaltList)
    }

    override func viewWillDisappear(_ animated: Bool) {
        dataMeneger.saveSettings()
        dataMeneger.loadData()
    }
}


