//
//  PopularMoviesViewController.swift
//  Movs
//
//  Created by Carolina Cruz Agra Lopes on 06/12/19.
//  Copyright © 2019 Carolina Lopes. All rights reserved.
//

import UIKit

class PopularMoviesViewController: UIViewController {

    // MARK: - Screen

    private lazy var screen = PopularMoviesScreen()

    // MARK: - Search

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
            return DataProvider.shared.movies
        }
    }

    // MARK: - Life cycle

    override func loadView() {
        self.view = self.screen
        self.screen.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Movies"
        self.navigationItem.largeTitleDisplayMode = .always
        self.setupSearch()

        self.screen.startLoading()

        DataProvider.shared.setup { error in
            DispatchQueue.main.async {
                self.screen.stopLoading()

                if error != nil {
                    self.screen.displayError()
                } else {
                    var indexPaths: [IndexPath] = []
                    for row in 0...DataProvider.shared.movies.count-1 {
                        indexPaths.append(IndexPath(row: row, section: 0))
                    }

                    self.screen.collectionView.insertItems(at: indexPaths)
                }
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
        self.searchedMovies = DataProvider.shared.movies.filter { movie in
            return movie.title.lowercased().contains(text.lowercased())
        }

        self.screen.collectionView.reloadData()
    }
}

extension PopularMoviesViewController: CollectionViewScreenDelegate {

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isSearching && self.searchedMovies.isEmpty {
            self.screen.displayEmptySearch()
        } else {
            self.screen.hideEmptySearch()
        }

        return self.displayMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMovieCell.reuseIdentifier, for: indexPath) as? PopularMovieCell else {
            fatalError("Wrong collection view cell type")
        }

        cell.configure(with: self.displayMovies[indexPath.row])

        return cell
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !self.isSearching && indexPath.row == DataProvider.shared.movies.count - 1 {
            DataProvider.shared.getMoreMovies { error in
                DispatchQueue.main.async {
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: "Could not load more movies", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))

                        self.present(alert, animated: true)
                    } else {
                        var indexPaths: [IndexPath] = []
                        for row in indexPath.row+1...DataProvider.shared.movies.count-1 {
                            indexPaths.append(IndexPath(row: row, section: 0))
                        }

                        self.screen.collectionView.insertItems(at: indexPaths)
                    }
                }
            }
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 170.0
        let height = width * 1.76
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth: CGFloat = 170

        let numberOfCells = floor(collectionView.frame.size.width / cellWidth)
        let edgeInsets = (collectionView.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)

        return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 0, right: edgeInsets)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieDetailViewController(movie: self.displayMovies[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension PopularMoviesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces) ?? ""

        if text != self.lastSearchText {
            self.filterContent(forText: text)
            self.lastSearchText = text
        }
    }
}
