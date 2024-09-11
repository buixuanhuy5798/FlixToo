//  
//  CinemasViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Reusable
import MapKit
import RxSwift
import RxCocoa
import SVProgressHUD
import CoreLocation
import GoogleMobileAds

class CinemasViewController: BaseViewController {

    @IBOutlet weak var placesTableView: UITableView!
    
    var bannerView: GADBannerView = {
        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
        var view = GADBannerView(adSize: adaptiveSize)
        return view
    }()
    
    var presenter: CinemasPresenterProtocol!

    private let disposeBag = DisposeBag()
    
    var matchingItems: [MKMapItem] = []
    var cenimas: [MKMapItem] = []
  
    var isShowCenimas = false
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        setupView()
    }
    
    private func setupView() {
        addBannerViewToView(bannerView)
        bannerView.adUnitID = AppConstant.googleAdUnitID
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
        
        title = "Cinemas"
        showBackButton = false
        
        placesTableView.delegate = self
        placesTableView.dataSource = self
        placesTableView.register(cellType: PlaceTableViewCell.self)
        placesTableView.register(cellType: CenimaTableViewCell.self)
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: view.safeAreaLayoutGuide,
                            attribute: .bottom,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
    
    private func searchCenimas(location: CLLocation) {
        SVProgressHUD.show()
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "cinema" // Or "movie theater"
        request.region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            if let error = error {
                print("Error searching for cinemas: \(error.localizedDescription)")
                return
            }
            guard let response = response else { return }
            SVProgressHUD.dismiss()
            self?.isShowCenimas = true
            self?.matchingItems = response.mapItems
            self?.cenimas = response.mapItems
            self?.placesTableView.reloadData()
        }
    }
    
    func searchForPlaces(text: String) {
        if text.isEmpty {
            matchingItems = cenimas
        } else {
            matchingItems = cenimas.filter { item in
                item.name?.lowercased().contains(text.lowercased()) ?? false
            }
        }
        placesTableView.reloadData()
    }
}

extension CinemasViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied")
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        print("Latitude: \(latitude), Longitude: \(longitude)")
        searchCenimas(location: location)
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}

extension CinemasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CenimaTableViewCell = tableView.dequeueReusableCell(for: indexPath, cellType: CenimaTableViewCell.self)
        let item = matchingItems[indexPath.row]
        cell.configCell(title: item.name ?? "", address: item.placemark.title ?? "", indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MapViewViewController.instantiate()
        let item = matchingItems[indexPath.row]
        vc.location = item.placemark.location
        vc.locationTitle = item.placemark.name
        self.present(vc, animated: true)
    }
}

extension CinemasViewController:CinemasViewProtocol {
}

extension CinemasViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.cinemas
}
