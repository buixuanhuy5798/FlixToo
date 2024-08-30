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
    
    init(info: String) {
            self.info = info
            super.init(nibName: "PopoverFilterViewController", bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = info
    }

    @IBAction func handleClearAllButton(_ sender: Any) {
    }
    
    @IBAction func handleApplyButton(_ sender: UIButton) {
        self.dismiss(animated: true)
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
