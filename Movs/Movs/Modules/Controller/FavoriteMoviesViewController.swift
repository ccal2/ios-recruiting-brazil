//
//  FavoriteMoviesViewController.swift
//  Movs
//
//  Created by Carolina Cruz Agra Lopes on 19/12/19.
//  Copyright © 2019 Carolina Lopes. All rights reserved.
//

import UIKit

class FavoriteMoviesViewController: UIViewController, FilterApplyer {

    // MARK: - Screen

    private lazy var screen = FavoriteMoviesScreen()

    // MARK: - Search properties

    private var searchedMovies: [Movie] = []
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    private var lastSearchText: String = ""

    var isSearchBarEmpty: Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }

    private var isSearching: Bool {
        return self.searchController.isActive && !self.isSearchBarEmpty
    }

    // MARK: - Data

    private var displayMovies: [Movie] {
        if self.isSearching {
            return self.searchedMovies
        } else {
            return self.baseMovies
        }
    }

    // MARK: - Filter properties

    private let filterOptionsVC = FilterOptionsViewController()

    private var baseMovies: [Movie] {
        if self.isFiltering {
            return self.filteredMovies
        } else {
            return DataProvider.shared.favoriteMovies.sorted { $0.popularity > $1.popularity }
        }
    }

    // MARK: FilterApplyer protocol

    var filteredMovies: [Movie] = []
    var isFiltering: Bool = false

    // MARK: - Life cycle

    override func loadView() {
        self.view = self.screen
        self.screen.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Favorites"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"), style: .plain, target: self, action: #selector(self.showFilterOptions))
        self.setupSearch()

        self.filterOptionsVC.delegate = self

        DataProvider.shared.didChangeFavorites = {
            DispatchQueue.main.async {
                self.updateData()
            }
        }
    }

    // MARK: - Search

    private func setupSearch() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search"

        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }

    private func filterContent(forText text: String) {
        self.searchedMovies = self.baseMovies.filter { movie in
            return movie.title.lowercased().contains(text.lowercased())
        }

        self.screen.tableView.reloadData()
    }

    // MARK: - Navigation Bar actions

    @objc func showFilterOptions() {
        let filterNavController = UINavigationController(rootViewController: self.filterOptionsVC)
        filterNavController.navigationBar.tintColor = .systemIndigo
        filterNavController.navigationBar.prefersLargeTitles = false
        filterNavController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.systemIndigo]
        filterNavController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemIndigo]
        filterNavController.presentationController?.delegate = self.filterOptionsVC

        self.present(filterNavController, animated: true)
    }
}

extension FavoriteMoviesViewController: TableViewScreenDelegate {

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        if DataProvider.shared.favoriteMovies.isEmpty {
            self.screen.displayEmptyFavorites()
        } else if self.isSearching && self.searchedMovies.isEmpty {
            self.screen.displayEmptySearch()
        } else {
            self.screen.hideEmptyFavorites()
            self.screen.hideEmptySearch()
        }

        return self.displayMovies.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteMovieCell.reuseIdentifier, for: indexPath) as? FavoriteMovieCell else {
            fatalError("Wrong table view cell type")
        }

        cell.configure(with: self.displayMovies[indexPath.section])

        return cell
    }

    // MARK: - UITabelViewDelegate

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = MovieDetailViewController(movie: self.displayMovies[indexPath.section])
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unfavoriteAction = UIContextualAction(style: .normal, title: "Unfavorite", handler: { (_, _, success) in
            self.displayMovies[indexPath.section].isFavorite = false
            success(true)
        })
        unfavoriteAction.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [unfavoriteAction])
    }
}

// MARK: - UISearchResultsUpdating

extension FavoriteMoviesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces) ?? ""

        if text != self.lastSearchText {
            self.filterContent(forText: text)
            self.lastSearchText = text
        }
    }
}

// MARK: - FilterApplyer

extension FavoriteMoviesViewController {

    func updateData() {
        self.filterOptionsVC.applyFilter()
        self.navigationItem.rightBarButtonItem?.image = self.isFiltering ? UIImage(systemName: "line.horizontal.3.decrease.circle.fill") : UIImage(systemName: "line.horizontal.3.decrease.circle")
        self.filterContent(forText: self.lastSearchText)
        self.screen.tableView.reloadData()
    }
}
