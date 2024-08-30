//
//  HomeHeaderTableView.swift
//  FLixToo
//
//  Created by buixuanhuy on 29/08/2024.
//

import Foundation
import UIKit
import SnapKit

class HomeHeaderTableView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconNextImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let nibNamed = "HomeHeaderTableView"
    var didTapHeader: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(nibNamed, owner: self, options: nil)
        addSubview(contentView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        titleLabel.textColor = .white
        titleLabel.font = Typography.fontSemibold18
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapView)))
    }
    
    @objc private func handleTapView() {
        didTapHeader?()
    }
    
    func setContentForCell(title: String, icon: UIImage?, hiddenIconNext: Bool = false) {
        titleLabel.text = title
        iconImageView.image = icon
        iconNextImageView.isHidden = hiddenIconNext
    }
}
