//
//  AddressSearchViewController.swift
//  HeadingHome
//
//  Created by Mike Nelson on 7/11/17.
//
//

import UIKit
import MapKit


class AddressSearchViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet weak var navItem: UINavigationItem!
    
    var mapService: LocationManager?
    var searchController: UISearchController? = nil
    var selectedAddress: MKPlacemark? = nil
    var firstLocation: CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapService = LocationManager.sharedInstance
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "UserLocationChange"),
                                               object: nil,
                                               queue: nil) {
                                                _ in
                                                
                                                self.firstLocation = self.mapService?.getCurrentLocation()
                                                self.setUpMapView(location: self.firstLocation!)
                                                self.mapService?.locationManager.stopUpdatingLocation()
                                                
        }
        
        let searchTable = storyboard?.instantiateViewController(withIdentifier: "SearchResultsTable") as? SearchResultsTableViewController
        searchController = UISearchController(searchResultsController: searchTable)
        searchController?.searchResultsUpdater = searchTable

        let searchBar = searchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Address Search"
        navigationItem.titleView = searchController?.searchBar
        
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
        
        searchTable?.mapView = mapView
        searchTable?.handleMapSearchDelegate = self
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpMapView(location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView?.setRegion(region, animated: true)
    }
}

extension AddressSearchViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedAddress = placemark
        
        mapService?.saveHomeAddress(address: placemark)
        
        mapView?.removeAnnotations((mapView?.annotations)!)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = String(format: "%@ %@", city, state)
        }
        
        mapView?.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView?.setRegion(region, animated: true)
    }
}
