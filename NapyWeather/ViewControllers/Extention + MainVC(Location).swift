//
//  Extention + MainVC(Location).swift
//  NapyWeather
//
//  Created by Nur on 3/6/24.
//

import Foundation
import CoreLocation

extension MainViewController: CLLocationManagerDelegate {
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
