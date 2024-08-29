//
//  LibaryTagCollectionViewCell.swift
//  FLixToo
//
//  Created by NamTrinh on 29/08/2024.
//

import UIKit
import Reusable
import SwiftUI

final class LibaryTagCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layerView.layer.cornerRadius = 15
    }

    func configCell(title: String, isSelected: Bool) {
        titleLabel.text = title
        layerView.removeGradientLayer()
        if isSelected {
            titleLabel.textColor = .white
            layerView.backgroundColor = UIColor(hex: "5666F8")
        } else {
            titleLabel.textColor =  UIColor(hex: "AAAAAA")
            layerView.backgroundColor = UIColor(hex: "272727")
        }
    }
}
