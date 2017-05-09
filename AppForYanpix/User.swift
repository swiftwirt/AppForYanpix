//
//  User.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/8/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class User {
    
    struct JSONKey {
        static let id = "id"
        static let username = "username"
        static let fullName = "full_name"
        static let profilePicture = "profile_picture"
        static let bio = "bio"
        static let website = "website"
        
        private init() {}
    }
    
    var id: String?
    var username: String?
    var fullName: String?
    var profilePicture: URL?
    var bio: String?
    var website: URL?
    var savedPhotoLinks: [String]?
    
    init(_with dictionary: [String: Any])
    {
        guard let id = dictionary[JSONKey.id] as? String, let username = dictionary[JSONKey.username] as? String, let fullName = dictionary[JSONKey.fullName] as? String  else {
            self.id = ""
            return
        }
        
        self.id = id
        self.username = username
        self.fullName = fullName
        
        if let profilePicture = dictionary[JSONKey.profilePicture] as? String {
            self.profilePicture = URL(string: profilePicture)
        }
        
        if let bio = dictionary[JSONKey.bio] as? String {
            self.bio = bio
        }
        
        if let website = dictionary[JSONKey.website] as? String {
            self.website = URL(string: website)
        }
        
    }

}
