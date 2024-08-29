//
//  GenreCollectionViewCell.swift
//  FLixToo
//
//  Created by NamTrinh on 28/08/2024.
//

import UIKit
import Reusable

final class GenreCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: bounds.width * 0.1, y: 0))
                path.addLine(to: CGPoint(x: 0, y: bounds.height))
                path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
                path.addLine(to: CGPoint(x: bounds.width, y: 0))
                path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        posterImageView.layer.mask = maskLayer
    
        
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update mask layer when layout changes
        if let maskLayer = layerView.layer.mask as? CAShapeLayer {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: bounds.width * 0.1, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: bounds.height))
                    path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
                    path.addLine(to: CGPoint(x: bounds.width, y: 0))
                    path.close()
            maskLayer.path = path.cgPath
        }
    }
    
    func randomColor() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func configCell(title: String, image: UIImage) {
        titleLabel.text = title
        layerView.backgroundColor = randomColor()
        posterImageView.image = image
    }

}
