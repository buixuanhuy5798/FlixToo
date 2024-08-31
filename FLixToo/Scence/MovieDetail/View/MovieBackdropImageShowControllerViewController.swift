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
    var source: [KingfisherSource] {
        return backdrop?.backdrops?.map { $0.filePath ?? "" }.map { AppConstant.imageUrl + $0 }.map { KingfisherSource(urlString: $0) }.compactMap { $0 } ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSlideShow.setImageInputs(source)
        imageSlideShow.pageIndicator = nil
        pageLabel.textColor = .white
        pageLabel.font = Typography.fontSemibold14
        imageSlideShow.delegate = self
        pageLabel.text = "\(1)/\(source.count)"
    }
    

    @IBAction func handleTapCloseButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension MovieBackdropImageShowControllerViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        pageLabel.text = "\(page+1)/\(source.count)"
    }
}

extension MovieBackdropImageShowControllerViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.movieDetail
}
