//
//  IntroduceViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 22/8/24.
//

import UIKit
import Reusable

class IntroduceViewController: UIViewController {

    @IBOutlet weak var continueButton: BaseFillButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var currentPage = 0 {
        didSet {
            if currentPage == 2 {
                continueButton.setTitle("Let's Go", for: .normal)
            } else {
                continueButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        continueButton.setTitle("Next", for: .normal)
        configScrollView()
    }
    
    private func configScrollView() {
        scrollView.contentSize = CGSize(width: Screen.width * 3,
                                        height: Screen.height)
        scrollView.isPagingEnabled = true
        let firstPage = IntroducePageView(frame: CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height))
        firstPage.setContent(image: UIImage(named: "onboarding_image_1"), title: "Movies & Shows", content: "Find out all latest Movies and shows on your home screen")
        scrollView.addSubview(firstPage)
        let secondPage = IntroducePageView(frame: CGRect(x: Screen.width, y: 0, width: Screen.width, height: Screen.height))
        secondPage.setContent(image: UIImage(named: "onboarding_image_2"), title: "Discover More...", content: "Check out all details of movies and shows on one dedicated page")
        scrollView.addSubview(secondPage)
        let thirdPage = IntroducePageView(frame: CGRect(x: Screen.width * 2, y: 0, width: Screen.width, height: Screen.height))
        thirdPage.setContent(image: UIImage(named: "onboarding_image_3"), title: "Your Library", content: "List all your shows and Movies in library for watch later")
        scrollView.addSubview(thirdPage)
        scrollView.isScrollEnabled = false
    }
    
    @IBAction func handleTapNextButton(_ sender: Any) {
        if currentPage < 2 {
            currentPage += 1
            scrollView.setContentOffset(CGPoint(x: CGFloat(currentPage) * Screen.width,
                                                y: 0), animated: true)
            
        } else {
            let tabbar = MainTabBarController()
            Utils.swapRootViewController(tabbar)
        }
    }
}

extension IntroduceViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.introduce
}
