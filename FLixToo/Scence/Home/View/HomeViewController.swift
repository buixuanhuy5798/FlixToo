//  
//  HomeViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Reusable

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: HomePresenterProtocol!
    var storedOffsets = [Int: CGFloat]()
    
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
        showHeaderView = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: BounderCategoryCell.self)
        tableView.register(cellType: BounderListMovieCell.self)
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
//        cell.setContentForCell(type: presenter.data[indexPath.section])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .clear
        let titleLabel = UILabel()
        header.addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.font = Typography.fontSemibold18
        titleLabel.text = presenter.data[section].getTitle()
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.center.equalToSuperview()
        }
        let iconNext = UIImageView(image: UIImage(named: "icon_next"))
        header.addSubview(iconNext)
        iconNext.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(14)
            $0.width.equalTo(8)
        }
        switch presenter.data[section] {
        case .categories, .popularPeople:
            iconNext.isHidden = true
        case .movieProviders:
            return nil
        default:
            break
        }
        return header
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
        case .tredingMovies, .upcoming, .nowPlaying, .trendingShow, .upcomingShow, .topRatedShow:
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
            return 24
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
                print("Explore Movie")
            case .show:
                print("Explore Show")
            }
        case .tredingMovies(let movies):
            print("SELECT MOVIE: \(movies[indexPath.row].originalTitle)")
            openMovieDetail(movie: movies[indexPath.row])
        case .upcoming(let movies):
            print("SELECT MOVIE: \(movies[indexPath.row].originalTitle)")
            openMovieDetail(movie: movies[indexPath.row])
        case .nowPlaying(let movies):
            print("SELECT MOVIE: \(movies[indexPath.row].originalTitle)")
            openMovieDetail(movie: movies[indexPath.row])
        case .movieProviders(let providers):
            print("SELECT PROVIDER: \(providers[indexPath.row].providerName)")
        case .popularPeople(let actor):
            print("SELECT ACTOR: \(actor[indexPath.row].name)")
            presenter.openActorDetail(info: actor[indexPath.row])
        case .trendingShow(let shows):
            print("SELECT SHOWS: \(shows[indexPath.row].originalName)")
        case .upcomingShow(let shows):
            print("SELECT SHOWS: \(shows[indexPath.row].originalName)")
        case .topRatedShow(let shows):
            print("SELECT SHOWS: \(shows[indexPath.row].originalName)")
//            presenter.openActorDetail(info: shows[indexPath.row])
        }
    }
    
    func openMovieDetail(movie: MovieCommonInfomation) {
        let vc = MovieDetailViewController.instantiate()
        vc.presenter.id = movie.id
        navigationController?.pushViewController(vc, animated: true)
    }
}
