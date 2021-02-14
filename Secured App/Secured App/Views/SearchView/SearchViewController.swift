//
//  SearchViewController.swift
//  Secured App
//
//  Created by Mateusz Bąk on 22/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

final class SearchViewController: UITableViewController {
    
    private let movieLoading = MovieLoading()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let searchNetworkManager = NetworkManager<SearchService, Movies>()
    
    private var dataSource: UITableViewDiffableDataSource<Movies, Movie>?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedMovie = dataSource?.itemIdentifier(for: indexPath) else { return }
        navigationController?.pushViewController(MovieDetailsViewController(movie: selectedMovie), animated: true)
    }
}

private extension SearchViewController {
    func setupView() {
        setupTitle()
        setupRootView()
        setupNavigationItem()
        setupSearchController()
        setupTableView()
    }
    
    func setupTitle() {
        title = "Wyszukiwarka"
    }
    
    func setupRootView() {
        definesPresentationContext = true
    }
    
    func setupNavigationItem() {
        navigationItem.searchController = searchController
    }
    
    func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Szukaj filmów..."
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(MoviesListCell.self, forCellReuseIdentifier: MoviesListCell.reuseIdentifier)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        
        createDataSource()
    }
    
    func createDataSource() {
        dataSource = UITableViewDiffableDataSource<Movies, Movie>(tableView: tableView) { tableView, indexPath, movie in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesListCell.reuseIdentifier, for: indexPath) as? MoviesListCell else {
                fatalError("Unable to dequeue MoviesListCell")
            }
            cell.updateView(with: movie)
            return cell
        }
        dataSource?.defaultRowAnimation = .fade
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dataSource?.apply(NSDiffableDataSourceSnapshot<Movies, Movie>())
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchQuery = searchController.searchBar.text, searchQuery.count > 2 {
            fetchSearch(for: searchQuery)
            return
        }
        dataSource?.apply(NSDiffableDataSourceSnapshot<Movies, Movie>())
    }
    
    private func fetchSearch(for searchQuery: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.movieLoading.show(in: self.view)
        }
        searchNetworkManager.request(from: .movie(query: searchQuery, page: 1)) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                self?.movieLoading.dissmis()
            }
            switch result {
            case .success(let movies):
                var snapshot = NSDiffableDataSourceSnapshot<Movies, Movie>()
                snapshot.appendSections([movies])
                snapshot.appendItems(movies.results, toSection: movies)
                self?.dataSource?.apply(snapshot)
            case .failure:
                break
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) { }
}
