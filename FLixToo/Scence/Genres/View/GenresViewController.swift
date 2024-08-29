//  
//  GenresViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit
import Reusable
import SVProgressHUD

final class GenresViewController: BaseViewController {

    @IBOutlet weak var movieButton: UIButton!
    @IBOutlet weak var showsButton: UIButton!
    @IBOutlet weak var genresCollectionView: UICollectionView!

    var movieGenres: [GenreModel] = [
        .init(id: 28, name: "Action", image: UIImage(named: "img_movie_action") ?? UIImage()),
        .init(id: 12, name: "Adventure", image: UIImage(named: "img_movie_adventure") ?? UIImage()),
        .init(id: 16, name: "Animation", image: UIImage(named: "img_movie_animation") ?? UIImage()),
        .init(id: 35, name: "Comedy", image: UIImage(named: "img_movie_comedy") ?? UIImage()),
        .init(id: 80, name: "Crime", image: UIImage(named: "img_movie_crime") ?? UIImage()),
        .init(id: 99, name: "Documentary", image: UIImage(named: "img_movie_documentary") ?? UIImage()),
        .init(id: 18, name: "Drama", image: UIImage(named: "img_movie_drama") ?? UIImage()),
        .init(id: 10751, name: "Family", image: UIImage(named: "img_movie_family") ?? UIImage()),
        .init(id: 14, name: "Fantasy", image: UIImage(named: "img_movie_fantasy") ?? UIImage()),
        .init(id: 36, name: "History", image: UIImage(named: "img_movie_history") ?? UIImage()),
        .init(id: 27, name: "Horror", image: UIImage(named: "img_movie_hrror") ?? UIImage()),
        .init(id: 10402, name: "Music", image: UIImage(named: "img_movie_music") ?? UIImage()),
        .init(id: 9648, name: "Mystery", image: UIImage(named: "img_movie_mystery") ?? UIImage()),
        .init(id: 10749, name: "Romance", image: UIImage(named: "img_movie_romance") ?? UIImage()),
        .init(id: 878, name: "Science Fiction", image: UIImage(named: "img_movie_science") ?? UIImage()),
        .init(id: 10770, name: "TV Movie", image: UIImage(named: "img_movie_tv") ?? UIImage()),
        .init(id: 53, name: "Thriller", image: UIImage(named: "img_movie_thriller") ?? UIImage()),
        .init(id: 10752, name: "War", image: UIImage(named: "img_movie_war") ?? UIImage()),
        .init(id: 37, name: "Western", image: UIImage(named: "img_movie_western") ?? UIImage()),
    ]
    
    var tvGenres: [GenreModel] = [
        .init(id: 10759, name: "Action & Adventure", image: UIImage(named: "img_tv_action") ?? UIImage()),
        .init(id: 16, name: "Animation", image: UIImage(named: "img_tv_animation") ?? UIImage()),
        .init(id: 35, name: "Comedy", image: UIImage(named: "img_tv_comedy") ?? UIImage()),
        .init(id: 80, name: "Crime", image: UIImage(named: "img_tv_crime") ?? UIImage()),
        .init(id: 99, name: "Documentary", image: UIImage(named: "img_tv_documentary") ?? UIImage()),
        .init(id: 18, name: "Drama", image: UIImage(named: "img_tv_drama") ?? UIImage()),
        .init(id: 10751, name: "Family", image: UIImage(named: "img_tv_family") ?? UIImage()),
        .init(id: 10762, name: "Kids", image: UIImage(named: "img_tv_kids") ?? UIImage()),
        .init(id: 9648, name: "Mystery", image: UIImage(named: "img_tv_mystery") ?? UIImage()),
        .init(id: 10763, name: "News", image: UIImage(named: "img_tv_news") ?? UIImage()),
        .init(id: 10764, name: "Reality", image: UIImage(named: "img_tv_reality") ?? UIImage()),
        .init(id: 10765, name: "Sci-fi & Fantasy", image: UIImage(named: "img_tv_scifi") ?? UIImage()),
        .init(id: 10766, name: "Soap", image: UIImage(named: "img_tv_soap") ?? UIImage()),
        .init(id: 10767, name: "Talk", image: UIImage(named: "img_tv_talk") ?? UIImage()),
        .init(id: 10768, name: "War & Polities", image: UIImage(named: "img_tv_war") ?? UIImage()),
        .init(id: 37, name: "Western", image: UIImage(named: "img_tv_westerm") ?? UIImage()),
    ]
    
    var isMovieGenres = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func handleMovieButton(_ sender: UIButton) {
        isMovieGenres = true
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = UIColor(hex: "5666F8")
        showsButton.setTitleColor(UIColor(hex: "AAAAAA"), for: .normal)
        showsButton.backgroundColor = UIColor(hex: "272727")
    
        genresCollectionView.reloadData()
    }
    
    
    @IBAction func handleTShowsButton(_ sender: UIButton) {
        isMovieGenres = false
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = UIColor(hex: "5666F8")
        movieButton.setTitleColor(UIColor(hex: "AAAAAA"), for: .normal)
        movieButton.backgroundColor = UIColor(hex: "272727")
        genresCollectionView.reloadData()
    }
    
    private func setupView() {
        showBackButton = true
        title = "Genres"
        
        if isMovieGenres {
            movieButton.setTitleColor(.white, for: .normal)
            movieButton.backgroundColor = UIColor(hex: "5666F8")
            showsButton.setTitleColor(UIColor(hex: "AAAAAA"), for: .normal)
            showsButton.backgroundColor = UIColor(hex: "272727")
        } else {
            showsButton.setTitleColor(.white, for: .normal)
            showsButton.backgroundColor = UIColor(hex: "5666F8")
            movieButton.setTitleColor(UIColor(hex: "AAAAAA"), for: .normal)
            movieButton.backgroundColor = UIColor(hex: "272727")
        }
        
        SVProgressHUD.show()
        genresCollectionView.register(cellType: GenreCollectionViewCell.self)
        let layout = UICollectionViewFlowLayout()
        let itemWitdh = (Screen.width - 48) / 2
        let itemHeight = itemWitdh * 96/158 + 16
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .vertical
        genresCollectionView.collectionViewLayout = layout
        genresCollectionView.showsHorizontalScrollIndicator = false
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
        
        genresCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            SVProgressHUD.dismiss()
        }
    }
}

extension GenresViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMovieGenres {
            return movieGenres.count
        }
        return tvGenres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: GenreCollectionViewCell.self)
        if isMovieGenres {
            let item = movieGenres[indexPath.row]
            cell.configCell(title: item.name, image: item.image)
        } else {
            let item = tvGenres[indexPath.row]
            cell.configCell(title: item.name, image: item.image)
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ListMoviesViewController.instantiate()
        
        if isMovieGenres {
            vc.screenType = .movie(model: movieGenres[indexPath.row])
        } else {
            vc.screenType = .tv(model: tvGenres[indexPath.row])
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension GenresViewController:GenresViewProtocol {
}

extension GenresViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.genres
}
