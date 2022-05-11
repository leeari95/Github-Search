//
//  RepoListCell.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/08.
//

import UIKit

class RepoListCell: UICollectionViewCell {
    var item: RepositoryItem?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var ownerLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var starredCountLabel: UILabel!
    @IBOutlet var starredToggleButton: UIButton!

    @IBOutlet var labelStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    override func prepareForReuse() {
        reset()
    }

    func configure(item: RepositoryItem?) {
        self.item = item
        titleLabel.text = item?.name
        ownerLabel.text = item?.login
        descriptionLabel.text = item?.description
        starredCountLabel.text = "★ \(item?.starredCount.description ?? "0")"
        if item?.isMarkedStar == true {
            changeStarredToggleButton(imageName: "star.fill")
        } else {
            changeStarredToggleButton(imageName: "star")
        }
    }
    
    func changeStarredToggleButton(imageName: String) {
        let starImage: UIImage?
        starImage = UIImage(named: imageName)
        starredToggleButton.setImage(starImage, for: .normal)
    }
    
    func toggle() {
        if starredToggleButton.imageView?.image == UIImage(named: "star") {
            changeStarredToggleButton(imageName: "star.fill")
            starredCountLabel.text = "★ \((item?.starredCount ?? 0) + 1)"
        } else {
            changeStarredToggleButton(imageName: "star")
            starredCountLabel.text = "★ \((item?.starredCount ?? 0))"
        }
    }
    
    private func reset() {
        titleLabel.text = nil
        ownerLabel.text = nil
        descriptionLabel.text = nil
        starredCountLabel.text = nil
        changeStarredToggleButton(imageName: "star")
    }
}
