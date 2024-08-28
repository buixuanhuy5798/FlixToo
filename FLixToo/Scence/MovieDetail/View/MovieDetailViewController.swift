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

    @IBOutlet weak var aboutMovieTitleLabel: UILabel!
    @IBOutlet weak var aboutMovieContentLabel: UILabel!
    @IBOutlet weak var addToLibraryButton: UIButton!
    @IBOutlet weak var watchTrailerButton: BaseFillButton!
    @IBOutlet weak var generLabel: UILabel!
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
        generLabel.textColor = UIColor(hex: "D9D9D9")
        generLabel.font = Typography.fontMedium14
        watchTrailerButton.setTitle("Watch Trailers", for: .normal)
        addToLibraryButton.titleLabel?.font = Typography.fontSemibold14
        aboutMovieTitleLabel.font = Typography.fontSemibold14
        aboutMovieTitleLabel.textColor = .white
        aboutMovieContentLabel.font = Typography.fontRegular14
        aboutMovieContentLabel.textColor = .white
    }
    
    @IBAction func handleTapAddToLibraryButton(_ sender: Any) {
    }
    
    @IBAction func handleTapWatchTrailerButton(_ sender: Any) {
    }
    
    @IBAction func handleTapClose(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension MovieDetailViewController:MovieDetailViewProtocol {
    func updateMovieDetail(data: MovieDetail) {
        backdropImageView.kf.setImage(
            with: Utils.getUrlImage(path: data.backdropPath ?? ""),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
        let voteAverage = String(format: "%.1f", (data.voteAverage ?? 0))
        imdbScoreLabel.text = "(\(voteAverage)/10)"
        movieNameLabel.text = "\(data.originalTitle ?? "") (\(data.releaseDate?.prefix(4) ?? ""))"
        var generString = ""
        if let runtime = data.runtime {
            generString += "● \(Utils.calculateTime(runtime))"
        }
        if let generes = data.genres {
            for gen in generes {
                generString += "  ● \(gen.name ?? "")"
            }
        }
        generLabel.text = generString
        aboutMovieContentLabel.text = data.overview
    }
}

extension MovieDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.movieDetail
}
