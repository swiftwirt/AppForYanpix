//
//  AFYInstagramFeedService.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/5/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit
import Alamofire

enum InstagramFeedResult<T> {
    case success(T)
    case failure(Error)
}

class AFYInstagramFeedService {
    
    struct EndPoint {
        static let baseUrl = "https://api.instagram.com/"
        static let authorize = "oauth/authorize/"
        static let clientID = "?client_id=08431964eb35440da7a047407968040d"
        static let redirectURI = "&redirect_uri=https://www.instagram.com/developer/clients/register/"
        static let responseTypeCode = "&response_type=code"
        static let responseTypeToken = "&response_type=token"
        static let accessToken = "&access_token="
        static let separatorToken = "#access_token="
        static let questionToken = "?access_token="
        static let version = "v1/"
        static let users = "users/"
        static let userSelf = "self/"
        static let locations = "locations/"
        static let search = "search?"
        static let latitude = "lat="
        static let longitude = "&lng="
        static let recentMedia = "/media/recent?access_token="
        static let scope = "&scope="
        static let scopeBasic = "basic"
        static let scopePublicContent = "+public_content"
        static let scopeFollowerList = "+follower_list"
        static let scopeComments = "+comments"
        static let scopeRelationships = "+relationships"
        static let scopeLikes = "+likes"
        
        private init() {}
    }
    
    struct JSONKey {
        static let data = "data"
        
        private init() {}
    }
    
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
        let urlParts: [String] = urlString.components(separatedBy: EndPoint.separatorToken)
        if urlParts.count > 1 {
            let token = urlParts[1]
            print("***** token : \(token) ")
            keychainService.saveToken(token: token)
        }
    }
    
    func getPhotosFor(locationID: String, completionHandler: @escaping (InstagramFeedResult<Any>) -> ())
    {
        guard let token = keychainService.getToken() else { return }
        let url = EndPoint.baseUrl + EndPoint.version + EndPoint.locations + locationID + EndPoint.recentMedia + token
        // TODO: add normal error handling manager
        if Int(locationID) == 0 {
            
            enum Failure: Error {
                case noLocation
            }
            
            completionHandler(InstagramFeedResult.failure(Failure.noLocation))
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response: DataResponse<Any>) in
            switch(response.result) {
            case .success(let value):
                guard let dataDictionary = value as? [String: Any], let data = dataDictionary[JSONKey.data] as? [[String: Any]] else { return }
                completionHandler(InstagramFeedResult.success(data))
            case .failure(let error):
                completionHandler(InstagramFeedResult.failure(error))
            }
        }
    }
    
    func getLocationIDs(latitude: Float, and longitude: Float, completionHandler: @escaping (InstagramFeedResult<Any>) -> ())
    {
        guard let token = keychainService.getToken() else { return }
        let url = EndPoint.baseUrl + EndPoint.version + EndPoint.locations
            + EndPoint.search + EndPoint.latitude + String(latitude)
            + EndPoint.longitude + String(longitude) + EndPoint.accessToken + token
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(let value):
                guard let dataDictionary = value as? [String: Any], let data = dataDictionary[JSONKey.data] as? [[String: Any]] else { return }
                completionHandler(InstagramFeedResult.success(data))
            case .failure(let error):
                completionHandler(InstagramFeedResult.failure(error))
            }
        }
    }
    
    func getUserJSON(completionHandler: @escaping (InstagramFeedResult<Any>) -> ())
    {
        guard let token = keychainService.getToken() else { return }
        let url = EndPoint.baseUrl + EndPoint.version + EndPoint.users + EndPoint.userSelf + EndPoint.questionToken + token
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(let value):
                guard let dataDictionary = value as? [String: Any], let data = dataDictionary[JSONKey.data] as? [String: Any] else { return }
                completionHandler(InstagramFeedResult.success(data))
            case .failure(let error):
                completionHandler(InstagramFeedResult.failure(error))
            }
        }
    }
}
