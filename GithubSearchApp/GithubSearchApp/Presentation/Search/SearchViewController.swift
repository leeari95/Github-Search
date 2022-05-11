//
//  ViewController.swift
//  GithubSearchApp
//
//  Created by Ari on 2022/05/04.
//

import UIKit

class SearchViewController: UIViewController {
    

    lazy var collectionView: UICollectionView = {
        let layout = DynamicHeightFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = false
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.dataSource = self
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
        let activityView = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityView.style = .medium
        } else {
            activityView.style = .gray
        }
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
        setUpNotification()
        edgesForExtendedLayout = .bottom
    }
    
    func setUpNavigationItem() {
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.sizeToFit()
        
        let loginButton = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(didTapLoginButton(_:)))
        if #available(iOS 13.0, *) {
            loginButton.tintColor = .label
        } else {
            loginButton.tintColor = .white
        }
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
        let nib = UINib(nibName: "RepoListCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
    }
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showNotiAlert(_:)), name: .showNotiAlert, object: nil)
    }
    
    @objc private func showNotiAlert(_ sender: Notification) {
        let message = sender.object as? Message
        message.flatMap {
            showAlert(title: $0.title, message: $0.description) {
                self.viewModel?.didTapLoginButton()
            }
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(
            _ collectionView: UICollectionView,
            numberOfItemsInSection section: Int
        ) -> Int {
            return viewModel?.items.value?.count ?? 0
        }
    
    func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "cell",
                for: indexPath
            ) as? RepoListCell else {
                return UICollectionViewCell()
            }
            cell.configure(item: viewModel?.items.value?[indexPath.item])
            return cell
        }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard searchBar.text != "" else {
            return
        }
        searchBar.endEditing(true)
    }
}
