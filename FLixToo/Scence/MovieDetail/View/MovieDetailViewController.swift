//  
//  MovieDetailViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit
import Kingfisher
import Reusable

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var allBackdropImageView: UIImageView!
    @IBOutlet weak var backdropLabel: UILabel!
    @IBOutlet weak var heightOfSimilarCollectionView: NSLayoutConstraint!
    @IBOutlet weak var similarCollectionView: UICollectionView!
    @IBOutlet weak var actorTitleLabel: UILabel!
    @IBOutlet weak var heightOfActorCollectionView: NSLayoutConstraint!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    @IBOutlet weak var crewCollectionView: UICollectionView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var aboutMovieTitleLabel: UILabel!
    @IBOutlet weak var aboutMovieContentLabel: UILabel!
    @IBOutlet weak var addToLibraryButton: UIButton!
    @IBOutlet weak var watchTrailerButton: BaseFillButton!
    @IBOutlet weak var generLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var imdbScoreLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var similarMovieTitleLabel: UILabel!
    @IBOutlet weak var mediaTitleLabel: UILabel!
    
    var presenter: MovieDetailPresenterProtocol!
    var detail: MovieDetail?
    var cast = [Cast]()
    var crew = [Cast]()
    var similarMovies = [MovieCommonInfomation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        presenter.onViewDidLoad()
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
        aboutMovieContentLabel.font = Typography.fontRegular14
        aboutMovieContentLabel.textColor = .white
        actorTitleLabel.text = "Actors"
        actorTitleLabel.font = Typography.fontSemibold14
        actorTitleLabel.textColor = .white
        setUpActorsAndSimilarCollectionView()
        similarMovieTitleLabel.text = "More Movies like this"
        similarMovieTitleLabel.font = Typography.fontSemibold18
        similarMovieTitleLabel.textColor = .white
        mediaTitleLabel.text = "Media"
        mediaTitleLabel.font = Typography.fontSemibold18
        mediaTitleLabel.textColor = .white
        backdropLabel.font = Typography.fontSemibold18
        backdropLabel.textColor = .white
        setUpCrewCollectionView()
        setUpSimilarCollectionView()
        
    }
    
    @IBAction func handleTapAddToLibraryButton(_ sender: Any) {
    }
    
    @IBAction func handleTapWatchTrailerButton(_ sender: Any) {
    }
    
    @IBAction func handleTapClose(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension MovieDetailViewController:MovieDetailViewProtocol {
    func updateBackdrops(backdrop: BackdropsMovie) {
        let path = backdrop.backdrops?.randomElement()?.filePath ?? ""
        allBackdropImageView.kf.setImage(
                with: Utils.getUrlImage(path: path),
                options: [
                    .loadDiskFileSynchronously,
                    .cacheOriginalImage,
                    .transition(.fade(0.1)),
                ])
        allBackdropImageView.blurBottom()
        backdropLabel.text = "\(backdrop.backdrops?.count ?? 0) backdrops"
    }
    
    func updateListCredit(credit: MovieCredit) {
        self.cast = credit.cast ?? []
        self.crew = credit.crew ?? []
        actorCollectionView.reloadData()
        crewCollectionView.reloadData()
    }
    
    func updateMovieDetail(data: MovieDetail) {
        self.detail = data
        bindingData()
    }
    
    func updateSimilarMovies(movies: [MovieCommonInfomation]) {
        self.similarMovies = movies
        similarCollectionView.reloadData()
    }
    
    private func bindingData() {
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
        movieNameLabel.text = "\(data.originalTitle ?? "") (\(data.releaseDate?.prefix(4) ?? ""))"
        var generString = ""
        if let runtime = data.runtime {
            generString += "● \(Utils.calculateTime(runtime))"
        }
        if let generes = data.genres {
            for gen in generes {
                generString += "  ● \(gen.name ?? "")"
            }
        }
        generLabel.text = generString
        aboutMovieContentLabel.text = data.overview
        setLanguageLabel(data: data)
    }
    
    private func setLanguageLabel(data: MovieDetail) {
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
    
    private func setUpActorsAndSimilarCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        actorCollectionView.showsHorizontalScrollIndicator = false
        let itemWitdh = (Screen.width - 48) / 3.2
        let itemHeight = itemWitdh * 194/102 + 16
        heightOfActorCollectionView.constant = itemHeight + 8
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        actorCollectionView.collectionViewLayout = layout
        actorCollectionView.dataSource = self
        actorCollectionView.register(cellType: MoviePosterCell.self)
        
    }
    
    private func setUpSimilarCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        similarCollectionView.showsHorizontalScrollIndicator = false
        let itemWitdh = (Screen.width - 48) / 3.2
        let itemHeight = itemWitdh * 194/102 + 16
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        heightOfSimilarCollectionView.constant = itemHeight + 8
        similarCollectionView.collectionViewLayout = layout
        similarCollectionView.dataSource = self
        similarCollectionView.register(cellType: MoviePosterCell.self)
    }
    
    func showError(message: String) {
        showCommonError(message: message)
    }
}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == crewCollectionView {
            return crew.count
        } else if collectionView == actorCollectionView {
            return cast.count
        } else if collectionView == similarCollectionView {
            return similarMovies.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == crewCollectionView {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MovieCreditCollectionViewCell.self)
            cell.setContentForCell(crew: crew[indexPath.row])
            return cell
        } else if collectionView == actorCollectionView {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
            cell.setContentForCell(data: cast[indexPath.row])
            return cell
        } else if collectionView == similarCollectionView {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
            cell.setContentForCell(data: similarMovies[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension MovieDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.movieDetail
}
