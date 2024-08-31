//  
//  LibraryViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Reusable

enum FilterLibraryType {
    case movies
    case shows
    case all
}

final class LibraryViewController: UIViewController {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    var presenter: LibraryPresenterProtocol!
    
    var filterType: FilterLibraryType = .all
    
    var isShowDelete = false

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.update()
        moviesCollectionView.reloadData()
        if presenter.favList.isEmpty,
            presenter.dislikedList.isEmpty,
           presenter.watchLaterList.isEmpty,
           presenter.watchedList.isEmpty {
            emptyView.isHidden = false
            moviesCollectionView.isHidden = true
            tagsCollectionView.isHidden = true
        } else {
            emptyView.isHidden = true
            moviesCollectionView.isHidden = false
            tagsCollectionView.isHidden = false
        }
    }
    
    @IBAction func handleEditButton(_ sender: Any) {
        isShowDelete.toggle()
        moviesCollectionView.reloadData()
    }
    
    @IBAction func handleFilterButton(_ sender: UIButton) {
        let popover = PopoverFilterViewController(info: "Filter", filter: filterType) { [weak self] filterType in
            self?.filterType = filterType
            self?.moviesCollectionView.reloadData()
        }
        presentPopover(self, popover, sender: sender, size: CGSize(width: 240, height: 180), arrowDirection: .up)
    }
    
    private func setupView() {
        navigationController?.navigationBar.isHidden = true
        tagsCollectionView.register(cellType: LibaryTagCollectionViewCell.self)
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        tagsCollectionView.collectionViewLayout = layout
        tagsCollectionView.showsHorizontalScrollIndicator = false
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.reloadData()
    
        
        moviesCollectionView.register(cellType: MoviePosterCell.self)
        let layout2 = UICollectionViewFlowLayout()
        let itemWitdh = (Screen.width - 48) / 3.2
        let itemHeight = itemWitdh * 194/102 + 16
        layout2.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        layout2.minimumLineSpacing = 16
        layout2.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout2.minimumInteritemSpacing = 16
        layout2.scrollDirection = .vertical
        moviesCollectionView.collectionViewLayout = layout2
        moviesCollectionView.showsHorizontalScrollIndicator = false
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
    }
    
    private func getMovies() -> [SaveData] {
        switch presenter.tagSelected {
        case .favorite:
            return applyFilter(data: presenter.favList)
        case .watchLater:
            return applyFilter(data: presenter.watchLaterList)
        case .watched:
            return applyFilter(data: presenter.watchedList)
        case .disliked:
            return applyFilter(data: presenter.dislikedList)
        }
    }
    
    private func applyFilter(data: [SaveData]) -> [SaveData] {
        switch filterType {
        case .movies:
            return data.filter { $0.type == .movie }
        case .shows:
            return data.filter { $0.type == .show }
        case .all:
            return data
        }
    }
    
    private func delete(id: Int) {
        presenter.favList = UserInfomation.favList
        presenter.watchLaterList = UserInfomation.watchLaterList
        presenter.watchedList = UserInfomation.watchedList
        presenter.dislikedList = UserInfomation.dislikeList
        switch presenter.tagSelected {
        case .favorite:
            if let index = UserInfomation.favList.firstIndex(where:  { $0.id == id }) {
                UserInfomation.favList.remove(at: index)
            }
        case .watchLater:
            if let index = UserInfomation.watchLaterList.firstIndex(where:  { $0.id == id }) {
                UserInfomation.favList.remove(at: index)
            }
        case .watched:
            if let index = UserInfomation.watchedList.firstIndex(where:  { $0.id == id }) {
                UserInfomation.favList.remove(at: index)
            }
        case .disliked:
            if let index = UserInfomation.dislikeList.firstIndex(where:  { $0.id == id }) {
                UserInfomation.favList.remove(at: index)
            }
        }
        presenter.update()
        moviesCollectionView.reloadData()
    }
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagsCollectionView {
            return presenter.tags.count
        }
        return getMovies().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagsCollectionView {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LibaryTagCollectionViewCell.self)
            cell.configCell(title: presenter.tags[indexPath.row].title, isSelected: presenter.tags[indexPath.row] == presenter.tagSelected)
            return cell
        }
       
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MoviePosterCell.self)
        let item = getMovies()[indexPath.row]
        cell.setContentForCell(data: item, isShowDelete: isShowDelete)
        cell.onTapDelete = { [weak self] in
            self?.delete(id: item.id ?? 0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagsCollectionView {
            presenter.tagSelected = presenter.tags[indexPath.row]
            tagsCollectionView.reloadData()
            moviesCollectionView.reloadData()
        }
       
    }
}

extension LibraryViewController:LibraryViewProtocol {
}

extension LibraryViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.library
}
