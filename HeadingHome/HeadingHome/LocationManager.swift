//
//  File.swift
//  HeadingHome
//
//  Created by Mike Nelson on 7/10/17.
//
//

import Foundation
import MNPermissionService
import CoreLocation
import MapKit

protocol ETADelegate: class {
    func receivedETA(time: Int)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    
    var service: MNPermissionService?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    weak var etaDelegate: ETADelegate?
    
    fileprivate override init() {
        super.init()
        
        service = MNPermissionService.create(service: .locationInUse)
        service?.requestAccess(service: .locationInUse)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func getHomeAddress() -> MKPlacemark? {
        var homeAddress: MKPlacemark? = nil
        let address = AppDefaults.sharedInstance.getCustom(key: appKeys.home.rawValue)
        
        homeAddress = NSKeyedUnarchiver.unarchiveObject(with: address as Data) as? MKPlacemark
        
        return homeAddress
    }
    
    func saveHomeAddress(address: MKPlacemark) {
        AppDefaults.sharedInstance.setCustom(item: address, key: appKeys.home.rawValue)
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D {
        return currentLocation!
    }
    
    func getEstimatedTimeHome() {
        if let home = getHomeAddress() {
            let directions = MKDirectionsRequest()
            directions.source = MKMapItem.forCurrentLocation()
            directions.destination = MKMapItem(placemark: home)
            
            calculateETA(withRequest: directions)
        }
    }
    
    func calculateETA(withRequest directions: MKDirectionsRequest) {
        let dir = MKDirections(request: directions)
        dir.calculateETA(completionHandler: { (response, error) in
            guard let reponse = response else {
                print("Error getting ETA :: \(error!)")
                return
            }
            let time: Int = Int(reponse.expectedTravelTime / 60)
            print(time)
            self.etaDelegate?.receivedETA(time: time)
        })
    }
    
    // Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first?.coordinate
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "UserLocationChange")))
    }
    
    
    
}
