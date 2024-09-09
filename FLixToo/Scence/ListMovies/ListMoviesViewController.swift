//
//  ListMoviesViewController.swift
//  FLixToo
//
//  Created by NamTrinh on 29/08/2024.
//

import UIKit
import Reusable
import RxSwift

enum ListMoviesType {
    case popular
    case upcomming
    case nowPlaying
    case upcommingShows
    case topRatedShows
    case trendingShows
    case movie(model: GenreModel)
    case tv(model: GenreModel)
    case moviesProvider(provider: MovieProvider)
}

enum SortType: String, CaseIterable {
    case trending = "Trending"
    case popular = "Popular"
    case new = "New Released"
    
    var code: String {
        switch self {
        case .trending:
            return "vote_average.asc"
        case .popular:
            return "popularity.desc"
        case .new:
            return "primary_release_date.desc"
        }
    }
}

final class ListMoviesViewController: BaseViewController {
    @IBOutlet weak var sortCollectionView: UICollectionView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private let movieRepository = MovieRepository(APIService())
    private let disposeBag = DisposeBag()
    
    var screenType: ListMoviesType = .popular
    
    private var movies: [MovieCommonInfomation] = []
    private var shows: [TvShowCommonInfomation] = []
    
    private var page: Int = 1
    private var hasLoadMore: Bool = true
    private var isLoading: Bool = false
    var sortBySelected: SortType = .trending
    let sortBys: [SortType] = SortType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        switch screenType {
        case .tv(let model):
            fetchTvShows(id: model.id)
        case .trendingShows, .upcommingShows, .topRatedShows:
            fetchTvShows()
        default:
            fetchPopularMovies()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moviesCollectionView.reloadData()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.moviesCollectionView.reloadData()
    }
    
    private func setupView() {
        showBackButton = true
        sortCollectionView.isHidden = true
        
        switch screenType {
        case .popular:
            title = "Trending Movies"
        case .upcomming:
            title = "Upcomming Movies"
        case .nowPlaying:
            title = "Nowplaying Movies"
        case .trendingShows:
            title = "Trending Shows"
        case .upcommingShows:
            title = "Upcomming Shows"
        case .topRatedShows:
            title = "Top Rated Shows"
        case .movie(let model):
            title = model.name
        case .tv(let model):
            title = model.name
        case .moviesProvider(let provider):
            title = provider.providerName
            sortCollectionView.isHidden = false
        }
        
        moviesCollectionView.register(cellType: MoviePosterCell.self)
        let layout = UICollectionViewFlowLayout()
        let itemWitdh = (Screen.width - 48) / 3.2
        let itemHeight = itemWitdh * 194/102 + 16
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .vertical
        moviesCollectionView.collectionViewLayout = layout
        moviesCollectionView.showsHorizontalScrollIndicator = false
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
        sortCollectionView.register(cellType: LibaryTagCollectionViewCell.self)
        let layout2 = UICollectionViewFlowLayout()
        layout2.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout2.minimumLineSpacing = 16
        layout2.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout2.minimumInteritemSpacing = 10
        layout2.scrollDirection = .horizontal
        sortCollectionView.collectionViewLayout = layout2
        sortCollectionView.showsHorizontalScrollIndicator = false
        sortCollectionView.delegate = self
        sortCollectionView.dataSource = self
        sortCollectionView.reloadData()
    }
}

extension ListMoviesViewController {
    private func fetchMovies(type: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>> {
        switch screenType {
        case .popular:
            return movieRepository.getListPopularMovie(page: page, checking: type)
        case .upcomming:
            return movieRepository.getListUpcomingMovies(page: page, checking: type)
        case .nowPlaying:
            return movieRepository.getListNowPlayingMovies(page: page, checking: type)
        case .movie(let model):
            return movieRepository.getMoviesByGenre(id: model.id, page: page, checking: type)
        case .moviesProvider(let provider):
            return movieRepository.getMoviesByProvider(id: provider.providerID ?? 0, sortBy: sortBySelected.code, page: page, checking: type)
        default:
            return movieRepository.getListNowPlayingMovies(page: page, checking: type)
        }
    }
    
    private func fetchShows(type: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>> {
        switch screenType {
        case .trendingShows:
            return movieRepository.getListPopularTVShow(page: page, checking: type)
        case .upcommingShows:
            return movieRepository.getListUpcomingTVShow(page: page, checking: type)
        case .topRatedShows:
            return movieRepository.getListTopRatedTVShow(page: page, checking: type)
        default:
            return movieRepository.getListTopRatedTVShow(page: page, checking: type)
        }
    }
    
    private func fetchTvShows() {
        isLoading = true
        fetchShows(type: .checked)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                DispatchQueue.main.async {
                    self.shows = response.results ?? []
                    self.hasLoadMore = response.page ?? 0 < response.totalPage ?? 0
                    self.moviesCollectionView.reloadData()
                    self.moviesCollectionView.setContentOffset(CGPoint.zero, animated: false)
                }
            }, onFailure: { [weak self] error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchMoreTvShows() {
        guard !isLoading else { return }
        isLoading = true
        page += 1
        fetchShows(type: .unchecked)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                DispatchQueue.main.async {
                    self.shows.append(contentsOf: response.results ?? [])
                    self.hasLoadMore = response.page ?? 0 < response.totalPage ?? 0
                    self.moviesCollectionView.reloadData()
                }
            }, onFailure: { [weak self] error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchPopularMovies() {
        page = 1
        isLoading = true
        fetchMovies(type: .checked)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                DispatchQueue.main.async {
                    self.movies = response.results ?? []
                    self.hasLoadMore = response.page ?? 0 < response.totalPage ?? 0
                    self.moviesCollectionView.reloadData()
                    self.moviesCollectionView.setContentOffset(CGPoint.zero, animated: false)
                }
            }, onFailure: { [weak self] error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchMorePopularMovies() {
        guard !isLoading else { return }
        isLoading = true
        page += 1
        fetchMovies(type: .unchecked)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                DispatchQueue.main.async {
                    self.movies.append(contentsOf: response.results ?? [])
                    self.hasLoadMore = response.page ?? 0 < response.totalPage ?? 0
                    self.moviesCollectionView.reloadData()
                }
            }, onFailure: { [weak self] error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchTvShows(id: Int) {
        isLoading = true
        movieRepository.getShowsByGenre(id: id, page: page, checking: .checked)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                DispatchQueue.main.async {
                    self.shows = response.results ?? []
                    self.hasLoadMore = response.page ?? 0 < response.totalPage ?? 0
                    self.moviesCollectionView.reloadData()
                    self.moviesCollectionView.setContentOffset(CGPoint.zero, animated: false)
                }
            }, onFailure: { [weak self] error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchMoreTvShows(id: Int) {
        guard !isLoading else { return }
        isLoading = true
        page += 1
        movieRepository.getShowsByGenre(id: id, page: page, checking: .unchecked)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                DispatchQueue.main.async {
                    self.shows.append(contentsOf: response.results ?? [])
                    self.hasLoadMore = response.page ?? 0 < response.totalPage ?? 0
                    self.moviesCollectionView.reloadData()
                }
            }, onFailure: { [weak self] error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

extension ListMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sortCollectionView {
            return sortBys.count
        }
        switch screenType {
        case .tv, .trendingShows, .upcommingShows, .topRatedShows:
            return shows.count
        default:
            return movies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sortCollectionView {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LibaryTagCollectionViewCell.self)
            cell.configCell(title: sortBys[indexPath.row].rawValue, isSelected: sortBys[indexPath.row] == sortBySelected)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
        
        switch screenType {
        case .tv, .trendingShows, .upcommingShows, .topRatedShows:
            cell.setContentForCell(data: shows[indexPath.row])
        default:
            cell.setContentForCell(data: movies[indexPath.row])
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch screenType {
        case .tv(let model):
            guard hasLoadMore, indexPath.item == shows.count-1 else { return }
            self.fetchMoreTvShows(id: model.id)
        case .trendingShows, .upcommingShows, .topRatedShows:
            guard hasLoadMore, indexPath.item == shows.count-1 else { return }
            self.fetchMoreTvShows()
        default:
            guard hasLoadMore, indexPath.item == movies.count-1 else { return }
            self.fetchMorePopularMovies()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sortCollectionView{
            sortBySelected = sortBys[indexPath.row]
            fetchPopularMovies()
            sortCollectionView.reloadData()
        } else {
            switch screenType {
            case .tv, .trendingShows, .upcommingShows, .topRatedShows:
                openShowDetail(show: shows[indexPath.row])
            default:
                openMovieDetail(movie: movies[indexPath.row])
            }
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

extension ListMoviesViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.listMovies
}
