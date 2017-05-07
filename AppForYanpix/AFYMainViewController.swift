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
    
    struct SegueIdentifier {
        static let toPhotoes = "SegueToPhotoes"
        
        private init() {}
    }
    
    struct ReuseIdentifier {
        static let location = "Location"
        
        private init() {}
    }
    
    struct Color {
        static let pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
        static let tintColor = UIColor(white: 0.0, alpha: 0.5)

        private init() {}
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var useCurrentLocationButton: UIButton!
    
    fileprivate var applicationManager = AFYApplicationManager.instance()

    // TODO: - ivestigate case with extremely wrongly rounded coordinates returned from instagram
    fileprivate var photoesLocations = [Location]()
    
    fileprivate var currentLocation: CLLocation? {
        didSet {
            self.applicationManager.instagramFeedService.getLocationIDs(latitude: Float(self.currentLocation!.coordinate.latitude), and: Float(self.currentLocation!.coordinate.longitude)) { (result) in
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
                                                updatedLocation.imageLinks += location.imageLinks
                                                updatedLocation.lowResolutionImageLinks += location.lowResolutionImageLinks
                                                updatedLocation.standartResolutionImageLinks += location.standartResolutionImageLinks
                                                updatedLocation.title = String(updatedLocation.imageLinks.count)
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
                            self.updateLocations()
                            self.showLocations()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(revealRegionDetailsWithLongPressOnMap(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    fileprivate func showLocations()
    {
        let region = regionForAnnotations(photoesLocations)
        mapView.setRegion(region, animated: true)
    }
    
    fileprivate func updateLocations()
    {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(photoesLocations)
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
        applicationManager.locationService.locationServiceCoordinatesResult = { (result) in
            switch result {
            case .success(let value):
                if let coordinates = value as? CLLocation {
                    self.currentLocation = coordinates
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
    
    func showPhotoes(_ sender: UIButton)
    {
        performSegue(withIdentifier: SegueIdentifier.toPhotoes, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.toPhotoes {
            let controller = segue.destination as! AFYPhotoesCollectionViewController
            
            let button = sender as! UIButton
            let location = photoesLocations[button.tag]
            controller.imageLinks = location.imageLinks
        }
    }
    
    func revealRegionDetailsWithLongPressOnMap(_ sender: UILongPressGestureRecognizer)
    {
        if sender.state != UIGestureRecognizerState.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        currentLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
    }

    @IBAction func onPressedUseCurrentLocationButton(_ sender: Any)
    {
        getLocation()
    }
}

extension AFYMainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Location else {
            return nil
        }
        
        let identifier = ReuseIdentifier.location
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as! MKPinAnnotationView!
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView?.isEnabled = true
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = false
            annotationView?.pinTintColor = Color.pinTintColor
            annotationView?.tintColor = Color.tintColor
            
            let rightButton = UIButton(frame: annotationView!.frame)
            rightButton.setImage(#imageLiteral(resourceName: "icon_eye"), for: .normal)
            rightButton.addTarget(self, action: #selector(showPhotoes(_:)), for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = rightButton
        } else {
            annotationView?.annotation = annotation
        }
        
        let button = annotationView?.rightCalloutAccessoryView as! UIButton
        if let index = photoesLocations.index(of: annotation as! Location) {
            button.tag = index
        }
        
        return annotationView
    }
}

extension AFYMainViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

