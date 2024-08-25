//
//  MainTabBarController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBar()
        // Do any additional setup after loading the view.
    }
    
    private func configTabBar() {
        let home = HomeViewController.instantiate()
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home_tab_normal"), selectedImage: UIImage(named: "home_tab_selected"))
        
        let search = SearchViewController.instantiate()
        let searchNav = UINavigationController(rootViewController: search)
        searchNav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search_tab_normal"), selectedImage: UIImage(named: "search_tab_selected"))
        
        let cinemas = CinemasViewController.instantiate()
        let cinemasNav = UINavigationController(rootViewController: cinemas)
        cinemasNav.tabBarItem = UITabBarItem(title: "Cinemas", image: UIImage(named: "cinema_tab_normal"), selectedImage: UIImage(named: "cinema_tab_selected"))
        
        let library = LibraryViewController.instantiate()
        let libraryNav = UINavigationController(rootViewController: library)
        libraryNav.tabBarItem = UITabBarItem(title: "Library", image: UIImage(named: "library_tab_normal"), selectedImage: UIImage(named: "library_tab_selected"))
        
        let setting = SettingViewController.instantiate()
        let settingNav = UINavigationController(rootViewController: setting)
        settingNav.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "setting_tab_normal"), selectedImage: UIImage(named: "setting_tab_selected"))
        tabBar.backgroundColor = .black
        tabBar.unselectedItemTintColor = UIColor(hex: "C6C6C6")
        viewControllers = [homeNav, searchNav, cinemasNav, libraryNav, settingNav]
    }
}
