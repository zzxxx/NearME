//
//  PlacesNearMeViewController
//  NearMe
//
//  Created by User on 03.03.2018.
//  Copyright © 2018 SMS. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

//landpulling

class PlacesNearMeViewController: UITableViewController {
    
    var detailViewController: PlaceOnMapViewController? = nil
    
    private var currentLocation: CLLocation? {
        didSet{
            loadPlaces()
        }
    }
    
    private var objects = [Place]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Near Me"
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(fetchLocation), for: UIControlEvents.valueChanged)
        tableView.refreshControl = control
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? PlaceOnMapViewController
        }
        
        fetchLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
   
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSegueDetailIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! PlaceOnMapViewController
                controller.coordinates = object.coordinates
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func loadFake(_ sender: Any) {
        currentLocation = CLLocation(latitude: 52.531, longitude: 13.3843)
        loadPlaces()
    }
    
    @IBAction func loadReal(_ sender: Any) {
        fetchLocation()
    }
}

//MARK: - NEtwork / location
extension PlacesNearMeViewController {
    private func loadPlaces() {
        if let location = currentLocation {
            Facade.instance.networkManager.loadPlaces(with: location, withCompletion: {[unowned self] (places, error) in
                guard let freshPlaces = places,
                error == nil
                    else {
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        return
                }
                self.objects = freshPlaces
            })
        }
    }
    
    @objc func fetchLocation() {
        tableView.refreshControl?.endRefreshing()
        Facade.instance.locationManager.getCurrentLocation {[weak self] (location, error) in
            if let freshLocation = location {
                self?.currentLocation = freshLocation
            } else if let error = error {
                if error.code == 777 {
                    print("Location not allowed")
                }
            }
        }
    }
}


// MARK: - TableViewDatasource/Delegate
extension PlacesNearMeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kPlaceCellIdentifier, for: indexPath) as! PlaceTableViewCell
        
        let place = objects[indexPath.row]
        setupCell(cell, with: place)
        return cell
    }
}

// MARK: - Cell Setup
extension PlacesNearMeViewController {
    private func setupCell(_ cell: PlaceTableViewCell, with place: Place) {
        cell.labelName.text = place.name
        cell.labelAddress.text = place.address
        cell.labelDistance.text = place.distanceString()
        cell.labelCoordinates.text = place.coordinatesString()
        Alamofire.request(URL(string:"\(place.iconURL)")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).response { (response) in
            guard
            let data = response.data,
            let image = UIImage(data: data)
                else {
                    print("error when load image")
                    return
            }
            DispatchQueue.main.async {
                cell.iconImage.image = image
            }
        }
    }
}



//Develop an iOS application which:
//
//1.       Starts from a web service a json/xml for locations/restaurants/POI/or else
//
//Ex: https://places.demo.api.here.com/places/v1/discover/around?Geolocation=geo%3A52.531%2C13.3843&app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg
//
//2.       Parse json/xml-ul and save each restaurant in custom object (is ok dictionary, but it’s preferred a dedicated object). Name, address, coordinates and picture.
//
//3.       Displays the list in a table view with custom cells – that should contain the photo/icon, name, address and coordinates.
//
//4.       When click on the cell – navigate to another desktop that has a MapView – where there is a pin with the restaurant’s coordinates.
//
//5.       Bonus request: the map to fade in, API call – to be done with the current device coordinates, and the cell’s layout to be easy to read (iOS Design Guidelines)

