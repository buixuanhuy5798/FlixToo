//  
//  LibraryViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Reusable

final class LibraryViewController: UIViewController {

    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    var presenter: LibraryPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        setupView()
    }
    @IBAction func handleFilterButton(_ sender: UIButton) {
        let popover = PopoverFilterViewController(info: "Filter")
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
    }
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: LibaryTagCollectionViewCell.self)
        cell.configCell(title: presenter.tags[indexPath.row].title, isSelected: presenter.tags[indexPath.row] == presenter.tagSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.tagSelected = presenter.tags[indexPath.row]
        tagsCollectionView.reloadData()
    }
}

extension LibraryViewController:LibraryViewProtocol {
}

extension LibraryViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.library
}
