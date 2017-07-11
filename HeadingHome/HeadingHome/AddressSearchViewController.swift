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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapService = LocationManager.sharedInstance
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "UserLocationChange"),
                                               object: nil,
                                               queue: nil) {
                                                _ in
                                                
                                                let current = self.mapService?.getCurrentLocation()
                                                self.setUpMapView(location: current!)
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
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpMapView(location: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        
        self.mapView?.setRegion(region, animated: true)
    }
}
