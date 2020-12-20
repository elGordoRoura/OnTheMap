//
//  OTMApi.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/18/20.
//

import UIKit
import CoreLocation

class OTMApi {
    
    static let shared = OTMApi()
    
    
    static func signIn(_ email: String,_ password: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request         = URLRequest(url: Endpoints.signIn.url)
        
        request.httpMethod  = "POST"
        request.httpBody    = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, resp, err in
            if let err = err {
                completion(.failure(err))
                return
            } else if let resp = resp as? HTTPURLResponse, resp.statusCode <= 200 && resp.statusCode >= 300 {
                print("Failed to login with statusCode: ", resp.statusCode)
                return
            } else {
                // Success
                let range = 5..<data!.count
                guard let data = data?.subdata(in: range) else { return }
                
                let jsonDecoder = JSONDecoder()
                
                do {
                    let response    = try jsonDecoder.decode(User.self, from: data)
                    let account     = response.account
                    
                    if account.registered == true {
                        let key = account.key
                        DispatchQueue.main.async { completion(.success(key)) }
                    }
                } catch let err {
                    completion(.failure(err))
                }
            }
        }.resume()
    }
    
    
    static func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        var request         = URLRequest(url: Endpoints.signOut.url)
        
        request.httpMethod  = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage     = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        URLSession.shared.dataTask(with: request) { data, resp, err in
            if let err = err {
                completion(.failure(err))
                return
            } else if let resp = resp as? HTTPURLResponse, resp.statusCode <= 200 && resp.statusCode >= 300 {
                print("Failed to login with statusCode: ", resp.statusCode)
                return
            } else {
                
                let range = 5..<data!.count
                guard let _ = data?.subdata(in: range) else { return }
                
                DispatchQueue.main.async { completion(.success(true)) }
            }
        }.resume()
    }
    
    
    func getStudentLocations(completion: @escaping (Result<[StudentLocation]?, Error>) -> Void){
        let request = URLRequest(url: Endpoints.getStudentLocations.url)
        
        URLSession.shared.dataTask(with: request) { data, resp, err in
            if let err = err {
                completion(.failure(err))
                return
            } else if let resp = resp as? HTTPURLResponse, resp.statusCode <= 200 && resp.statusCode >= 300 {
                print("Failed to login with statusCode: ", resp.statusCode)
                return
            } else {
                let jsonObject              = try! JSONSerialization.jsonObject(with: data!, options: [])
                guard let jsonDictionary    = jsonObject as? [String : Any] else {return}
                let resultsArray            = jsonDictionary["results"] as? [[String:Any]]
                
                guard let array             = resultsArray else {return}
                let dataObject              = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                let locations               = try! JSONDecoder().decode([StudentLocation].self, from: dataObject)
                completion(.success(locations))
            }
        }.resume()
    }
    
    
    func postStudentLocation(_ location: StudentLocation, completion: @escaping (Result<Bool, Error>) -> Void) {
        var request         = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod  = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "uniqueKey": location.uniqueKey ?? " ",
            "firstName": location.firstName ?? "firstName",
            "lastName": location.lastName ?? "lastName",
            "mapString" :location.mapString!,
            "mediaURL": location.mediaURL!,
            "latitude": location.latitude!,
            "longitude":location.longitude!,
        ]
        
        do {
            let jsonData        = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            request.httpBody    = jsonData
        
            URLSession.shared.dataTask(with: request as URLRequest) { data, resp, err in
                if let err = err {
                    completion(.failure(err))
                    return
                } else if let resp = resp as? HTTPURLResponse, resp.statusCode <= 200 && resp.statusCode >= 300 {
                    print("Failed to login with statusCode: ", resp.statusCode)
                    return
                } else if let data = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        guard let _ = jsonObject as? [String : Any] else {
                            return
                        }
                        DispatchQueue.main.async { completion(.success(true)) }
                    } catch let err {
                        completion(.failure(err))
                    }
                }
            }.resume()
        } catch let err {
            completion(.failure(err))
        }
    }
}
