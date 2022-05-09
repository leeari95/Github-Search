//
//  RepoContentView.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/08.
//

import UIKit

class RepoContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            apply(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpSubViews()
        setUpLayout()
        setUpStarredButton()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var backgroundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private var ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private var starredCountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private var starredToggleButton: UIButton = {
        let button = UIButton()
        let starImage = UIImage(systemName: "star")
        button.setImage(starImage, for: .normal)
        button.tintColor = .systemYellow
        return button
    }()
    
    private func apply(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? RepoContentConfiguration else {
            return
        }
        titleLabel.text = configuration.title
        ownerLabel.text = configuration.owner
        descriptionLabel.text = configuration.description
        starredCountLabel.text = configuration.starredCount
    }
    
    private func setUpSubViews() {
        addSubview(backgroundStackView)
        backgroundStackView.addArrangedSubview(labelsStackView)
        backgroundStackView.addArrangedSubview(starredToggleButton)
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(ownerLabel)
        labelsStackView.addArrangedSubview(descriptionLabel)
        labelsStackView.addArrangedSubview(starredCountLabel)
    }
    
    private func setUpLayout() {
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            backgroundStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8),
            backgroundStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor,constant: -12)
        ])
    }
    
    private func setUpStarredButton() {
        starredToggleButton.addTarget(self, action: #selector(didTapStarredButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapStarredButton(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(systemName: "star") {
            let starImage = UIImage(systemName: "star.fill")
            starredToggleButton.setImage(starImage, for: .normal)
        } else {
            let starImage = UIImage(systemName: "star")
            starredToggleButton.setImage(starImage, for: .normal)
        }
    }
    
    func changeStarredToggleButton() {
        let starImage = UIImage(systemName: "star.fill")
        starredToggleButton.setImage(starImage, for: .normal)
    }
    
    func reset() {
        let starImage = UIImage(systemName: "star")
        starredToggleButton.setImage(starImage, for: .normal)
    }
}
