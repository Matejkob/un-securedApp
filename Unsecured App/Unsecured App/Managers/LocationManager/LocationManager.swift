//
//  LocationManager.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 26/10/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit
import CoreLocation

final class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    private var regionCode: String = "US"
    
    static let shared = LocationManager()
    
    override init() {
        super.init()
        setupLocationManger()
    }
}

extension LocationManager {
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func getRegionCode() -> String {
        regionCode
    }
}

private extension LocationManager {
    func setupLocationManger() {
        locationManager.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
                if let placemark = placemarks?.first {
                    self?.regionCode = placemark.isoCountryCode ?? "US"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        
        if let rootViewController = window?.rootViewController {
            let alertController = UIAlertController(title: "Nie mogliśmy ustalić Twojej lokalizacji", message: "Wszystkie funkcje które korzystają lokalizacji będą działać na domyślnych danych", preferredStyle: .alert)
            alertController.addAction(.init(title: "OK", style: .cancel, handler: nil))
            
            rootViewController.present(alertController, animated: true)
        }
    }
}
