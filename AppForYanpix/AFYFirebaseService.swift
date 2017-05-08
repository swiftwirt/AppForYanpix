//
//  AFYFirebaseService.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/8/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import UIKit
import Firebase

enum FirebaseResult<T> {
    case success(T)
    case failure(Error)
}

class AFYFirebaseService {
    
    struct JSONFirebaseKey {
        static let users = "users"
        static let photos = "photos"
        static let contentType = "image/png"
        
        private init() {}
    }
    
    fileprivate let storage = FIRStorage.storage()
    
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
            let text = snapshot.metadata?.downloadURL()?.absoluteString
            print(text ?? "no upload link")
        }
    }
}
