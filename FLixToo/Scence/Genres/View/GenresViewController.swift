//  
//  GenresViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit

final class GenresViewController: BaseViewController {

    @IBOutlet weak var movieButton: UIButton!
    @IBOutlet weak var showsButton: UIButton!
    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    var presenter: GenresPresenterProtocol!

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
        .init(id: 37, name: "Western", image: UIImage(named: "img_movie_weatern") ?? UIImage()),
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
        .init(id: 37, name: "Western", image: UIImage(named: "img_tv_western") ?? UIImage()),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
    }
    
    private func setupView() {
        
    }
}

extension GenresViewController:GenresViewProtocol {
}
