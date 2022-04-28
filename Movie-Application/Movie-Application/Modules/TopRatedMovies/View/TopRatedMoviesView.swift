//
//  TopRatedMoviesView.swift
//  TopRatedMovies
//
//  Created by mohannazakizadeh on 4/23/22.
//

import UIKit

final class TopRatedMoviesView: UIViewController, ViewInterface {
	
	var presenter: TopRatedMoviesPresenterViewInterface!
	
	// MARK: - Properties
	
	
	// MARK: - Initialize

	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
        configureNavigation()
        
		
		self.applyTheme()
		self.presenter.viewDidLoad()
	}
	
	
	// MARK: - Theme
	
	func applyTheme() {
        
    }
    
    // MARK: - Private functions
    private func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Top Rated"
    }
	
    private func configureMoviesCollectionView() {
        let collectionView = MoviesCollectionModule().build(movies: presenter.topRatedMovies, viewType: .topRated)
        self.add(asChildViewController: collectionView, to: self.view)
    }
	
	// MARK: - Actions
	
	
}

extension TopRatedMoviesView: TopRatedMoviesViewInterface {
    func showError(with error: RequestError) {
        let errorAlert = UIAlertController(title: "Error Occured", message: error.errorDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Retry", style: .default) { [weak self] action in
            self?.presenter.alertRetryButtonDidTap()
        }
        errorAlert.addAction(alertAction)
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func reloadCollectionView() {
        configureMoviesCollectionView()
    }
}
