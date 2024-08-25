//
//  VerticalAlignedLabel.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit

class VerticalAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        var newRect = rect
        switch contentMode {
        case .top:
            newRect.size.height = sizeThatFits(rect.size).height + 2
        case .bottom:
            let height = sizeThatFits(rect.size).height
            newRect.origin.y += rect.size.height - height
            newRect.size.height = height
        default:
            ()
        }
        super.drawText(in: newRect)
    }
}
