//
//  Location.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/5/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import Foundation
import SDWebImage
import MapKit

class Location: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var locationID: String = ""
    var imageLinks = [URL?]()
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String)
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    init(_with dictionary: [String: Any])
    {
        guard let user = dictionary["user"] as? [String: Any], let location = dictionary["location"] as? [String: Any], let imageDictionary = dictionary["images"] as? [String: Any]  else {
            self.title = ""
            self.subtitle = ""
            self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees.abs(0.0), longitude:  CLLocationDegrees.abs(0.0))
            super.init()
            return
        }
        
        let imageThumbnailDictionary = imageDictionary["thumbnail"] as! [String: Any]
        let link = imageThumbnailDictionary["url"] as! String
        
        self.imageLinks.append(URL(string: link))
        self.title = user["full_name"] as? String
        self.subtitle = location["name"] as? String
        self.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! Float64, longitude: location["longitude"] as! Float64)
        
        self.locationID = String(location["id"] as! UInt64)
        super.init()
    }
}
