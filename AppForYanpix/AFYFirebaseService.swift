//
//  AFYFirebaseService.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/8/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

enum FirebaseResult<T> {
    case success(T)
    case failure(Error?)
}

class AFYFirebaseService {
    
    struct EndPoint {
        static let baseUrl = "https://appforyanpix.firebaseio.com/"
        static let postfix = ".json"
        
        private init() {}
    }
    
    struct JSONFirebaseKey {
        static let users = "users"
        static let photos = "photos"
        static let contentType = "image/png"
        static let imageLInks = "ImageLinks"
        
        private init() {}
    }
    
    fileprivate let storage = FIRStorage.storage()
    fileprivate let database = FIRDatabase.database()
    
    var observerResult: ((FirebaseResult<Any>) -> ())?
    
    func upload(_ image: UIImage, for user: String, completionHandler: @escaping (FirebaseResult<Any>) -> ())
    {
        let imageData = UIImagePNGRepresentation(image)!
        
        let users = storage.reference().child(JSONFirebaseKey.users)
        let currentUser = users.child(user)
        let photosRef = currentUser.child(JSONFirebaseKey.photos)
        let photoRef = photosRef.child("\(NSUUID().uuidString).png")
        
        // Upload file to Firebase Storage
        let metadata = FIRStorageMetadata()
        metadata.contentType = JSONFirebaseKey.contentType
        photoRef.put(imageData, metadata: metadata).observe(.success) { (snapshot) in
            // When the image has successfully uploaded, we get it's download URL
            if let text = snapshot.metadata?.downloadURL()?.absoluteString {
                print(text)
                completionHandler(FirebaseResult.success(text))
            } else {
                completionHandler(FirebaseResult.failure(nil))
            }
        }
    }
    
    func save(_ string: String, for user: String)
    {
        let databaseRef = database.reference()
        databaseRef.child(JSONFirebaseKey.imageLInks)
        let userRef = databaseRef.child(user)
        let imageRef = userRef.childByAutoId()
        imageRef.setValue(string)
        
        userRef.observe(.value, with: { snapshot in
            var links: [String] = []
            for item in snapshot.children {
                guard let snapshot = item as? FIRDataSnapshot, let link = snapshot.value as? String else { continue }
                
                links.append(link)
            }
            if let observer = self.observerResult {
                observer(FirebaseResult.success(links))
            }
        })
    }
    
    func getAllSavedPhotoLinks(for user: String, completionHandler: @escaping (FirebaseResult<Any>) -> ())
    {
        let url = EndPoint.baseUrl + user + EndPoint.postfix
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response: DataResponse<Any>) in
            switch(response.result) {
            case .success(let value):
                completionHandler(FirebaseResult.success(value))
            case .failure(let error):
                completionHandler(FirebaseResult.failure(error))
            }
        }
    }
}
