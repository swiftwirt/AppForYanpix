//
//  AFYKeychainService.swift
//  AppForYanpix
//
//  Created by Ivashin Dmitry on 5/3/17.
//  Copyright © 2017 Ivashin Dmitry. All rights reserved.
//

import Foundation
import KeychainSwift

class AFYKeychainService
{
    struct Consts {
        static let token = "token"
        
        private init() {}
    }
    
    let keychain = KeychainSwift()
    
    func saveToken(token: String)
    {
        keychain.set(token, forKey: Consts.token)
    }
    
    func getToken() -> String?
    {
        guard let token = keychain.get(Consts.token) else {
            return nil
        }
        return token
    }
    
    func clear() {
        self.keychain.delete(Consts.token)
    }
}
