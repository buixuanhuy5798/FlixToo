//
//  ShowDetailViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 31/08/2024.
//

import UIKit
import RxSwift
import Reusable

class ShowDetailViewController: UIViewController {

    @IBOutlet weak var heightOfActorCollectionView: NSLayoutConstraint!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    @IBOutlet weak var actorTitleLabel: UILabel!
    @IBOutlet weak var heightOfSeasonCollectionView: NSLayoutConstraint!
    @IBOutlet weak var seasonCollectionView: UICollectionView!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var aboutMovieContentLabel: UILabel!
    @IBOutlet weak var aboutMovieTitleLabel: UILabel!
    @IBOutlet weak var addToLibraryButton: UIButton!
    @IBOutlet weak var watchTrailerButton: BaseFillButton!
    @IBOutlet weak var generLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var imdbScoreLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var crewCollectionView: UICollectionView!
    var repository = MovieRepository(APIService())
    private let disposebag = DisposeBag()
    var id: Int?
    var crew = [Cast]()
    var cast = [Cast]()
    
    var detail: ShowDetail? {
        didSet {
            guard let data = detail else { return }
            backdropImageView.kf.setImage(
                with: Utils.getUrlImage(path: data.backdropPath ?? ""),
                options: [
                    .loadDiskFileSynchronously,
                    .cacheOriginalImage,
                    .transition(.fade(0.1)),
                ])
            let voteAverage = String(format: "%.1f", (data.voteAverage ?? 0))
            imdbScoreLabel.text = "(\(voteAverage)/10)"
            movieNameLabel.text = "\(data.originalName ?? "") (\(data.firstAirDate?.prefix(4) ?? ""))"
            var generString = ""
          
            if let generes = data.genres {
                for gen in generes {
                    generString += "  ● \(gen.name ?? "")"
                }
            }
            generLabel.text = generString
            aboutMovieContentLabel.text = data.overview
            setLanguageLabel(data: data)
            seasonCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setUpView()
        guard let id = id else { return }
        repository.getShowDetail(id: id).subscribe(onSuccess: { [weak self] response in
            self?.detail = response
        }, onFailure: { [weak self] error in
            if let error = error as? APIErrorResponse {
                self?.showCommonError(message: error.message ?? "")
            } else {
                self?.showCommonError(message: error.localizedDescription)
            }
        })
        .disposed(by: disposebag)
        repository.getShowCredit(id: id).subscribe(onSuccess: { [weak self] response in
            self?.cast = response.cast ?? []
            self?.crew = response.crew ?? []
            self?.actorCollectionView.reloadData()
            self?.crewCollectionView.reloadData()
        })
        .disposed(by: disposebag)
    }
    
    private func setUpView() {
        imdbScoreLabel.textColor = .white
        imdbScoreLabel.font = Typography.fontMedium14
        movieNameLabel.textColor = .white
        movieNameLabel.font = Typography.fontSemibold20
        generLabel.textColor = UIColor(hex: "D9D9D9")
        generLabel.font = Typography.fontMedium14
        watchTrailerButton.setTitle("Watch Trailers", for: .normal)
        addToLibraryButton.titleLabel?.font = Typography.fontSemibold14
        aboutMovieTitleLabel.font = Typography.fontSemibold14
        aboutMovieTitleLabel.textColor = .white
        seasonLabel.font = Typography.fontSemibold14
        seasonLabel.textColor = .white
        actorTitleLabel.font = Typography.fontSemibold14
        actorTitleLabel.textColor = .white
        aboutMovieContentLabel.font = Typography.fontRegular14
        aboutMovieContentLabel.textColor = .white
        setUpCrewCollectionView()
        setUpActorsAndSimilarCollectionView()
    }
    

    @IBAction func handleTapWatchTrailerButton(_ sender: Any) {
        let vc = MovieTrailerController.instantiate()
        vc.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleTapAddToLibrary(_ sender: Any) {
        let vc = AddToLibraryControllerViewController.instantiate()
        vc.item = SaveData(id: self.detail?.id, name: self.detail?.originalName, imagePath: self.detail?.posterPath, type: .show)
        vc.modalTransitionStyle = .coverVertical
        navigationController?.presentPanModal(vc)
    }
    
    @IBAction func handleTapClose(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpCrewCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        crewCollectionView.showsHorizontalScrollIndicator = false
        let itemWitdh = (Screen.width - 48) / 3
        let itemHeight = CGFloat(50)
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        crewCollectionView.collectionViewLayout = layout
        crewCollectionView.dataSource = self
        crewCollectionView.register(cellType: MovieCreditCollectionViewCell.self)
    }
    
    private func setLanguageLabel(data: ShowDetail) {
        var langString = ""
        if let spokenLanguages = data.spokenLanguages, !spokenLanguages.isEmpty {
            langString = spokenLanguages.map { $0.englishName ?? "" }.joined(separator: ", ")
        }
        let fullText = "Language: \(langString)"
        
        languageLabel.textColor = .white
        languageLabel.font = Typography.fontRegular14
        
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [NSAttributedString.Key.font: Typography.fontRegular14 ?? UIFont.systemFont(ofSize: 12),
                                                                                        NSAttributedString.Key.foregroundColor: UIColor.white])
        let titleRange = (fullText as NSString).range(of: "Language:")
        attributedString.setAttributes([NSAttributedString.Key.font: Typography.fontSemibold14 ?? UIFont.systemFont(ofSize: 12),
                                        NSAttributedString.Key.foregroundColor: UIColor.white],
                                       range: titleRange)
        languageLabel.attributedText = attributedString
    }
    
    private func setUpActorsAndSimilarCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        seasonCollectionView.showsHorizontalScrollIndicator = false
        let itemWitdh = (Screen.width - 48) / 3.2
        let itemHeight = itemWitdh * 194/102 + 16
        heightOfSeasonCollectionView.constant = itemHeight + 8
        heightOfActorCollectionView.constant = itemHeight + 8
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        seasonCollectionView.collectionViewLayout = layout
        seasonCollectionView.dataSource = self
//        seasonCollectionView.delegate = self
        seasonCollectionView.register(cellType: MoviePosterCell.self)
        actorCollectionView.collectionViewLayout = layout
        actorCollectionView.dataSource = self
//        actorCollectionView.delegate = self
        actorCollectionView.register(cellType: MoviePosterCell.self)
    }
}

extension ShowDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.movieDetail
}


extension ShowDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == crewCollectionView {
            return crew.count
        } else if collectionView == seasonCollectionView {
            return detail?.seasons?.count ?? 0
        } else if collectionView == actorCollectionView {
            return cast.count
        }
//        else if collectionView == actorCollectionView {
//            return cast.count
//        } else if collectionView == similarCollectionView {
//            return similarMovies.count
//        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == crewCollectionView {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MovieCreditCollectionViewCell.self)
            cell.setContentForCell(crew: crew[indexPath.row])
            return cell
        } else if collectionView == seasonCollectionView {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
            if let season = detail?.seasons?[indexPath.row] {
                cell.setContentForCell(data: season)
            }
            return cell
        } else if collectionView == actorCollectionView {
           let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
           cell.setContentForCell(data: cast[indexPath.row])
           return cell
       }
//        else if collectionView == similarCollectionView {
//            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
//            cell.setContentForCell(data: similarMovies[indexPath.row])
//            return cell
//        }
        return UICollectionViewCell()
    }
}
