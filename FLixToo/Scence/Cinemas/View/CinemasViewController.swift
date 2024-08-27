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

class CinemasViewController: BaseViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var placesTableView: UITableView!
    
    var presenter: CinemasPresenterProtocol!

    private let disposeBag = DisposeBag()
    
    var matchingItems: [MKMapItem] = []
    var cenimas: [MKMapItem] = []
    var center = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
    var isShowCenimas = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        setupView()
    }
    
    private func setupView() {
        title = "Cinemas"
        showBackButton = false
        
        placesTableView.delegate = self
        placesTableView.dataSource = self
        placesTableView.register(cellType: PlaceTableViewCell.self)
        placesTableView.register(cellType: CenimaTableViewCell.self)
        
        locationTextField.rx.controlEvent(.editingChanged)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.locationTextField.text?.isEmpty ?? true {
                    self.isShowCenimas = true
                    SVProgressHUD.dismiss()
                    self.placesTableView.reloadData()
                } else {
                    self.isShowCenimas = false
                    self.searchForPlaces(text: self.locationTextField?.text ?? "")
                }
            }).disposed(by: disposeBag)
    }
    
    
    private func searchCenimas() {
        SVProgressHUD.show()
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
            self?.cenimas = response.mapItems
            self?.placesTableView.reloadData()
        }
    }
    
    func searchForPlaces(text: String) {
        SVProgressHUD.show()
        let request = MKLocalSearch.Request()
        request.pointOfInterestFilter = .includingAll
        request.resultTypes = [.address, .pointOfInterest]
        request.naturalLanguageQuery = text
        let search = MKLocalSearch(request: request)
        
        search.start { [weak self] response, _ in
            guard let response = response else {
                return
            }
            SVProgressHUD.dismiss()
            self?.matchingItems = response.mapItems
        }
        placesTableView.reloadData()
    }
}

extension CinemasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowCenimas {
            return cenimas.count
        }
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowCenimas {
            let cell: CenimaTableViewCell = tableView.dequeueReusableCell(for: indexPath, cellType: CenimaTableViewCell.self)
            let item = cenimas[indexPath.row]
            cell.configCell(title: item.name ?? "", address: item.placemark.title ?? "", indexPath: indexPath)
            return cell
        }
        let cell: PlaceTableViewCell = tableView.dequeueReusableCell(for: indexPath, cellType: PlaceTableViewCell.self)
        cell.configCell(title: matchingItems[indexPath.row].name ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isShowCenimas {
            center = matchingItems[indexPath.row].placemark.coordinate
            self.searchCenimas()
        }
    }
}

extension CinemasViewController:CinemasViewProtocol {
}

extension CinemasViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.cinemas
}
