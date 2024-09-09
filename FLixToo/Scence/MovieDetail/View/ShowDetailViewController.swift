//
//  ShowDetailViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 31/08/2024.
//

import UIKit
import RxSwift
import Reusable
import Kingfisher
import ExpandableLabel

class ShowDetailViewController: UIViewController {

    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var heightOfCommentTableView: NSLayoutConstraint!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var mediaTitleLabel: UILabel!
    @IBOutlet weak var backdropLabel: UILabel!
    @IBOutlet weak var allBackdropImageView: UIImageView!
    @IBOutlet weak var heightOfSimiliarCollectionView: NSLayoutConstraint!
    @IBOutlet weak var similiarTitleLabel: UILabel!
    @IBOutlet weak var similiarCollectionView: UICollectionView!
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
    var similarShows = [TvShowCommonInfomation]()
    var backdrop: BackdropsMovie?
    var comment = [Comment]()
    var states = [Bool]()
    
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
            if self?.detail?.seasons?.isEmpty == true {
                self?.heightOfSeasonCollectionView.constant = 0
                self?.seasonLabel.isHidden = true
            }
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
            if self?.cast.isEmpty == true {
                self?.heightOfActorCollectionView.constant = 0
                self?.actorTitleLabel.isHidden = true
            }
        })
        .disposed(by: disposebag)
        repository.getSimilarShow(id: id, page: 1, checking: .unchecked).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            self?.similarShows = results
            self?.similiarCollectionView.reloadData()
            if results.isEmpty == true {
                self?.heightOfSimiliarCollectionView.constant = 0
                self?.similiarTitleLabel.isHidden = true
            }
        })
        .disposed(by: disposebag)
        repository.getBackdropImages(id: id, type: .show).subscribe(onSuccess: { [weak self] response in
            self?.backdrop = response
            let path = self?.backdrop?.backdrops?.randomElement()?.filePath ?? ""
            self?.allBackdropImageView.kf.setImage(
                    with: Utils.getUrlImage(path: path),
                    options: [
                        .loadDiskFileSynchronously,
                        .cacheOriginalImage,
                        .transition(.fade(0.1)),
                    ])
            self?.allBackdropImageView.blurBottom()
            self?.backdropLabel.text = "\(self?.backdrop?.backdrops?.count ?? 0) backdrops"
            if self?.backdrop?.backdrops?.isEmpty == true {
                self?.allBackdropImageView.isHidden = true
                self?.mediaTitleLabel.isHidden = true
                self?.backdropLabel.isHidden = true
            }
        }, onFailure: { [weak self] error in
            if let error = error as? APIErrorResponse {
                self?.showCommonError(message: error.message ?? "")
            } else {
                self?.showCommonError(message: error.localizedDescription)
            }
        })
        .disposed(by: disposebag)
        repository.getReview(id: id, page: 1, checking: .unchecked, type: .show).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            
            self?.comment = results
            self?.states = [Bool](repeating: true, count: results.count)
            self?.commentTableView.reloadData()
            if results.isEmpty {
                self?.heightOfCommentTableView.constant = 0
                self?.seeAllButton.isHidden = true
                self?.reviewTitleLabel.isHidden = true
            }
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
        similiarTitleLabel.text = "More Shows like this"
        similiarTitleLabel.font = Typography.fontSemibold18
        similiarTitleLabel.textColor = .white
        mediaTitleLabel.font = Typography.fontSemibold18
        mediaTitleLabel.textColor = .white
        backdropLabel.font = Typography.fontSemibold18
        backdropLabel.textColor = .white
        mediaTitleLabel.text = "Media"
        allBackdropImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapAllBackdrop)))
        allBackdropImageView.isUserInteractionEnabled = true
        setUpCrewCollectionView()
        setUpSeasonCollectionView()
        setUpSimiliarCollectionView()
        setUpActorCollectionView()
        commentTableView.register(cellType: CommentCell.self)
        commentTableView.dataSource = self
        commentTableView.rowHeight = UITableView.automaticDimension
        heightOfCommentTableView.constant = Screen.height * 1/3
    }
    
    @objc private func handleTapAllBackdrop() {
        let vc = MovieBackdropImageShowControllerViewController.instantiate()
        vc.backdrop = backdrop
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func handleTapSeeAllButton(_ sender: Any) {
        let vc = CommentViewController.instantiate()
        vc.id = self.detail?.id
        vc.type = .show
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleTapWatchTrailerButton(_ sender: Any) {
        let vc = MovieTrailerController.instantiate()
        vc.id = id
        vc.type = .show
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
    
    private func setUpActorCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        let itemWitdh = (Screen.width - 48) / 3.2
        let itemHeight = itemWitdh * 194/102 + 16
        heightOfActorCollectionView.constant = itemHeight + 8
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        actorCollectionView.collectionViewLayout = layout
        actorCollectionView.dataSource = self
        actorCollectionView.delegate = self
        actorCollectionView.register(cellType: MoviePosterCell.self)
    }
    
    private func setUpSeasonCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        seasonCollectionView.showsHorizontalScrollIndicator = false
        let itemWitdh = (Screen.width - 48) / 3.2
        let itemHeight = itemWitdh * 194/102 + 16
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        heightOfSeasonCollectionView.constant = itemHeight + 8
        seasonCollectionView.collectionViewLayout = layout
        seasonCollectionView.dataSource = self
        seasonCollectionView.register(cellType: MoviePosterCell.self)
        seasonCollectionView.delegate = self
    }
    
    
    private func setUpSimiliarCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        let itemWitdh = (Screen.width - 48) / 3.2
        let itemHeight = itemWitdh * 194/102 + 16
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        similiarCollectionView.collectionViewLayout = layout
        similiarCollectionView.dataSource = self
        similiarCollectionView.delegate = self
        similiarCollectionView.register(cellType: MoviePosterCell.self)
        heightOfSimiliarCollectionView.constant = itemHeight + 8
    }
    
}

extension ShowDetailViewController: ExpandableLabelDelegate {
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
        } else if collectionView == similiarCollectionView {
            return similarShows.count
        }
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
       } else if collectionView == similiarCollectionView {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
            cell.setContentForCell(data: similarShows[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ShowDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == similiarCollectionView {
            openShowDetail(id: similarShows[indexPath.row].id)
        } else if collectionView == seasonCollectionView {
            openShowDetail(id: detail?.seasons?[indexPath.row].id)
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
    
    func openShowDetail(id: Int?) {
        let vc = ShowDetailViewController.instantiate()
        vc.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ShowDetailViewController: UITableViewDataSource {
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
