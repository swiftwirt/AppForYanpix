//
//  AFYMainViewControllerInteractor.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/8/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit
import CoreLocation

class AFYMainViewControllerInteractor: NSObject {
    
    var output: AFYMainViewControllerPresenter!
    
    fileprivate var applicationManager = AFYApplicationManager.instance()

    // TODO: - ivestigate case with extremely wrongly rounded coordinates returned from instagram
    var photoesLocations = [Location]()
    
    var currentLocation: CLLocation? {
        didSet {
           applicationManager.instagramFeedService.getLocationIDs(latitude: Float(self.currentLocation!.coordinate.latitude), and: Float(self.currentLocation!.coordinate.longitude)) { (result) in
                switch result {
                case .success(let value):
                    guard let data = value as? [[String: Any]] else { return }
                    let semaphore = DispatchSemaphore(value: 0)
                    DispatchQueue.global(qos: .background).async {
                        self.photoesLocations = [Location]()
                        for location in data {
                            print(location)
                            guard let id = location["id"] as? String else {
                                semaphore.signal();
                                return
                            }
                            self.applicationManager.instagramFeedService.getPhotosFor(locationID: id, completionHandler: { (result) in
                                switch result {
                                case .success(let data):
                                    print("***** !!!! \(data)")
                                    guard let dictArray = data as? [[String: Any]] else {
                                        semaphore.signal();
                                        return
                                    }
                                    outerloop: for item in dictArray {
                                        guard item.count > 0 else { continue }
                                        let location = Location(_with: item)
                                        
                                        for compoundLocation in self.photoesLocations {
                                            if compoundLocation.locationID == location.locationID {
                                                let index = self.photoesLocations.index(of: compoundLocation)
                                                let updatedLocation = compoundLocation
                                                updatedLocation.relatedLocations.append(location)
                                                updatedLocation.title = String(updatedLocation.relatedLocations.count + 1)
                                                updatedLocation.subtitle = nil
                                                self.photoesLocations[index!] = updatedLocation
                                                continue outerloop
                                            }
                                        }
                                        self.photoesLocations.append(location)
                                    }
                                    semaphore.signal()
                                case .failure(let error):
                                    print("***** !!!! \(error)")
                                    semaphore.signal()
                                }
                            })
                            semaphore.wait()
                        }
                        DispatchQueue.main.async {
                            self.output.updateLocations()
                            self.output.showLocations()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getLocation()
    {
        applicationManager.locationService.locationServiceCoordinatesResult = { (result) in
            switch result {
            case .success(let value):
                if let coordinates = value as? CLLocation {
                    self.currentLocation = coordinates
                } else {
                    print("***** Weird error occured! No CLLocation Data =(")
                }
            case .failure(let error):
                if error != nil { print(error!) }
            }
        }
    }
    
}
