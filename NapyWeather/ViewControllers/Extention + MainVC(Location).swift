//
//  Extention + MainVC(Location).swift
//  NapyWeather
//
//  Created by Nur on 3/6/24.
//

import Foundation
import CoreLocation

extension MainViewController: CLLocationManagerDelegate {
    
    func searchLocation() {
        DispatchQueue.global().async {
            CLLocationManager.locationServicesEnabled()
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.checkLocationAuthorization()
                }
            } else {
                self.present(AlertController.showAlert("Не получено разрешение на использование геопозиции от пользователя"), animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        dataManager.fetchDataByCoordinate("\(latitude)", "\(longitude)")
    }
    
    func checkLocationAuthorization(){
        
        switch locationManager.authorizationStatus{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.present(alert("Определение геопозиции ограничено"), animated: true)
        case .denied:
            self.present(alert("Пользователь запретил использование геопозиции"), animated: true)
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
