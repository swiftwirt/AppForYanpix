//
//  AFYMainViewController.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/5/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import PKHUD

class AFYMainViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var useCurrentLocationButton: UIButton!
    
    fileprivate var applicationManager = AFYApplicationManager.instance()
    
    fileprivate var photoesLocations = [Location]()
    fileprivate var currentLocation: CLLocation? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func showLocations()
    {
        let region = regionForAnnotations(photoesLocations)
        mapView.setRegion(region, animated: true)
    }
    
    fileprivate func regionForAnnotations(_ annotations: [MKAnnotation]) -> MKCoordinateRegion
    {
        var region: MKCoordinateRegion
        
        switch annotations.count {
        case 0:
            region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
            
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000)
            
        default:
            var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
            
            for annotation in annotations {
                topLeftCoord.latitude = max(topLeftCoord.latitude, annotation.coordinate.latitude)
                topLeftCoord.longitude = min(topLeftCoord.longitude, annotation.coordinate.longitude)
                bottomRightCoord.latitude = min(bottomRightCoord.latitude, annotation.coordinate.latitude)
                bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(
                latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2,
                longitude: topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2)
            
            let extraSpace = 1.1
            let span = MKCoordinateSpan(
                latitudeDelta: abs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace,
                longitudeDelta: abs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace)
            
            region = MKCoordinateRegion(center: center, span: span)
        }
        
        return mapView.regionThatFits(region)
    }
    
    fileprivate func getLocation()
    {
        applicationManager.locationService.locationServiceCoordinatesResult = { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let value):
                if let coordinates = value as? CLLocation {
                    strongSelf.currentLocation = coordinates
                } else {
                    print("***** Weird error occured! No CLLocation Data =(")
                    HUD.flash(.error)
                }
            case .failure(let error):
                if error != nil { print(error!) }
                HUD.flash(.error)
            }
        }
    }

    @IBAction func onPressedUseCurrentLocationButton(_ sender: Any)
    {
        getLocation()
    }
}
