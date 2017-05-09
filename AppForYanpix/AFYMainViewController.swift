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
    
    var output: AFYMainViewControllerInteractor!
    
    struct SegueIdentifier {
        static let toPhotoes = "SegueToPhotoes"
        
        private init() {}
    }
    
    struct ReuseIdentifier {
        static let location = "Location"
        
        private init() {}
    }
    
    struct Color {
        static let pinTintColor = UIColor(red: 161.0 / 255.0, green: 192.0 / 255.0, blue: 87.0 / 255.0, alpha: 1)
        static let tintColor = UIColor(white: 0.0, alpha: 0.5)
        
        private init() {}
    }
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var useCurrentLocationButton: UIButton!
    @IBOutlet weak var myLocationButton: UIButton!

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AFYMainViewControllerConfigurator.shared().configure(self)
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(revealRegionDetailsWithLongPressOnMap(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
        
        output.applicationManager.configureUser()
        
        configureMyLocationButton()
    }
    // MARK: - Main methods
    
    fileprivate func getLocation()
    {
        output.getLocation()
    }
    
    func revealRegionDetailsWithLongPressOnMap(_ sender: UILongPressGestureRecognizer)
    {
        if sender.state != UIGestureRecognizerState.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        output.currentLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
    }
    
    func showPhotoes(_ sender: UIButton)
    {
        performSegue(withIdentifier: SegueIdentifier.toPhotoes, sender: sender)
    }
    
    // MARK: - Configuration
    
    fileprivate func configureMyLocationButton()
    {
        myLocationButton.layer.cornerRadius = 5.0
        myLocationButton.layer.borderWidth = 2.0
        myLocationButton.layer.borderColor = UIColor.orange.cgColor
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.toPhotoes {
            let controller = segue.destination as! AFYPhotoesCollectionViewController
            
            let button = sender as! UIButton
            let location = output.photoesLocations[button.tag]
            controller.location = location
        }
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
        if let index = output.photoesLocations.index(of: annotation as! Location) {
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

