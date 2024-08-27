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
    @IBOutlet weak var namesTableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var recommendMoviesView: UIView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var recommendShowsView: UIView!
    @IBOutlet weak var showsCollectionView: UICollectionView!
    
    var presenter: SearchPresenterProtocol!
    
    private let api = APIService()
    private let disposeBag = DisposeBag()

    private var results: [MovieName] = []
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
        namesTableView.delegate = self
        namesTableView.dataSource = self
        namesTableView.register(cellType: SearchNameTableViewCell.self)
        namesTableView.rowHeight = UITableView.automaticDimension
        namesTableView.estimatedRowHeight = 30
        namesTableView.isHidden = true
        
        searchTextfield.rx.controlEvent(.editingChanged)
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.searchTextfield.text?.isEmpty ?? true {
                    self.deleteButton.isHidden = true
                    self.recommendShowsView.isHidden = false
                    self.results = []
                    self.namesTableView.reloadData()
                    self.namesTableView.isHidden = true
                } else {
                    self.deleteButton.isHidden = false
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
        deleteButton.isHidden = true
        results = []
        namesTableView.reloadData()
        namesTableView.isHidden = true
    }
    
    private func searchMovieNames(keyword: String) {
        page = 1
        hasLoadMore = true
        isLoading = true
        
        getMoviesBy(keyword: keyword, page: page)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                self.results = response.results
                self.recommendShowsView.isHidden = true
                self.namesTableView.isHidden = false
                self.hasLoadMore = response.page < response.total_pages
                self.namesTableView.reloadData()
            }, onFailure: { error in
                self.isLoading = false
                print("error", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchMoreMovieNames() {
        guard !isLoading else { return }
        isLoading = true
        page += 1
        
        getMoviesBy(keyword: searchTextfield.text ?? "", page: page, checking: .unchecked)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                self.results.append(contentsOf: response.results)
                self.hasLoadMore = response.page < response.total_pages
                self.namesTableView.reloadData()
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
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchNameTableViewCell = tableView.dequeueReusableCell(for: indexPath, cellType: SearchNameTableViewCell.self)
        cell.configCell(title: results[indexPath.row].name)
        if indexPath.row == self.results.count - 1,
           hasLoadMore {
            self.fetchMoreMovieNames()
        }

        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 10.0,
           hasLoadMore {
            self.fetchMoreMovieNames()
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == moviesCollectionView {
            return movies.count
        }
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
        if collectionView == moviesCollectionView {
            cell.setContentForCell(data: movies[indexPath.row])
        } else {
            cell.setContentForCell(data: shows[indexPath.row])
        }
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch presenter.data[collectionView.tag] {
//        case .categories(let data):
//            switch data[indexPath.row] {
//            case .movie:
//                print("Explore Movie")
//            case .show:
//                print("Explore Show")
//            }
//
//        }
    }
}


extension SearchViewController {
    private func getMoviesBy(keyword: String, page: Int, checking: CheckingType = .checked) -> Single<SearchMovieNameResponse> {
        return api.request(router: .searchMovieName(keyword: keyword, page: page), checking: checking)
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
