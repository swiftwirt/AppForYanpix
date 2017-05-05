//
//  AFYLocationService.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/5/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit
import CoreLocation

enum LocationResult<T>
{
    case success(T)
    case failure(Error?)
}

class AFYLocationService: NSObject {
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var location: CLLocation?
    fileprivate var updatingLocation = false
    fileprivate var lastLocationError: Error?
    
    fileprivate var timer: Timer?
    
    var locationServiceCoordinatesResult: ((LocationResult<Any>) -> ())? {
        didSet {
            getCurrentLoacation()
        }
    }
    
    fileprivate func getCurrentLoacation()
    {
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            locationServiceCoordinatesResult?(LocationResult.failure(nil))
            print("***** User restricted location data usage!")
            return
        }
        
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            startLocationManager()
        }
    }
    
    fileprivate func startLocationManager()
    {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    fileprivate func stopLocationManager()
    {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    
    func didTimeOut()
    {
        print("***** Time out")
        
        if location == nil {
            stopLocationManager()
            
            lastLocationError = NSError(domain: "MyLocationsErrorDomain", code: 1, userInfo: nil)
        }
    }
}

extension AFYLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("***** didFailWithError \(error)")
        
        if error._code == CLError.locationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        
        stopLocationManager()
        locationServiceCoordinatesResult?(LocationResult.failure(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("***** didUpdateLocations \(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        var distance = CLLocationDistance(DBL_MAX)
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            
            lastLocationError = nil
            location = newLocation
            locationServiceCoordinatesResult?(LocationResult.success(newLocation))
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                stopLocationManager()
            }
            
        } else if distance < 1.0 {
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            if timeInterval > 10 {
                print("*** Force done!")
                stopLocationManager()
                locationServiceCoordinatesResult?(LocationResult.success(newLocation))
            }
        }
    }
    
}
