//  
//  MovieDetailViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit
import Kingfisher
import Reusable

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var imdbScoreLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    
    var presenter: MovieDetailPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        imdbScoreLabel.textColor = .white
        imdbScoreLabel.font = Typography.fontMedium14
        movieNameLabel.textColor = .white
        movieNameLabel.font = Typography.fontSemibold20
    }
    
    @IBAction func handleTapClose(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension MovieDetailViewController:MovieDetailViewProtocol {
    func updateMovieDetail(data: MovieDetail) {
        backdropImageView.kf.setImage(
            with: Utils.getUrlImage(path: data.backdropPath),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
        imdbScoreLabel.text = "(\(data.voteAverage)/10)"
        movieNameLabel.text = "\(data.originalTitle) (\(data.releaseDate.prefix(4)))"
    }
}

extension MovieDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.movieDetail
}
