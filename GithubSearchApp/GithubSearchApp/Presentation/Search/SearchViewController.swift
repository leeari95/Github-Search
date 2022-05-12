//
//  ViewController.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/04.
//

import UIKit

class SearchViewController: UIViewController {
    
    let items = [
               RepositoryItem(id: 123, name: "Repository Title", login: "leeari95", description: "Repository Description", isMarkStar: true, starredCount: 123),
               RepositoryItem(id: 121, name: "Repository Title", login: "leeari95", description: "Repository Description", isMarkStar: false, starredCount: 0),
               RepositoryItem(id: 122, name: "Repository Title", login: "leeari95", description: "Repository Description", isMarkStar: false, starredCount: 0),
               RepositoryItem(id: 120, name: "Repository Title", login: "leeari95", description: "Repository Description", isMarkStar: false, starredCount: 99),
               RepositoryItem(id: 124, name: "Repository Title", login: "leeari95", description: "Repository Description", isMarkStar: true, starredCount: 0),
               RepositoryItem(id: 125, name: "Repository Title", login: "leeari95", description: "Repository Description", isMarkStar: true, starredCount: 123),
               RepositoryItem(id: 126, name: "Repository Title", login: "leeari95", description: "Repository Description", isMarkStar: false, starredCount: 0),
               RepositoryItem(id: 127, name: "Repository Title", login: "leeari95", description: "Repository Description", isMarkStar: false, starredCount: 0),
               RepositoryItem(id: 128, name: "Repository Title", login: "leeari95", description: "Repository Description", isMarkStar: false, starredCount: 99),
               RepositoryItem(id: 129, name: "Repository Title", login: "leeari95", description: "Repository Description", isMarkStar: true, starredCount: 0)
           ]
    
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
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.placeholder = "Please enter your search term."
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.hidesWhenStopped = true
        activityView.stopAnimating()
        activityView.center = CGPoint(x:  self.view.center.x, y:  self.view.center.y - 100)
        return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        setUpSubViews()
        setUpCollectionView()
    }
    
    func setUpNavigationItem() {
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.sizeToFit()
        
        let loginButton = UIBarButtonItem(title: "Login", style: .plain, target: nil, action: nil)
        loginButton.tintColor = .label
        navigationItem.rightBarButtonItem = loginButton
    }
    
    func setUpSubViews() {
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
    }
    
    func setUpCollectionView() {
        let registration = UICollectionView.CellRegistration<RepoListCell, RepositoryItem>  { cell, indexPath, item in
            cell.item = item
        }
        dataSource = UICollectionViewDiffableDataSource<Section, RepositoryItem>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: RepositoryItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
            return cell
        }
        snapshot = NSDiffableDataSourceSnapshot<Section, RepositoryItem>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard searchBar.searchTextField.text != "" else {
            return
        }
        searchBar.endEditing(true)
        let newData = items.filter { $0.id.description == searchBar.searchTextField.text ?? "" }
        var snapshot = NSDiffableDataSourceSnapshot<Section, RepositoryItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(newData)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}
