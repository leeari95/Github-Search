//
//  ProfileViewController.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/08.
//

import UIKit

class ProfileViewController: UIViewController {

    var viewModel: ProfileViewModel?
    
    var dataSource: UICollectionViewDiffableDataSource<Section, RepositoryItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, RepositoryItem>!
    
    lazy var collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.keyboardDismissMode = .onDrag
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.hidesWhenStopped = true
        activityView.stopAnimating()
        activityView.center = CGPoint(x:  self.view.center.x, y:  self.view.center.y)
        return activityView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        setUpViews()
        bind()
    }
    
    func setUpNavigationItem() {
        navigationItem.title = "Profile"
        navigationController?.navigationBar.sizeToFit()
        
        let loginButton = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(didTapLoginButton(_:)))
        loginButton.tintColor = .label
        navigationItem.rightBarButtonItem = loginButton
    }
    
    @objc private func didTapLoginButton(_ sender: UIBarButtonItem) {
        if KeychainStorage.shard.load("Token") != nil {
            showAlert(title: "Notice", message: "Are you sure you want to log out?") {
                self.viewModel?.didTapLogoutButton()
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem?.title = "Login"
                }
            }
        } else {
            viewModel?.didTapLoginButton()
        }
    }
    
    func setUpViews() {
        view.addSubview(collectionView)
        view.addSubview(activityView)
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        let registration = UICollectionView.CellRegistration<RepoListCell, RepositoryItem>  { cell, indexPath, item in
            cell.item = item
        }
        dataSource = UICollectionViewDiffableDataSource<Section, RepositoryItem>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: RepositoryItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item
            )
            return cell
        }
        snapshot = NSDiffableDataSourceSnapshot<Section, RepositoryItem>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: true)
        
        // Set Up HeaderView
        collectionView.register(
            ProfileHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderView.reuseIdentifier
        )
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var section: NSCollectionLayoutSection
            var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
            listConfiguration.headerMode = .supplementary
            section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
            return section
        }
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        collectionView.setCollectionViewLayout(layout, animated: true)

        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderView.reuseIdentifier,
                for: indexPath
            ) as? ProfileHeaderView
            
            headerView?.configure(nil)
            return headerView
        }
    }
    
    func bind() {
        viewModel?.items.observe({ newItems in
            var snapshot = NSDiffableDataSourceSnapshot<Section, RepositoryItem>()
            snapshot.appendSections([.main])
            
            let diff = newItems.difference(from: snapshot.itemIdentifiers)
            let currentIdentifiers = snapshot.itemIdentifiers
            guard let newIdentifiers = currentIdentifiers.applying(diff) else {
                return
            }
            snapshot.deleteItems(currentIdentifiers)
            snapshot.appendItems(newIdentifiers)
            DispatchQueue.main.async {
                self.dataSource.applySnapshotUsingReloadData(snapshot, completion: nil)
            }
        })
    }
}

extension ProfileViewController: UICollectionViewDelegate {}
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 150
        return CGSize(width: width, height: height)
    }
}
