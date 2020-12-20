//
//  User.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/18/20.
//

import Foundation

struct User: Codable {
    let account: Account
    let session: Session
}


struct Account: Codable {
    let registered: Bool
    let key: String
}


struct Session: Codable {
    let id: String
    let expiration: String
}
