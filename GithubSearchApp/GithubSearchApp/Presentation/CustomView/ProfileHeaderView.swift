//
//  ProfileHeaderView.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/11.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ user: User?) {
        profileImage.load(url: user?.profileImageURL ?? "", placeholder: nil)
        nameLabel.text = user?.name
    }
    
}
