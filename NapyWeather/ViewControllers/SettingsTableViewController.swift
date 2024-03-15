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
        1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func setUnitsButton() {
        let unitsList: [String : String] = ["°C": "metric", "°K": "standart", "°F": "imperial"]
        var resaltList: [UIAction] = []
        
        let optionClosure = { (action : UIAction) in
            self.dataMeneger.settings.unit = unitsList[action.title]!
            self.dataMeneger.settings.scale = action.title
            self.dataMeneger.saveSettings()
            self.dataMeneger.saveIntoDB()
            self.dataMeneger.fetchLast()
            self.setUnitsButton()
        }
        let image = UIImage(systemName: "circle")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        let checkmarkImage = UIImage(systemName: "circle.fill")?.withTintColor(.yellow, renderingMode: .alwaysTemplate)
        for selection in unitsList.keys {
            if selection == dataMeneger.settings.scale {
                resaltList.insert(UIAction(title: dataMeneger.settings.scale, image: checkmarkImage, state: .on, handler: optionClosure), at: 0)
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
            self.dataMeneger.settings.languageID = languagesList[action.title]!
            self.dataMeneger.settings.language = action.title
            self.dataMeneger.saveSettings()
            self.dataMeneger.saveIntoDB()
            self.dataMeneger.fetchLast()
            self.setLanguageButton()
        }
        let image = UIImage(systemName: "circle")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
        let checkmarkImage = UIImage(systemName: "circle.fill")?.withTintColor(.yellow, renderingMode: .alwaysTemplate)
        for selection in languagesList.keys {
            if selection == dataMeneger.settings.language {
                resaltList.insert(UIAction(title: dataMeneger.settings.language, image: checkmarkImage, state: .on, handler: optionClosure), at: 0)
            } else {
                resaltList.append(UIAction(title: selection, image: image, handler: optionClosure))
            }
        }
        self.languageButton.menu = UIMenu (children : resaltList)
    }
}


