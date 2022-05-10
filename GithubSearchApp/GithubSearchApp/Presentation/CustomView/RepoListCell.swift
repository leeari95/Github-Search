//
//  RepoListCell.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/08.
//

import UIKit

class RepoListCell: UICollectionViewListCell {
    var item: RepositoryItem?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var customConfiguration = RepoContentConfiguration().updated(for: state)
        customConfiguration.item = item
        customConfiguration.title = item?.name
        customConfiguration.owner = item?.login
        customConfiguration.description = item?.description
        customConfiguration.starredCount = "★ \(item?.starredCount ?? 0)"
        customConfiguration.isMarkStar = item?.isMarkedStar
        contentConfiguration = customConfiguration

        let contentView = contentView as? RepoContentView
        if item?.isMarkedStar == true {
            contentView?.changeStarredToggleButton(systemName: "star.fill")
        } else {
            contentView?.changeStarredToggleButton(systemName: "star")
        }
    }
}

struct RepoContentConfiguration: UIContentConfiguration {
    var item: RepositoryItem?
    var title: String?
    var owner: String?
    var description: String?
    var starredCount: String?
    var isMarkStar: Bool?
    
    func makeContentView() -> UIView & UIContentView {
        return RepoContentView(self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
