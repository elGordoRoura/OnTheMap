//
//  EGError.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/19/20.
//

import Foundation

enum EGError: String, Error {
    case failedToOpenURL            = "Failed to open url link. The link may be invalid."
    case invalidUsername            = "Invalid credentials. Please try again."
    case invalidAddLocationData     = "It seems as if one of the fields may be of incorrect format or left blank. Please try again."
    case failedToGetStudentLocation = "Failed to get student location information. Please try again."
    case somethingWentWrong         = "Something went wrong"
    case failedToSignOut            = "Bad connection. Please try to sign out again."
    case failedToGetLocation        = "Failed to determine location. Please try again."
    case failedToSaveUserLocation   = "Failed to save user location. Please try again."
}
