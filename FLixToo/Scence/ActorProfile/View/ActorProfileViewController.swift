//  
//  ActorProfileViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit
import Reusable
import Kingfisher
import MASegmentedControl

class ActorProfileViewController: BaseViewController {

    @IBOutlet weak var segmentControl: MASegmentedControl! {
        didSet {
            
            segmentControl.itemsWithText = true
            segmentControl.fillEqually = true
            segmentControl.bottomLineThumbView = true
            segmentControl.setSegmentedWith(items: ["Known For", "Biography"])
            segmentControl.padding = 4
            segmentControl.textColor = .white.withAlphaComponent(0.8)
            segmentControl.titlesFont = Typography.fontSemibold16
            segmentControl.selectedTextColor = UIColor(hex: "1A8BFB")
            segmentControl.thumbViewColor = UIColor(hex: "1A8BFB")
        }
    }
    @IBOutlet weak var heightInfo: ActorInfoView!
    @IBOutlet weak var knowForView: ActorInfoView!
    @IBOutlet weak var bornInfoView: ActorInfoView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameActorLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bounderBioView: UIView!
    
    var presenter: ActorProfilePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        presenter.onViewDidLoad()
        title = "Actor's Profile"
        nameActorLabel.text = presenter.commonInfo?.name
        nameActorLabel.font = Typography.fontSemibold18
        nameActorLabel.textColor = .white
        profileImageView.kf.setImage(
            with: Utils.getUrlImage(path: presenter.commonInfo?.profilePath ?? ""),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
        
        knowForView.setContentView(title: "Known For", content: presenter.commonInfo?.knowForDisplay ?? "", showLine: false)
        heightInfo.setContentView(title: "Height", content: "5'6", showLine: false)
        bioLabel.font = Typography.fontMedium14
        bioLabel.textColor = UIColor(hex: "C6C6C6")
        
        collectionView.isHidden = false
        bounderBioView.isHidden = true
        collectionView.register(cellType: MoviePosterCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .vertical
        collectionView.showsHorizontalScrollIndicator = false
        let itemWitdh = (Screen.width - 72) / 3
        let itemHeight = itemWitdh * 194/102 + 16
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        collectionView.collectionViewLayout = layout
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.cornerRadius = profileImageView.frame.width / 2
    }
    
    @IBAction func handleSwitchSegment(_ sender: MASegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5) {
                self.collectionView.isHidden = false
            } completion: { _ in
                self.bounderBioView.isHidden = true
            }

            
            
        } else {
            UIView.animate(withDuration: 0.5) {
                self.collectionView.isHidden = true
            } completion: { _ in
                self.bounderBioView.isHidden = false
            }
        }
    }
}

extension ActorProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.commonInfo?.knownFor?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let knowFor = presenter.commonInfo?.knownFor?[indexPath.row] else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
        cell.setContentForCell(data: knowFor)
        return cell
    }
}

extension ActorProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailViewController.instantiate()
        vc.presenter.id = presenter.commonInfo?.knownFor?[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ActorProfileViewController:ActorProfileViewProtocol {
    func updateActorDetail(data: ActorDetailInfo) {
        let birday = Utils.convertDateFormatString(dateString: data.birthday ?? "", inputFormat: "yyyy-MM-dd", outputFormat: "MMMM dd, yyyy")
        var born = "\(birday)"
        if let placeOfBirth = data.placeOfBirth {
            born += "\n\(placeOfBirth)"
        }
        bornInfoView.setContentView(title: "Born", content: born)
        bioLabel.text = data.biography
    }
    
    func showError(message: String) {
        showCommonError(message: message)
    }
}

extension ActorProfileViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.actorProfile
}
