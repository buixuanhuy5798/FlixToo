//
//  PopoverFilterViewController.swift
//  FLixToo
//
//  Created by NamTrinh on 30/08/2024.
//

import UIKit

class PopoverFilterViewController: UIViewController {

    @IBOutlet weak var movieButton: UIButton!
    @IBOutlet weak var tvShowsButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    
    var info = ""
    var filter: FilterLibraryType = .all
    
    var onApply: ((FilterLibraryType) -> Void)
    
    init(info: String, filter: FilterLibraryType, onApply: @escaping ((FilterLibraryType) -> Void)) {
        self.info = info
        self.filter = filter
        self.onApply = onApply
        super.init(nibName: "PopoverFilterViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = info
        updateButton()
    }

    @IBAction func handleClearAllButton(_ sender: Any) {
        filter = .all
        updateButton()
    }
    
    @IBAction func handleMovieButton(_ sender: Any) {
        filter = .movies
        updateButton()
    }
    
    @IBAction func handleTVShowsButton(_ sender: Any) {
        filter = .shows
        updateButton()
    }
    
    @IBAction func handleApplyButton(_ sender: UIButton) {
        onApply(filter)
        self.dismiss(animated: true)
    }
    
    private func updateButton() {
        switch filter {
        case .movies:
            movieButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            movieButton.tintColor = .systemBlue
            tvShowsButton.setImage(UIImage(systemName: "square.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            tvShowsButton.tintColor = UIColor(hex: "AAAAAA")
        case .shows:
            tvShowsButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            tvShowsButton.tintColor = .systemBlue
            movieButton.setImage(UIImage(systemName: "square.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            movieButton.tintColor = UIColor(hex: "AAAAAA")
        case .all:
            tvShowsButton.setImage(UIImage(systemName: "square.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            tvShowsButton.tintColor = UIColor(hex: "AAAAAA")
            movieButton.setImage(UIImage(systemName: "square.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
            movieButton.tintColor = UIColor(hex: "AAAAAA")
        }
    }
}

func presentPopover(_ parentViewController: UIViewController, _ viewController: UIViewController, sender: UIView, size: CGSize, arrowDirection: UIPopoverArrowDirection = .down) {
    viewController.preferredContentSize = size
    viewController.modalPresentationStyle = .popover
    if let pres = viewController.presentationController {
        pres.delegate = parentViewController
    }
    parentViewController.present(viewController, animated: true)
    if let pop = viewController.popoverPresentationController {
        pop.sourceView = sender
        pop.sourceRect = sender.bounds
        pop.permittedArrowDirections = arrowDirection
    }
}

extension UIViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
