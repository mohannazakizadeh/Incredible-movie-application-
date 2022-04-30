//
//  TopRatedMoviesPresenter.swift
//  TopRatedMovies
//
//  Created by mohannazakizadeh on 4/23/22.
//

import Foundation
import UIKit

final class TopRatedMoviesPresenter: PresenterInterface {

    var router: TopRatedMoviesRouterInterface!
    var interactor: TopRatedMoviesInteractorInterface!
    weak var view: TopRatedMoviesViewInterface!
    
    private var movies: [Movie]?
    private var currentPage = 1
    
    init() {
        // in order to scroll top top when user tapped te tab bar again
        NotificationCenter.default.addObserver(forName: TabBarViewContorller.tabBarDidTapNotification, object: nil, queue: nil) { notification in
            self.view.scrollToTop()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension TopRatedMoviesPresenter: TopRatedMoviesPresenterRouterInterface {

}

extension TopRatedMoviesPresenter: TopRatedMoviesPresenterInteractorInterface {

}

extension TopRatedMoviesPresenter: TopRatedMoviesPresenterViewInterface {

    func viewDidLoad() {
        getTopRatedMovies()
    }
    
    func alertRetryButtonDidTap() {
        getTopRatedMovies()
    }
    
    // function to get movie image from url that we have
    func getMovieImage(index: Int, completion: @escaping (UIImage) -> ()) {
        
        if let movies = movies {
            if let path = movies[index].poster {
                return interactor.getMovieImage(for: path, completion: completion)
            }
        }
         else {
            completion(UIImage(systemName: "film.circle")!)
        }
        
    }
    
    func getMovieTitle(index: Int) -> String {
        movies?[index].title ?? ""
    }
    
    func movieSelected(at index: Int) {
        if let movies = movies {
            interactor.getMovieDetails(id: movies[index].id) { [weak self] result in
                switch result {
                case .success(let movie):
                    self?.router.showMovieDetails(movie)
                    
                case .failure(let error):
                    self?.view.showError(with: error)
                }
            }
        }
        
    }
    
    func addToWatchList(index: Int, imageData: Data) {
        if let movies = movies {
            let savedMovie = CoreDataMovie(title: movies[index].title, poster: imageData, id: movies[index].id, date: Date.now, voteAverage: movies[index].voteAverage)
            CoreDataManager().saveNewMovie(savedMovie)
        }
    }
    
    func getTopRatedMovies() {
        // movie data base gives 495 pages max.
        if currentPage < 496 {
            interactor.getTopRatedMovies(page: currentPage) { result in
                switch result {
                case .success(let moviesData):
                    
                    if self.currentPage == 1 {
                        self.movies = moviesData.results
                    } else {
                        self.movies! += moviesData.results
                    }
                    
                    self.view.reloadCollectionView()
                    self.currentPage += 1
                    
                    
                case .failure(let error):
                    self.view.showError(with: error)
                }
            }
        }
        
    }
    
    func getSavedMovies() -> [CoreDataMovie] {
        CoreDataManager().getSavedMovies()
    }
    
    var numberOfMovies: Int {
        return movies?.count ?? 0
    }
    
    var topRatedMovies: [Movie] {
        get {
            return movies ?? []
        }
    }

}
