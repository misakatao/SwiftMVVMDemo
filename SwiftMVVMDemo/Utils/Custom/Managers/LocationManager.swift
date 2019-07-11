//
//  LocationManager.swift
//  SwiftMVVMDemo
//
//  Created by Shengtao Liu on 2017/12/28.
//  Copyright © 2017年 Shengtao Liu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

public enum LocationServiceStatus: Int {
    case available
    case undetermined
    case denied
    case restricted
    case disabled
}

public typealias UserCLLocation = (_ location: CLLocation) -> Void

public typealias CityString = (_ city: String? ) -> Void


private let DistanceAndSpeedCalculationInterval = 5.0;

private let LocationManagerSingleton = LocationManager()

public class LocationManager: NSObject, CLLocationManagerDelegate {

    public class var sharedInstance: LocationManager {
        return LocationManagerSingleton
    }
    
    public var userLocation: CLLocation?
    
    private var onUserCLLocation: UserCLLocation?
    
    private var onCityString: CityString?
    
    public var LastDistanceAndSpeedCalculation: Double = 0
    
    class var status: LocationServiceStatus {
        
        if !CLLocationManager.locationServicesEnabled() {
            return .disabled
        } else {
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                return .undetermined
            case .denied:
                return .denied
            case .restricted:
                return .restricted
            case .authorizedAlways, .authorizedWhenInUse:
                return .available
            }
        }
    }
    
    private var locationManager: CLLocationManager!
    
    public override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.delegate = self
        
        startLocation()
    }
    
    // begin locate
    public func startLocation()  {
        locationManager.startUpdatingLocation()
    }
    
    // end locate
    public func stopLocation()  {
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DebugLog("定位发生异常:\(error.localizedDescription)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard locations.count > 0 else {
            return
        }
        
        if LastDistanceAndSpeedCalculation > 0 {
            
            guard NSDate.timeIntervalSinceReferenceDate - LastDistanceAndSpeedCalculation > LastDistanceAndSpeedCalculation else {
                return
            }
        }
        
        LastDistanceAndSpeedCalculation = NSDate.timeIntervalSinceReferenceDate
        
        let location: CLLocation? = CLLocation(latitude: locations.last!.coordinate.latitude,
                                               longitude: locations.last!.coordinate.longitude)
        DebugLog(location?.coordinate.latitude ?? 111)
        DebugLog(location?.coordinate.longitude ?? 222)
        
        userLocation = location
        
        onUserCLLocation!(userLocation!)
        
        reverseGeocode(currLocation: location)
    }
    
    func reverseGeocode(currLocation: CLLocation!) {
        
        let geocoder = CLGeocoder()
        
        var placemark: CLPlacemark?
        
        geocoder.reverseGeocodeLocation(currLocation) { (placemarks, error) in
            
            if error != nil {
                DebugLog("reverse geodcode fail: \(error!.localizedDescription)")
                return
            }
            
            let pm = placemarks! as [CLPlacemark]
            if pm.count > 0 {
                placemark = placemarks![0]
                
                let city: String = placemark!.locality! as String
                self.onCityString!(city)
                DebugLog(city)
                self.stopLocation()
            } else {
                DebugLog("No Placemarks!")
            }
        }
    }
    
    func getUserLocationInfo(cllocation: @escaping UserCLLocation, city: @escaping CityString) -> Void {
        
        startLocation()
        onUserCLLocation = cllocation
        onCityString = city
    }
    
    func getUserCCLocation(cllocation: @escaping UserCLLocation) -> Void {
        
        startLocation()
        onUserCLLocation = cllocation
    }
    
    func showGoSetting() {
        if LocationManager.status != .available {
            let alert = UIAlertController.init(title: "提示", message: "您未开启定位服务，是否开启？", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
                
            }))
            alert.addAction(UIAlertAction.init(title: "去开启", style: UIAlertActionStyle.default, handler: { (action) in
                
                let settingUrl = URL(string: UIApplicationOpenSettingsURLString)!
                if UIApplication.shared.canOpenURL(settingUrl) {
                    UIApplication.shared.openURL(settingUrl)
                }
            }))
            kLastWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
