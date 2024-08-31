//
//  MovieBackdropImageShowControllerViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 31/8/24.
//

import UIKit
import ImageSlideshow
import Reusable

class MovieBackdropImageShowControllerViewController: UIViewController {

    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    var backdrop: BackdropsMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let source = backdrop?.backdrops?.map { $0.filePath ?? "" }.map { AppConstant.imageUrl + $0 }.map { KingfisherSource(urlString: $0) }.compactMap { $0 }
        let localSource = source ?? []
        imageSlideShow.setImageInputs(localSource)
    }
    

    @IBAction func handleTapCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension MovieBackdropImageShowControllerViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.movieDetail
}
