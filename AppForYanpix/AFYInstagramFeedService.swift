//
//  AFYInstagramFeedService.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/5/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit
import Alamofire    

class AFYInstagramFeedService {
    
    struct EndPoint {
        static let baseUrl = "https://api.instagram.com/"
        static let authorize = "oauth/authorize/"
        static let clientID = "?client_id=08431964eb35440da7a047407968040d"
        static let redirectURI = "&redirect_uri=https://www.instagram.com/developer/clients/register/"
        static let responseTypeCode = "&response_type=code"
        static let responseTypeToken = "&response_type=token"
        static let accessToken = "#access_token="
        static let scope = "&scope="
        static let scopeBasic = "basic"
        static let scopePublicContent = "+public_content"
        static let scopeFollowerList = "+follower_list"
        static let scopeComments = "+comments"
        static let scopeRelationships = "+relationships"
        static let scopeLikes = "+likes"
        
        private init() {}
    }
    
//    enum JSONKey: String {
//        case email = "email"
//        case userName = "username"
//        case password = "password"
//        case avatar = "avatar"
//        case weather = "weather"
//        case image = "image"
//        case description = "description"
//        case hashtag = "hashtag"
//        case latitude = "latitude"
//        case longitude = "longitude"
//    }
    
    var tokenRequest: URLRequest? {
        let urlString = EndPoint.baseUrl + EndPoint.authorize + EndPoint.clientID
            + EndPoint.redirectURI + EndPoint.responseTypeCode + EndPoint.responseTypeToken
            + EndPoint.scope + EndPoint.scopeBasic + EndPoint.scopePublicContent
            + EndPoint.scopeFollowerList + EndPoint.scopeComments + EndPoint.scopeRelationships
            + EndPoint.scopeLikes
        guard let url = URL(string: urlString) else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    var needsShowCredentialsForm: Bool {
        return keychainService.getToken() == nil ? true : false
    }

    fileprivate let keychainService = AFYKeychainService()
    
    func saveToken(_from request: URLRequest)
    {
        let urlString: String = request.url!.absoluteString
        let urlParts: [String] = urlString.components(separatedBy: EndPoint.accessToken)
        if urlParts.count > 1 {
            let token = urlParts[1]
            print("***** token : \(token) ")
            keychainService.saveToken(token: token)
        }
    }
}
