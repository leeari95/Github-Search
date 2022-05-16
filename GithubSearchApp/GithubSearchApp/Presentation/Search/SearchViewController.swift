//
//  ViewController.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/04.
//

import UIKit

class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModel?
    
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
        collectionView.prefetchDataSource = self
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
        bind()
    }
    
    func setUpNavigationItem() {
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.sizeToFit()
        
        let loginButton = UIBarButtonItem(title: LoginManager.shared.isLogged ? "Logout" : "Login", style: .plain, target: self, action: #selector(didTapLoginButton(_:)))
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
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item
            )
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapCell(_:)))
            tap.cancelsTouchesInView = false
            cell.addGestureRecognizer(tap)
            return cell
        }
        snapshot = NSDiffableDataSourceSnapshot<Section, RepositoryItem>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func didTapCell(_ gestureRecognizer: UIGestureRecognizer) {
        let touchLocation = gestureRecognizer.location(in: gestureRecognizer.view)
        let cellSize = gestureRecognizer.view?.frame.size ?? CGSize()
        let heightCenter = cellSize.height / 2
        let isTappedStarredButton = (cellSize.width * 0.9...cellSize.width * 0.95).contains(touchLocation.x)
        && (heightCenter - 10...heightCenter + 15).contains(touchLocation.y)
        
        guard isTappedStarredButton else {
            return
        }
        guard LoginManager.shared.isLogged else {
            showAlert(title: "Not logged in", message: "Login is required.") {
                self.viewModel?.didTapLoginButton()
            }
            return
        }
        guard let cell = gestureRecognizer.view as? UICollectionViewListCell,
        let indexPath = self.collectionView.indexPath(for: cell),
        let repositoryItem = self.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        viewModel?.starred(repositoryItem)
    }
    
    func bind() {
        viewModel?.items.observe { newItems in
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
        }
        
        viewModel?.isLoading.observe { completed in
            DispatchQueue.main.async {
                if completed {
                    self.activityView.startAnimating()
                } else {
                    self.activityView.stopAnimating()
                }
            }
        }
        viewModel?.isLogged.observe({ isLogged in
            DispatchQueue.main.async {
                if isLogged {
                    self.navigationItem.rightBarButtonItem?.title = "Logout"
                } else {
                    self.navigationItem.rightBarButtonItem?.title = "Login"
                }
            }
        })
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
        viewModel?.didSearch(keyword: searchBar.searchTextField.text ?? "")
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let lastRow = indexPaths.last?.row
        let readyPrefetchingRow = (viewModel?.items.value?.count ?? 0) - 2
        if lastRow == readyPrefetchingRow {
            viewModel?.didScroll()
        }
    }
}
