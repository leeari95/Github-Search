//
//  ProfileHeaderView.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/12.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: ProfileHeaderView.self)
    }
    
    private lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .systemGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
        setUpLayout()
    }
    
    func configure(_ user: User?) {
        guard let user = user else {
            nameLabel.text = "Login is required."
            return
        }
        profileImageView.load(url: user.profileImageURL, placeholder: nil)
        nameLabel.text = user.name
    }
    
    private func setUpSubViews() {
        addSubview(backgroundStackView)
        backgroundStackView.addArrangedSubview(profileImageView)
        backgroundStackView.addArrangedSubview(nameLabel)
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: topAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            backgroundStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 128),
            profileImageView.heightAnchor.constraint(equalToConstant: 128)
        ])
    }
}
