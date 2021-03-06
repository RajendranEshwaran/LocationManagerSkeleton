//
//  LocationManager.swift
//  LocationManagerSkeleton
//
//  Created by gomathi saminathan on 1/28/20.
//  Copyright © 2020 Rajendran Eshwaran. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import MapKit

//import GoogleMaps
//import GooglePlaces


enum LocationManageState {
case failed
case updating
case stoped
case paused
}


class LocationManager : NSObject
{
/// Core location
private let locationManager: CLLocationManager =  CLLocationManager()
var locationInfoCallBack: ((_ info:LocationInformation)->())!
    
/// Location manager current state
  var state = LocationManageState.stoped

/// Location
var currentLocation = CLLocation()
var region = CLRegion()

static let shared: LocationManager = {
    let instance = LocationManager()
    return instance
}()
    
    func start(locationInfoCallBack:@escaping ((_ info:LocationInformation)->())) {
        self.locationInfoCallBack = locationInfoCallBack
         locationManager.requestAlwaysAuthorization()
         locationManager.startUpdatingLocation()
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.distanceFilter = kCLDistanceFilterNone
         locationManager.requestLocation()
         locationManager.activityType = .other
   
    }

    func stop() {
        locationManager.stopUpdatingLocation()
    }

    
    /// Get Permission from User
    func getPermission() -> Bool {

        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        case .denied, .restricted, .notDetermined:
            return false
            
        @unknown default:
            fatalError()
        }

        //  return false
    }
    
    func startUpdatingLocation()
    {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation()
    {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager : CLLocationManagerDelegate
{
//MARK: Current location fetch operation
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print( "Did Location access permission was changed: \(status)")

        switch status {
        case .denied:
            print("get Location permission to access")
            //self.displayAlert()
        case .notDetermined,.restricted:
            print( "get Location permission to access")
            manager.requestWhenInUseAuthorization()
        default:
            print( "Permission given")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          state = .updating

        guard let mostRecentLocation = locations.last else {
            return
        }
        print(mostRecentLocation)
        let info = LocationInformation()
        info.latitude = mostRecentLocation.coordinate.latitude
        info.longitude = mostRecentLocation.coordinate.longitude
        
        //now fill address as well for complete information through lat long ..
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(mostRecentLocation) { (placemarks, error) in
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            if let city = placemark.locality,
                let state = placemark.administrativeArea,
                let zip = placemark.postalCode,
                let locationName = placemark.name,
                let thoroughfare = placemark.thoroughfare,
                let country = placemark.country {
                info.city     = city
                info.state    = state
                info.zip = zip
                info.address =  locationName + ", " + (thoroughfare as String)
                info.country  = country
            }
            self.locationInfoCallBack(info)
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // state = .failed
        print( "Failed to update Locations: \(error.localizedDescription)")

        manager.requestLocation()
        manager.stopUpdatingLocation()
    }

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
          state = .paused
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
         state = .updating
    }
    

    
}
