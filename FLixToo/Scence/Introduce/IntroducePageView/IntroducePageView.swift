//
//  IntroducePageView.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import SnapKit

class IntroducePageView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let nibNamed = "IntroducePageView"
    
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
        titleLabel.font = Typography.fontAbrilFatfaceRegular29
        titleLabel.textColor = .white
        contentLabel.font = Typography.fontPoppinsRegular14
        contentLabel.textColor = .white
    }
    
    func setContent(image: UIImage?, title: String, content: String) {
        imageView.image = image
        titleLabel.text = title
        contentLabel.text = content
    }
}
