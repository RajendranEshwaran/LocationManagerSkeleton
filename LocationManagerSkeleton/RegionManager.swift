//
//  RegionManager.swift
//  LocationManagerSkeleton
//
//  Created by gomathi saminathan on 1/29/20.
//  Copyright © 2020 Rajendran Eshwaran. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import MapKit
class RegionManager : NSObject
{
/// Core location
private let locationManager: CLLocationManager =  CLLocationManager()
var regionInfoCallBack: ((_ info:RegionInformation)->())!
    
var region = CLRegion()

static let shared: RegionManager = {
    let instance = RegionManager()
    return instance
}()
    
 
    func startRegion(regionInfoCallBack:@escaping((_ info:RegionInformation)->()))
    {
        self.regionInfoCallBack = regionInfoCallBack
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        let geoFenceRegion = CLCircularRegion.init(center: CLLocationCoordinate2DMake(40.75921100,-73.98463800), radius: 100, identifier: "New York, NY, USA")
        locationManager.startMonitoring(for: geoFenceRegion)
    }
    
    func startRegionWithLocation(lat:CGFloat ,lon:CGFloat ,identifier:String, regionInfoCallBack:@escaping((_ info:RegionInformation)->()))
    {
        self.regionInfoCallBack = regionInfoCallBack
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        let geoFenceRegion = CLCircularRegion.init(center: CLLocationCoordinate2DMake(CLLocationDegrees(lat),CLLocationDegrees(lon)), radius: 100, identifier: identifier)
        locationManager.startMonitoring(for: geoFenceRegion)
    }
}

extension RegionManager : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for currentLocation in locations{
            print("\(index): \(currentLocation)")
            
        }
    }
    //MARK: Region Monitor service operation
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
    
        self.locationManager.requestState(for: region)
       
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        if state == CLRegionState.inside
        {
            print("Inside :\(region.identifier)")
        }
        else if state == CLRegionState.outside
        {
            print("Outside :\(region.identifier)")
        }
        else
        {
            print("Not determined")
        }
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let info = RegionInformation(reg: region)
        self.region = region
        print("Wellcome region\(region.identifier)")
        self.regionInfoCallBack(info)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let info = RegionInformation(reg: region)
        self.region = region
        print("Bye bye region\(region.identifier)")
        self.regionInfoCallBack(info)
    }
}

class RegionInformation
{
    var region : CLRegion
    
    init(reg:CLRegion) {
        
        self.region = reg
    }
}
