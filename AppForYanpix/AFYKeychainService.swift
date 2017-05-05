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
    enum Consts: String {
        case token = "token"
    }
    
    let keychain = KeychainSwift()
    
    func saveToken(token: String)
    {
        keychain.set(token, forKey: Consts.token.rawValue)
    }
    
    func getToken() -> String?
    {
        guard let token = keychain.get(Consts.token.rawValue) else {
            return nil
        }
        return token
    }
}
