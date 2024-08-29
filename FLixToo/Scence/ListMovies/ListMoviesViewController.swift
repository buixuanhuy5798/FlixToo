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
}

final class ListMoviesViewController: BaseViewController {
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private let movieRepository = MovieRepository(APIService())
    private let disposeBag = DisposeBag()
    
    var screenType: ListMoviesType = .popular
    
    private var movies: [MovieCommonInfomation] = []
    
    private var page: Int = 1
    private var hasLoadMore: Bool = true
    private var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchPopularMovies()
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
        
        switch screenType {
        case .popular:
            title = "Trending Movies"
        case .upcomming:
            title = "Upcomming Movies"
        case .nowPlaying:
            title = "Recently Released Movies"
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
        }
    }
    
    private func fetchPopularMovies() {
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
}

extension ListMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
        cell.setContentForCell(data: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard hasLoadMore, indexPath.item == movies.count-1 else { return }
        self.fetchMorePopularMovies()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openMovieDetail(movie: movies[indexPath.row])
    }
    
    func openMovieDetail(movie: MovieCommonInfomation) {
        let vc = MovieDetailViewController.instantiate()
        vc.presenter.id = movie.id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListMoviesViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.listMovies
}
