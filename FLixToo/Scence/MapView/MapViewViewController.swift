//
//  MapViewViewController.swift
//  FLixToo
//
//  Created by NamTrinh on 09/09/2024.
//

import UIKit
import CoreLocation
import MapKit
import Reusable

class MapViewViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation!
    var locationTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let eiffelTowerLocation = CLLocation(latitude: 48.858042, longitude:  2.294793)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.showsUserLocation = true
        mapView.region = region
        addAnnotation()
    }
    
    func addAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        annotation.title = locationTitle
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func handleNavigateButton(_ sender: Any) {
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationTitle
        mapItem.openInMaps(launchOptions: options)
    }
    
}

extension MapViewViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.map
}
