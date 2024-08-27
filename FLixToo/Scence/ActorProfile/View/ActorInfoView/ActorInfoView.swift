//
//  ActorInfoView.swift
//  FLixToo
//
//  Created by buixuanhuy on 27/08/2024.
//

import UIKit

class ActorInfoView: UIView {
    @IBOutlet weak var separateView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    private let nibNamed = "ActorInfoView"
    
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
        contentLabel.textColor = UIColor(hex: "D9D9D9")
        contentLabel.font = Typography.fontRegular14
        titleLabel.textColor = .white
        titleLabel.font = Typography.fontSemibold18
    }
    
    func setContentView(title: String, content: String, showLine: Bool = true) {
        titleLabel.text = title
        contentLabel.text = content
        separateView.isHidden = !showLine
    }
}
