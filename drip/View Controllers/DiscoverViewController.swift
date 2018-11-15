//
//  DiscoverViewController.swift
//  drip
//
//  Created by Isom,Grant on 7/24/18.
//  Copyright © 2018 Grant Isom. All rights reserved.
//

import UIKit
import MapKit

class DiscoverViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var findShopsButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    @IBOutlet weak var searchText: UITextField!
    var matchingItems: [MKMapItem] = [MKMapItem]()
    let regionRadius: CLLocationDistance = 1000
    let reuseIdentifier = "pin"
    var currentAnnotation: MKAnnotation?
    var mapItems = [MKMapItem]()

    @IBOutlet weak var openInMapsButton: UIButton!
    @IBOutlet weak var coffeeStoreButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        findShopsButton.layer.masksToBounds = false
        findShopsButton.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        findShopsButton.layer.shadowRadius = 3
        findShopsButton.layer.shadowColor = UIColor.lightGray.cgColor
        findShopsButton.layer.shadowOpacity = 0.4
        findShopsButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        findShopsButton.layer.cornerRadius = 3
        let radius = findShopsButton.layer.cornerRadius
        findShopsButton.layer.shadowPath = UIBezierPath(roundedRect: findShopsButton.bounds, cornerRadius: radius).cgPath
        currentLocationButton.layer.masksToBounds = false
        currentLocationButton.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        currentLocationButton.layer.shadowRadius = 3
        currentLocationButton.layer.shadowColor = UIColor.lightGray.cgColor
        currentLocationButton.layer.shadowOpacity = 0.4
        currentLocationButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        currentLocationButton.layer.cornerRadius = 3
        currentLocationButton.layer.shadowPath = UIBezierPath(roundedRect: currentLocationButton.bounds, cornerRadius: radius).cgPath
        openInMapsButton.isHidden = true
        coffeeStoreButton.isHidden = true
        openInMapsButton.layer.masksToBounds = false
        openInMapsButton.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        openInMapsButton.layer.shadowRadius = 3
        openInMapsButton.layer.shadowColor = UIColor.lightGray.cgColor
        openInMapsButton.layer.shadowOpacity = 0.4
        openInMapsButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        openInMapsButton.layer.cornerRadius = 3
        openInMapsButton.layer.shadowPath = UIBezierPath(roundedRect: openInMapsButton.bounds, cornerRadius: radius).cgPath
        coffeeStoreButton.layer.masksToBounds = false
        coffeeStoreButton.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        coffeeStoreButton.layer.shadowRadius = 3
        coffeeStoreButton.layer.shadowColor = UIColor.lightGray.cgColor
        coffeeStoreButton.layer.shadowOpacity = 0.4
        coffeeStoreButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        coffeeStoreButton.layer.cornerRadius = 3
        coffeeStoreButton.layer.shadowPath = UIBezierPath(roundedRect: currentLocationButton.bounds, cornerRadius: radius).cgPath
    }
    
    @IBAction func findShopsButtonPressed(_ sender: Any) {
        performSearch()
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func openInMaps(_ sender: Any) {
        for mapItem in mapItems {
            if currentAnnotation?.title == mapItem.name {
                mapItem.openInMaps(launchOptions: nil)
            }
        }
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = mapView.userLocation.coordinate
        mapRegion.span.latitudeDelta = 0.1
        mapRegion.span.longitudeDelta = 0.1
        mapView.setRegion(mapRegion, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation?.title == "My Location" {
            return
        }
        openInMapsButton.isHidden = false
        coffeeStoreButton.isHidden = false
        coffeeStoreButton.setTitle((view.annotation?.title)!, for: .normal)
        coffeeStoreButton.setTitle((view.annotation?.title)!, for: .selected)
        currentAnnotation = view.annotation
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title == "My Location" {
            return nil
        } else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.pinTintColor = UIColor.black
            return annotationView
        }
    }
    
   func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        var i = -1;
        for view in views {
            i += 1;
            if view.annotation is MKUserLocation {
                continue;
            }
            let point:MKMapPoint  =  MKMapPoint(view.annotation!.coordinate);
            if (!self.mapView.visibleMapRect.contains(point)) {
                continue;
            }
            let endFrame:CGRect = view.frame;
            view.frame = CGRect(origin: CGPoint(x: view.frame.origin.x,y :view.frame.origin.y-self.view.frame.size.height), size: CGSize(width: view.frame.size.width, height: view.frame.size.height))
            let delay = 0.03 * Double(i)
            UIView.animate(withDuration: 0.5, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations:{() in
                view.frame = endFrame
            }, completion:{(Bool) in
                UIView.animate(withDuration: 0.05, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations:{() in
                    view.transform = CGAffineTransform(scaleX: 1.0, y: 0.6)
                }, completion: {(Bool) in
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations:{() in
                        view.transform = CGAffineTransform.identity
                    }, completion: nil)
                })
            })
        }
    }
    
    func performSearch() {
        
        matchingItems.removeAll()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "coffee"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
            if let results = response {
                
                if let err = error {
                    print("Error occurred in search: \(err.localizedDescription)")
                } else if results.mapItems.count == 0 {
                    print("No matches found")
                } else {
                    print("Matches found")
                    
                    for item in results.mapItems {
                        self.mapItems = results.mapItems
                        print("Name = \(item.name ?? "No match")")
                        print("Phone = \(item.phoneNumber ?? "No Match")")
                        self.matchingItems.append(item as MKMapItem)
                        print("Matching items = \(self.matchingItems.count)")
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        })
    }

}
