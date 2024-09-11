//  
//  HomeViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Reusable
import GoogleMobileAds

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: HomePresenterProtocol!
    var storedOffsets = [Int: CGFloat]()
    
    var bannerView: GADBannerView = {
        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
        var view = GADBannerView(adSize: adaptiveSize)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setUpView() {
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2435281174"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
        
        showHeaderView = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: BounderCategoryCell.self)
        tableView.register(cellType: BounderListMovieCell.self)
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
     
}

extension HomeViewController:HomeViewProtocol {
    func reloadContent() {
        tableView.reloadData()
    }
}

extension HomeViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.home
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BounderListMovieCell.self)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HomeHeaderTableView()
        var hiddenIconNext = false
        var iconImage: UIImage? = nil
        let type = presenter.data[section]
        switch type {
        case .categories, .popularPeople:
            hiddenIconNext = true
        case .topRatedShow:
            iconImage = UIImage(named: "logo_top_rated")
        case .movieProviders:
            return nil
        default:
            break
        }
        headerView.setContentForCell(title: type.getTitle(), icon: iconImage, hiddenIconNext: hiddenIconNext)
        headerView.didTapHeader = { [weak self] in
            self?.handleTapHeader(type: type)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch presenter.data[section] {
        case .movieProviders:
            return 12
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard var tableViewCell = cell as? BaseCollectionViewInTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, fowRow: indexPath.section, type: presenter.data[indexPath.section])
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.section] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? BaseCollectionViewInTableViewCell else { return }
        storedOffsets[indexPath.section] = tableViewCell.collectionViewOffset
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch presenter.data[indexPath.section] {
        case .categories:
            let itemWitdh = (Screen.width - 48) / 2
            let itemHeight = itemWitdh * 96/158
            return itemHeight
        case .tredingMovies, .upcoming, .nowPlaying, .trendingShow, .upcomingShow, .topRatedShow, .freeMovieToWatch:
            let itemWitdh = (Screen.width - 48) / 3.2
            let itemHeight = itemWitdh * 194/102 + 18
            return itemHeight
        case .popularPeople:
            let itemWitdh = (Screen.width - 48) / 3.2
            let itemHeight = itemWitdh * 122/102
            return itemHeight
        case .movieProviders:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch presenter.data[section] {
        case .categories:
            return 30
        case .movieProviders:
            return 24
        case .popularPeople:
            return 32
        default:
            return 0
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.data[collectionView.tag].getCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch presenter.data[collectionView.tag] {
        case .categories(let data):
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryCell.self)
            cell.setContentForCell(data: data[indexPath.row])
            return cell
        case .tredingMovies(let movies):
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
            cell.setContentForCell(data: movies[indexPath.row])
            return cell
        case .freeMovieToWatch(let movies):
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
            cell.setContentForCell(data: movies[indexPath.row])
            return cell
        case .upcoming(let movies):
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
            cell.setContentForCell(data: movies[indexPath.row])
            return cell
        case .nowPlaying(let movies):
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
            cell.setContentForCell(data: movies[indexPath.row])
            return cell
        case .movieProviders(let providers):
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MovieProviderCell.self)
            cell.setContentForCell(data: providers[indexPath.row])
            return cell
        case .popularPeople(let people):
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ActorCommonInfoCell.self)
            cell.setContentForCell(actor: people[indexPath.row])
            return cell
        case .trendingShow(let shows):
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
            cell.setContentForCell(data: shows[indexPath.row])
            return cell
        case .upcomingShow(let shows):
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
            cell.setContentForCell(data: shows[indexPath.row])
            return cell
        case .topRatedShow(let shows):
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
            cell.setContentForCell(data: shows[indexPath.row])
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch presenter.data[collectionView.tag] {
        case .categories(let data):
            switch data[indexPath.row] {
            case .movie:
                let vc = GenresViewController.instantiate()
                vc.isMovieGenres = true
                navigationController?.pushViewController(vc, animated: true)
            case .show:
                let vc = GenresViewController.instantiate()
                vc.isMovieGenres = false
                navigationController?.pushViewController(vc, animated: true)
            }
        case .tredingMovies(let movies):
            openMovieDetail(movie: movies[indexPath.row])
        case .freeMovieToWatch(let movies):
            openMovieDetail(movie: movies[indexPath.row])
        case .upcoming(let movies):
            openMovieDetail(movie: movies[indexPath.row])
        case .nowPlaying(let movies):
            openMovieDetail(movie: movies[indexPath.row])
        case .movieProviders(let providers):
            let vc = ListMoviesViewController.instantiate()
            vc.screenType = .moviesProvider(provider: providers[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        case .popularPeople(let actor):
            presenter.openActorDetail(info: actor[indexPath.row])
        case .trendingShow(let shows):
            openShowDetail(show: shows[indexPath.row])
        case .upcomingShow(let shows):
            openShowDetail(show: shows[indexPath.row])
        case .topRatedShow(let shows):
            openShowDetail(show: shows[indexPath.row])
        }
    }
    
    func openMovieDetail(movie: MovieCommonInfomation) {
        let vc = MovieDetailViewController.instantiate()
        vc.presenter.id = movie.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openShowDetail(show: TvShowCommonInfomation) {
        let vc = ShowDetailViewController.instantiate()
        vc.id = show.id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController {
    func handleTapHeader(type: HomeCollectionSectionData) {
        switch type {
        case .categories, .popularPeople, .movieProviders:
            return
        case .freeMovieToWatch:
            let vc = ListMoviesViewController.instantiate()
            vc.screenType = .freeToWatch
            self.navigationController?.pushViewController(vc, animated: true)
        case .tredingMovies:
            let vc = ListMoviesViewController.instantiate()
            vc.screenType = .popular
            self.navigationController?.pushViewController(vc, animated: true)
        case .nowPlaying:
            let vc = ListMoviesViewController.instantiate()
            vc.screenType = .nowPlaying
            self.navigationController?.pushViewController(vc, animated: true)
        case .upcoming:
            let vc = ListMoviesViewController.instantiate()
            vc.screenType = .upcomming
            self.navigationController?.pushViewController(vc, animated: true)
        case .trendingShow:
            let vc = ListMoviesViewController.instantiate()
            vc.screenType = .trendingShows
            self.navigationController?.pushViewController(vc, animated: true)
        case .upcomingShow:
            let vc = ListMoviesViewController.instantiate()
            vc.screenType = .upcommingShows
            self.navigationController?.pushViewController(vc, animated: true)
        case .topRatedShow:
            let vc = ListMoviesViewController.instantiate()
            vc.screenType = .topRatedShows
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
