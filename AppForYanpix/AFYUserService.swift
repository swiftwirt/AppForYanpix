//
//  AFYUserService.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/8/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit

class AFYUserService {
    
    fileprivate let instagramFeedService = AFYInstagramFeedService()
    fileprivate var user: User?
    
    var userName: String? {
        return user?.username
    }
    
    var avatarLink: URL? {
        return user?.profilePicture
    }
    
    var userSavedPhotoLinks: [String]? {
        get {
            return user?.savedPhotoLinks
        }
        
        set {
            user?.savedPhotoLinks = userSavedPhotoLinks
        }
    }
    
    init(_with dictionary: [String: Any]) {
        user = User(_with: dictionary)
    }

}
