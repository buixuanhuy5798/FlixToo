//  
//  SearchViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController {
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    @IBOutlet weak var recommendMoviesView: UIView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var recommendShowsView: UIView!
    @IBOutlet weak var showsCollectionView: UICollectionView!
    
    var presenter: SearchPresenterProtocol!
    
    private let api = APIService()
    private let disposeBag = DisposeBag()

    private var results: [MovieCommonInfomation] = []
    private var movies: [MovieCommonInfomation] = []
    private var shows: [TvShowCommonInfomation] = []
    
    private var page: Int = 1
    private var hasLoadMore: Bool = true
    private var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        setupView()
        fetchRecommedMovies()
    }
    
    private func setupView() {
        title = "Search"
        showBackButton = false
        deleteButton.isHidden = true
        
        resultsView.isHidden = true
        resultsCollectionView.register(cellType: MoviePosterCell.self)
        let layout = UICollectionViewFlowLayout()
        let itemWitdh = (Screen.width - 48) / 3.2
        let itemHeight = itemWitdh * 194/102 + 16
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .vertical
        resultsCollectionView.collectionViewLayout = layout
        resultsCollectionView.showsHorizontalScrollIndicator = false
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
        
        searchTextfield.rx.controlEvent(.editingChanged)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.searchTextfield.text?.isEmpty ?? true {
                    self.deleteButton.isHidden = true
                    self.recommendShowsView.isHidden = false
                    self.recommendMoviesView.isHidden = false
                    self.results = []
                    self.resultsView.isHidden = true
                } else {
                    self.deleteButton.isHidden = false
                    self.recommendShowsView.isHidden = true
                    self.recommendMoviesView.isHidden = true
                    self.searchMovieNames(keyword: self.searchTextfield.text ?? "")
                }
            }).disposed(by: disposeBag)
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        moviesCollectionView.register(cellType: MoviePosterCell.self)
        let layout = UICollectionViewFlowLayout()
        let itemWitdh = (Screen.width - 48) / 3.2
        let itemHeight = itemWitdh * 194/102 + 16
        layout.itemSize = CGSize(width: 102, height: 180)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        moviesCollectionView.collectionViewLayout = layout
        moviesCollectionView.showsHorizontalScrollIndicator = false
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
        showsCollectionView.register(cellType: MoviePosterCell.self)
        let layout2 = UICollectionViewFlowLayout()
        layout2.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        layout2.minimumLineSpacing = 16
        layout2.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout2.minimumInteritemSpacing = 16
        layout2.scrollDirection = .horizontal
        showsCollectionView.collectionViewLayout = layout2
        showsCollectionView.showsHorizontalScrollIndicator = false
        showsCollectionView.delegate = self
        showsCollectionView.dataSource = self
    }
    
    @IBAction func handleDeleteTextButton(_ sender: Any) {
        searchTextfield.text = ""
        recommendShowsView.isHidden = false
        recommendMoviesView.isHidden = false
        deleteButton.isHidden = true
        results = []
        resultsCollectionView.reloadData()
        resultsView.isHidden = true
    }
    
    private func searchMovieNames(keyword: String) {
        page = 1
        hasLoadMore = true
        isLoading = true
        
        searchMovies(keyword: keyword, page: page, checking: .checked)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                self.results = response.results ?? []
                self.recommendShowsView.isHidden = true
                self.resultsView.isHidden = false
                self.hasLoadMore = response.page ?? 0 < response.totalPage ?? 0
                self.resultsCollectionView.reloadData()
            }, onFailure: { error in
                self.isLoading = false
                print("error", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchMoreMovies() {
        guard !isLoading else { return }
        isLoading = true
        page += 1
        
        searchMovies(keyword: searchTextfield.text ?? "", page: page, checking: .unchecked)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                self.results.append(contentsOf: response.results ?? [])
                self.hasLoadMore = response.page ?? 0 < response.totalPage ?? 0
                self.resultsCollectionView.reloadData()
            }, onFailure: { error in
                self.isLoading = false
                print("error", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchRecommedMovies() {
        let group = DispatchGroup()
        
        group.enter()
        getListPopularMovie(page: 1, checking: .checked)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.movies = response.results ?? []
                group.leave()
            }, onFailure: { error in
                group.leave()
                print("error", error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        group.enter()
        getListPopularTVShow(page: 1, checking: .checked)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.shows = response.results ?? []
                group.leave()
            }, onFailure: { error in
                group.leave()
                print("error", error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        group.notify(queue: .main) { [weak self] in
            self?.moviesCollectionView.reloadData()
            self?.showsCollectionView.reloadData()
        }
    }
    
    func openMovieDetail(id: Int) {
        let vc = MovieDetailViewController.instantiate()
        vc.presenter.id = id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openShowDetail(show: TvShowCommonInfomation) {
        let vc = ShowDetailViewController.instantiate()
        vc.id = show.id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == resultsCollectionView {
            return results.count
        }
        if collectionView == moviesCollectionView {
            return movies.count
        }
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
        if collectionView == resultsCollectionView {
            cell.setContentForCell(data: results[indexPath.row])
        } else if collectionView == moviesCollectionView {
            cell.setContentForCell(data: movies[indexPath.row])
        } else {
            cell.setContentForCell(data: shows[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == resultsCollectionView {
            guard hasLoadMore, indexPath.item == results.count-1 else { return }
            self.fetchMoreMovies()
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == resultsCollectionView {
            openMovieDetail(id: results[indexPath.row].id ?? 0)
        } else if collectionView == moviesCollectionView {
            openMovieDetail(id: movies[indexPath.row].id ?? 0)
        } else {
            openShowDetail(show: shows[indexPath.row])
        }
    }
}


extension SearchViewController {
    func searchMovies(keyword: String, page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>> {
        return api.request(router: .searchMovies(keyword: keyword, page: page), checking: checking)
    }
    
    private func getListPopularMovie(page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>> {
        return api.request(router: .getListPopularMovie(page: page), checking: checking)
    }
    
    private func getListPopularTVShow(page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>> {
        return api.request(router: .getListTVPopular(page: page), checking: checking)
    }
}

extension SearchViewController:SearchViewProtocol {
}

extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.search
}
