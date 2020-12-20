//
//  Endpoints.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/18/20.
//

import Foundation

enum Endpoints {
    static let baseUrl = "https://onthemap-api.udacity.com/v1/"
    
    case signIn
    case signOut
    case webAuth
    case getStudentLocations
    case postStudentLocation
    
    var stringValue: String {
        switch self {
        case .signIn:
            return Endpoints.baseUrl + "session"
            
        case .signOut:
            return Endpoints.baseUrl + "session"
            
        case .webAuth:
            return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
            
        case .getStudentLocations:
            return Endpoints.baseUrl + "StudentLocation?limit=100&order=-updatedAt"
            
        case .postStudentLocation:
            return Endpoints.baseUrl + "StudentLocation"
        }
    }
    
    var url: URL {
        return URL(string: stringValue)!
    }
}
