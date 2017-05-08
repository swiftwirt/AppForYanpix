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
    
    init(_with dictionary: [String: Any]) {
        user = User(_with: dictionary)
    }

}
