//
//  MapController.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/18/20.
//

import UIKit
import MapKit

class MapController: UIViewController {
    
    let mapView             = MKMapView()
    
    var annotations         = [MKPointAnnotation]()
    
    var lastLocation: [MKPointAnnotation]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUsers(lastLocation: lastLocation)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtons()
        getUsers()
        
        mapView.delegate = self
        
        view.stack(mapView)
    }
    
    
    fileprivate func setupNavBarButtons() {
        let addNavBarButton: UIBarButtonItem        = .init(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(handleAddLocation))
        
        let refreshNavBarButton: UIBarButtonItem    = .init(barButtonSystemItem: .refresh,
                                                        target: self,
                                                        action: #selector(handleRefreshLocations))
        
        navigationItem.leftBarButtonItem            = .init(title: "Sign Out",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(handleSignOut))
        
        navigationItem.rightBarButtonItems          = [addNavBarButton, refreshNavBarButton]
    }
    
    
    func getUsers(lastLocation: [MKPointAnnotation]? = nil) {
        annotations.removeAll()
        
        OTMApi.shared.getStudentLocations { result in
            switch result {
            case .failure:
                self.presentEGAlertOnMainThread(title: "Error", message: EGError.failedToGetStudentLocation.rawValue, buttonTitle: "Ok")
                
            case .success(let locations):
                if lastLocation == nil {
                var annotations = [MKPointAnnotation]()
                guard let locationsArray = locations else {
                    self.presentEGAlertOnMainThread(title: "Error", message: EGError.somethingWentWrong.rawValue, buttonTitle: "Ok")
                    return
                }

                for location in locationsArray {
                    let longitude           = CLLocationDegrees (location.longitude ?? 0)
                    let latitude            = CLLocationDegrees (location.latitude ?? 0)
                    
                    let coordinates         = CLLocationCoordinate2D (latitude: latitude,
                                                                      longitude: longitude)
                    let mediaURL            = location.mediaURL ?? " "
                    let first               = location.firstName ?? " "
                    let last                = location.lastName ?? " "
                    
                    let annotation          = MKPointAnnotation()
                    annotation.coordinate   = coordinates
                    annotation.title        = "\(first) \(last)"
                    annotation.subtitle     = mediaURL
                    annotations.append (annotation)
                }
                self.mapView.addAnnotations (annotations)
                DispatchQueue.main.async { self.mapView.showAnnotations(annotations, animated: true) }
                } else {
                    let annotations = lastLocation!
                    self.mapView.addAnnotations (annotations)
                    DispatchQueue.main.async { self.mapView.showAnnotations(annotations, animated: true) }
                }
            }
        }
    }
    
    
    // MARK: - OBJC Functions
    
    @objc func handleAddLocation() {
        let addLocationVC   = AddLocationController()
        let navController   = UINavigationController(rootViewController: addLocationVC)
        present(navController, animated: true)
    }
    
    
    @objc func handleRefreshLocations() {
        DispatchQueue.main.async { self.getUsers() }
    }
    
    
    @objc func handleSignOut() {
        OTMApi.signOut { (result) in
            switch result {
            case .failure:
                self.presentEGAlertOnMainThread(title: "Error", message: EGError.failedToSignOut.rawValue, buttonTitle: "Ok")
                
            case .success:
                let loginController = LoginController()
                loginController.modalPresentationStyle = .fullScreen
                self.present(loginController, animated: true)
            }
        }
    }
}


// MARK: - MapController+MKMapViewDelegateEXT

extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView                             = MKPinAnnotationView(annotation: annotation,
                                                                      reuseIdentifier: reuseId)
            pinView?.canShowCallout             = true
            pinView?.pinTintColor               = .red
            pinView?.rightCalloutAccessoryView  = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let urlString = view.annotation?.subtitle! {
                openURL(urlString)
            }
        }
    }
}
