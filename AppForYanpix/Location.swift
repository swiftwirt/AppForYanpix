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
    
    struct JSONKey {
        static let user = "user"
        static let location = "location"
        static let images = "images"
        static let thumbnail = "thumbnail"
        static let lowResolution = "low_resolution"
        static let standardResolution = "standard_resolution"
        static let url = "url"
        static let fullName = "full_name"
        static let name = "name"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let id = "id"
        
        private init() {}
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var locationID: String = ""
    var imageLink: URL?
    var lowResolutionImageLink: URL?
    var standartResolutionImageLink: URL?
    
    var relatedLocations = [Location]()
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String)
    {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    init(_with dictionary: [String: Any])
    {
        guard let user = dictionary[JSONKey.user] as? [String: Any], let location = dictionary[JSONKey.location] as? [String: Any], let imageDictionary = dictionary[JSONKey.images] as? [String: Any]  else {
            self.title = ""
            self.subtitle = ""
            self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees.abs(0.0), longitude:  CLLocationDegrees.abs(0.0))
            super.init()
            return
        }
        
        let imageThumbnailDictionary = imageDictionary[JSONKey.thumbnail] as! [String: Any]
        var link = imageThumbnailDictionary[JSONKey.url] as! String
        self.imageLink = URL(string: link)
        
        let imageLowResolutionDictionary = imageDictionary[JSONKey.lowResolution] as! [String: Any]
        link = imageLowResolutionDictionary[JSONKey.url] as! String
        self.lowResolutionImageLink = URL(string: link)
        
        let imageStandartResolutionDictionary = imageDictionary[JSONKey.standardResolution] as! [String: Any]
        link = imageStandartResolutionDictionary[JSONKey.url] as! String
        self.standartResolutionImageLink = URL(string: link)
        
        self.title = user[JSONKey.fullName] as? String
        self.subtitle = location[JSONKey.name] as? String
        self.coordinate = CLLocationCoordinate2D(latitude: location[JSONKey.latitude] as! Float64, longitude: location[JSONKey.longitude] as! Float64)
        
        self.locationID = String(location[JSONKey.id] as! UInt64)
        super.init()
    }
}
