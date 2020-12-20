//
//  FinalLocationController.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/18/20.
//

import UIKit
import MapKit

class FinalLocationController: UIViewController {
    
    var location: StudentLocation!
    
    private let mapView     = MKMapView()
    
    lazy var finishButton   = UIButton(title: "Finish",
                                       titleColor: .white,
                                       font: .boldSystemFont(ofSize: 18),
                                       backgroundColor: .black,
                                       target: self,
                                       action: #selector(handleDidAddLocation))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor    = .systemBackground
        title                   = "Add Location"
        
        mapView.delegate = self
        
        configureNavBar()
        configureUI()
        showLocations()
    }
    
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .cancel,
                                                 target: self,
                                                 action: #selector(handleCancel))
    }
    
    
    fileprivate func configureUI() {
        view.stack(mapView)
        
        finishButton.layer.cornerRadius = 25
        
        view.addSubview(finishButton)
        view.bringSubviewToFront(finishButton)
        finishButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            centerX: view.centerXAnchor,
                            padding: .init(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 0),
                            size: .init(width: 256,
                                        height: 50))
    }
    
    
    func createAnnotation(location: StudentLocation) -> MKPointAnnotation {
        let latitude            = CLLocationDegrees(location.latitude!)
        let longitude           = CLLocationDegrees(location.longitude!)
        let coordinate          = CLLocationCoordinate2D(latitude: latitude,
                                                         longitude: longitude)
        let annotation          = MKPointAnnotation()
        annotation.coordinate   = coordinate
        annotation.title        = location.mapString
        annotation.subtitle     = location.mediaURL
        return annotation
    }
    
    
    private func showLocations() {
        guard let location = location else { return }
        let annotation = createAnnotation(location: location)
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                               longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    
    // MARK: - OBJC Functions
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    
    @objc func handleDidAddLocation() {
        OTMApi.shared.postStudentLocation(location) { result in
            switch result {
            case .failure:
                self.presentEGAlertOnMainThread(title: "Error", message: EGError.failedToSaveUserLocation.rawValue, buttonTitle: "Ok")
                
            case .success(let isSuccess):
                if isSuccess {
                    if let location = self.location {
                        let annotation = self.createAnnotation(location: location)
                        let mapController = MapController()
                        mapController.mapView.addAnnotation(annotation)
                        mapController.lastLocation = [annotation]
                        
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
}


// MARK: - FinalLocationController+MKMapViewDelegateEXT

extension FinalLocationController: MKMapViewDelegate {
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
