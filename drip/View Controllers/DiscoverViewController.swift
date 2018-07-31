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
    }
    
    @IBAction func findShopsButtonPressed(_ sender: Any) {
        performSearch()
    }
    
    @IBAction func currentLocationButtonPressed(_ sender: Any) {
        locationManager.startUpdatingLocation()
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
    
    func performSearch() {
        
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
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
                        print("Name = \(item.name ?? "No match")")
                        print("Phone = \(item.phoneNumber ?? "No Match")")
                        if (!(item.name?.lowercased().contains("starbucks"))!) {
                            self.matchingItems.append(item as MKMapItem)
                            print("Matching items = \(self.matchingItems.count)")
                        }
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
