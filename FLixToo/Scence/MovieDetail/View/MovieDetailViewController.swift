//  
//  MovieDetailViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit
import Kingfisher
import Reusable
import PanModal
import ExpandableLabel
import GoogleMobileAds
import Google_Mobile_Ads_SDK

class MovieDetailViewController: UIViewController, GADFullScreenContentDelegate {

    @IBOutlet weak var streamOnCollectionView: UICollectionView!
    @IBOutlet weak var streamOnLabel: UILabel!
    @IBOutlet weak var heightOfCommentTableView: NSLayoutConstraint!
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
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
    
    private var interstitial: GADInterstitialAd?
    
    var presenter: MovieDetailPresenterProtocol!
    var detail: MovieDetail?
    var cast = [Cast]()
    var crew = [Cast]()
    var similarMovies = [MovieCommonInfomation]()
    var comment = [Comment]()
    var backdrop: BackdropsMovie?
    var states = [Bool]()
    var streamOn = [Flatrate]()
    
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
        allBackdropImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapAllBackdrop)))
        allBackdropImageView.isUserInteractionEnabled = true
        setUpTableView()
        heightOfCommentTableView.constant = Screen.height * 1/3
        setUpStreamOnCollectionView()
        streamOnLabel.text = "Stream on"
        streamOnLabel.textColor = UIColor(hex: "1A8BFB")
        streamOnLabel.font = Typography.fontRegular14
        setUpAddToLibraryButton()
        
        UserInfomation.numberTouch += 1
        if UserInfomation.numberTouch == 2 {
            UserInfomation.numberTouch = 0
            Interstitial.shared.showInterstitialAds()
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        tabBarController?.tabBar.isHidden = false
//    }
    
    @objc private func handleTapAllBackdrop() {
        let vc = MovieBackdropImageShowControllerViewController.instantiate()
        vc.backdrop = backdrop
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func handleTapSeeAll(_ sender: Any) {
        let vc = CommentViewController.instantiate()
        vc.id = self.detail?.id
        vc.type = .movie
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleTapAddToLibraryButton(_ sender: Any) {
        let vc = AddToLibraryControllerViewController.instantiate()
        vc.item = SaveData(id: self.detail?.id, name: self.detail?.originalTitle, imagePath: self.detail?.posterPath, type: .movie)
        vc.modalTransitionStyle = .coverVertical
        vc.willDismiss = { [weak self] in
            self?.setUpAddToLibraryButton()
        }
        navigationController?.presentPanModal(vc)
    }
    
    @IBAction func handleTapWatchTrailerButton(_ sender: Any) {
        let vc = MovieTrailerController.instantiate()
        vc.id = presenter.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleTapClose(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension MovieDetailViewController:MovieDetailViewProtocol {
    func updateComment(comment: [Comment]) {
        self.comment = comment
        self.states = [Bool](repeating: true, count: comment.count)
        commentTableView.reloadData()
        if comment.isEmpty {
            heightOfCommentTableView.constant = 0
            seeAllButton.isHidden = true
            reviewTitleLabel.isHidden = true
        }
    }
    
    func updateBackdrops(backdrop: BackdropsMovie) {
        self.backdrop = backdrop
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
        if backdrop.backdrops?.isEmpty == true {
            mediaTitleLabel.isHidden = true
            backdropLabel.isHidden = true
            allBackdropImageView.isHidden = true
        }
    }
    
    func updateListCredit(credit: MovieCredit) {
        self.cast = credit.cast ?? []
        self.crew = credit.crew ?? []
        actorCollectionView.reloadData()
        crewCollectionView.reloadData()
        if self.cast.isEmpty == true {
            self.heightOfActorCollectionView.constant = 0
            self.actorTitleLabel.isHidden = true
        }
    }
    
    func updateMovieDetail(data: MovieDetail) {
        self.detail = data
        bindingData()
    }
    
    func updateSimilarMovies(movies: [MovieCommonInfomation]) {
        self.similarMovies = movies
        similarCollectionView.reloadData()
        if similarMovies.isEmpty == true {
            self.heightOfSimilarCollectionView.constant = 0
            self.similarMovieTitleLabel.isHidden = true
        }
    }
    
    func updateStreamOn(data: MovieStreamOn) {
        streamOn = data.results?.gb?.buy ?? []
        streamOnCollectionView.reloadData()
        if streamOn.isEmpty == true {
            streamOnCollectionView.isHidden = true
            streamOnLabel.isHidden = true
        } else {
            streamOnLabel.isHidden = false
        }
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
        } else {
            languageLabel.isHidden = true
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
        actorCollectionView.delegate = self
        actorCollectionView.register(cellType: MoviePosterCell.self)
    }
    
    private func setUpStreamOnCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        streamOnCollectionView.showsHorizontalScrollIndicator = false
        layout.itemSize = CGSize(width: 40, height: 40)
        streamOnCollectionView.collectionViewLayout = layout
        streamOnCollectionView.dataSource = self
        streamOnCollectionView.delegate = self
        streamOnCollectionView.register(cellType: MovieProviderCell.self)
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
        similarCollectionView.delegate = self
        similarCollectionView.register(cellType: MoviePosterCell.self)
    }
    
    private func setUpTableView() {
        commentTableView.register(cellType: CommentCell.self)
        commentTableView.dataSource = self
        commentTableView.rowHeight = UITableView.automaticDimension
    }
    
    func showError(message: String) {
        showCommonError(message: message)
    }
    
    func setUpAddToLibraryButton() {
        let spacing: CGFloat = 8; // the amount of spacing to appear between image and title
        addToLibraryButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing);
        addToLibraryButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0);
        
        if UserInfomation.favList.contains(where: { $0.id == presenter.id }) {
            addToLibraryButton.setImage(UIImage(named: "icon_fav"), for: .normal)
            addToLibraryButton.setTitle("Favourites", for: .normal)
        } else if UserInfomation.watchLaterList.contains(where: { $0.id == presenter.id }) {
            addToLibraryButton.setImage(UIImage(named: "ic_watch_later"), for: .normal)
            addToLibraryButton.setTitle("Watch-later", for: .normal)
        } else if UserInfomation.watchedList.contains(where: { $0.id == presenter.id }) {
            addToLibraryButton.setImage(UIImage(named: "ic_watched"), for: .normal)
            addToLibraryButton.setTitle("Watched", for: .normal)
        } else if UserInfomation.dislikeList.contains(where: { $0.id == presenter.id }) {
            addToLibraryButton.setImage(UIImage(named: "ic_disliked"), for: .normal)
            addToLibraryButton.setTitle("Disliked", for: .normal)
        } else {
            addToLibraryButton.setImage(nil, for: .normal)
            addToLibraryButton.setTitle("+ Add To Library", for: .normal)
        }
    }
}

extension MovieDetailViewController: ExpandableLabelDelegate {
    func willExpandLabel(_ label: ExpandableLabel) {
        commentTableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: commentTableView)
        if let indexPath = commentTableView.indexPathForRow(at: point) as IndexPath? {
            states[indexPath.row] = false
            DispatchQueue.main.async { [weak self] in
                self?.commentTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        commentTableView.endUpdates()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        commentTableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: commentTableView)
        if let indexPath = commentTableView.indexPathForRow(at: point) as IndexPath? {
            states[indexPath.row] = true
            DispatchQueue.main.async { [weak self] in
                self?.commentTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        commentTableView.endUpdates()
    }
}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CommentCell.self)
        cell.setContentForCell(comment: comment[indexPath.row], showSeparaterView: indexPath.row + 1 != comment.count)
        cell.contentLabel.delegate = self
        cell.contentLabel.collapsed = states[indexPath.row]
        return cell
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
        }  else if collectionView == streamOnCollectionView {
            return streamOn.count
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
        } else if collectionView == streamOnCollectionView {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MovieProviderCell.self)
            cell.setContentForCell(data: streamOn[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension MovieDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == similarCollectionView {
            openMovieDetail(movie: similarMovies[indexPath.row])
        } else if collectionView == actorCollectionView {
            let vc = ActorProfileViewController.instantiate()
            vc.presenter.commonInfo = ActorCommonInfo(id: cast[indexPath.row].id,
                                                      name: cast[indexPath.row].name,
                                                      originalName: cast[indexPath.row].originalName,
                                                      mediaType: nil,
                                                      adult: cast[indexPath.row].adult,
                                                      popularity: cast[indexPath.row].popularity,
                                                      gender: cast[indexPath.row].gender,
                                                      knownForDepartment: nil,
                                                      profilePath: cast[indexPath.row].profilePath,
                                                      knownFor: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func openMovieDetail(movie: MovieCommonInfomation) {
        let vc = MovieDetailViewController.instantiate()
        vc.presenter.id = movie.id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MovieDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.movieDetail
}
