//
//  CommentCell.swift
//  FLixToo
//
//  Created by buixuanhuy on 29/08/2024.
//

import UIKit
import Cosmos
import Reusable

class CommentCell: UITableViewCell, NibReusable {

    @IBOutlet weak var separateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = .white
        nameLabel.font = Typography.fontMedium14
        dateLabel.textColor = UIColor(hex: "AAAAAA")
        dateLabel.font = Typography.fontRegular12
        contentLabel.textColor = UIColor(hex: "C6C6C6")
        contentLabel.font = Typography.fontMedium12
        selectionStyle = .none
    }

    func setContentForCell(comment: Comment, showSeparaterView: Bool) {
        avatarImageView.kf.setImage(
            with: Utils.getUrlImage(path: comment.authorDetails?.avatarPath ?? ""),
                options: [
                    .loadDiskFileSynchronously,
                    .cacheOriginalImage,
                    .transition(.fade(0.1)),
                ])
        nameLabel.text = comment.author
        dateLabel.text = convertDate(isoDate: comment.createdAt ?? "")
        contentLabel.text = comment.content
        ratingView.rating = (Double((comment.authorDetails?.rating ?? 0)) / Double(10)) * 5
        separateView.isHidden = !showSeparaterView
    }
    
    func convertDate(isoDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        // Chuyển đổi chuỗi ngày tháng thành đối tượng Date
        if let date = isoFormatter.date(from: isoDate) {
            // Tạo một DateFormatter khác để định dạng đối tượng Date thành chuỗi với định dạng "MMMM d, yyyy"
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM d, yyyy"
            
            // Định dạng lại đối tượng Date thành chuỗi ngày tháng cần thiết
            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
        } else {
            return ""
        }
    }
}
