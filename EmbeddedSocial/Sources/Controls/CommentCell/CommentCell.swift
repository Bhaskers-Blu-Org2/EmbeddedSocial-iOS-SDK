//
//  CommentCell.swift
//  EmbeddedSocial
//
//  Created by Mac User on 31.07.17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

protocol CommentCellDelegate: class {
    func like(cell: CommentCell)
    func toReplies()
}

class CommentCell: UITableViewCell {

    @IBOutlet weak var likesCountButton: UIButton!
    @IBOutlet weak var repliesCountButton: UIButton!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var mediaButtonHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var postedTimeLabel: UILabel!
    
    var delegate: CommentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarButton.imageView?.contentMode = .scaleAspectFill
    }
    
    static let identifier = "CommentCell"
    static let defaultHeight: CGFloat = 190

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(comment: Comment) {
        avatarButton.setPhotoWithCaching(Photo(uid: UUID().uuidString,
                                               url: comment.photoUrl,
                                               image: nil),
                                         placeholder: UIImage(asset: .userPhotoPlaceholder))
        repliesCountButton.setTitle("\(comment.totalReplies ) replies", for: .normal)
        likesCountButton.setTitle("\(comment.totalLikes ) likes", for: .normal)
        commentTextLabel.text = comment.text
        usernameLabel.text = "\(comment.firstName ?? "") \(comment.lastName ?? "")"
        if let url = comment.mediaUrl {
            mediaButton.setPhotoWithCaching(Photo(uid: UUID().uuidString,
                                                  url: url,
                                                  image: nil),
                                            placeholder: UIImage(asset: .userPhotoPlaceholder))
            mediaButtonHeightConstraint.constant = 250
        } else {
            mediaButtonHeightConstraint.constant = 999
        }
        contentView.layoutIfNeeded()
        // TODO: full fit
        
    }
    
    @IBAction func likePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.like(cell: self)
    }

    @IBAction func commentPressed(_ sender: Any) {
    }
    
    @IBAction func mediaPressed(_ sender: Any) {
    }
}
