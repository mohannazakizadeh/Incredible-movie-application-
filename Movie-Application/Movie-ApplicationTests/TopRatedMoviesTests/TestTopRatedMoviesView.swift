//
//  TestTopRatedMoviesView.swift
//  Movie-ApplicationTests
//
//  Created by Mohanna Zakizadeh on 4/26/22.
//

import XCTest
@testable import Movie_Application

final class TestTopRatedMoviesView: XCTestCase {

    var view: TopRatedMoviesView!
// swiftlint: disable identifier_name
    var collectionViewDidSelectRowATCallsPresenterMovieSelectedExpectation: XCTestExpectation?
    var collectionViewNumberOfItemsCallsPresenterNumberOfMoviesExpectation: XCTestExpectation?
    var configureContextMenuCallsPresenterGetSavedMoviesExpectation: XCTestExpectation?
    var configureContextMenuCallsPresenterGetMovieTitleExpectation: XCTestExpectation?
    var configurePaginationCallsPresenterNumberOfMoviesExpectation: XCTestExpectation?

    override func setUpWithError() throws {
        let navigation = UIStoryboard(name: "TopRatedMovies",
                                      bundle: nil).instantiateInitialViewController() as? UINavigationController
        view = navigation?.topViewController as? TopRatedMoviesView
        view.presenter = self
        view.loadView()
        view.viewDidLoad()

    }

    override func tearDownWithError() throws {
        view = nil
    }

    func testViewHasCollectionView() throws {
        XCTAssert(type(of: view.collectionView) == UICollectionView?.self)
    }

    func testViewHasTopRatedTitle() throws {
        // Given
        let title = "Top Rated"

        // When
        let viewTitle = view.navigationItem.title

        // Then
        XCTAssert(viewTitle == title)
    }

    func testViewHasLargeTitle() throws {
        // Given
        let prefersLargeTitles = true

        // When
        let viewPrefersLargeTitles = view.navigationController!.navigationBar.prefersLargeTitles

        // Then
        XCTAssert(prefersLargeTitles == viewPrefersLargeTitles)
    }

    func testCollectionViewHasDataSource() throws {
        XCTAssertNotNil(view.collectionView.dataSource)
    }

    func testCollectionViewHasDelegate() throws {
        XCTAssertNotNil(view.collectionView.delegate)
    }

    func testViewConformsToCollectionViewDataSource() throws {
        XCTAssertNotNil(view as? UICollectionViewDataSource)
    }

    func testViewConformsToCollectionViewDelegate() throws {
        XCTAssertNotNil(view as? UICollectionViewDelegate)
    }

    func testViewConformsToCollectionViewDelegateFlowLayout() {
        XCTAssertNotNil(view as? UICollectionViewDelegateFlowLayout)
    }

    func testCollectionViewHasACellWithCityCellID() throws {
        XCTAssertNotNil(view.collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell",
                                                                for: IndexPath(index: 1)))
    }

    func testCollectionViewDidSelectRowATCallsPresenterMovieSelected() throws {
        collectionViewDidSelectRowATCallsPresenterMovieSelectedExpectation =
        expectation(description: "expect presenter movieSelected to fullfill this expectation")

        view.collectionView(view.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
        wait(for: [collectionViewDidSelectRowATCallsPresenterMovieSelectedExpectation!], timeout: 2)
    }

    func testCollectionViewNumberOfItemsCallsPresenterNumberOfMovies() throws {
        collectionViewNumberOfItemsCallsPresenterNumberOfMoviesExpectation =
        expectation(description: "expect presenter numberOfMovies fullfill this expectation")

        _ = view.collectionView(view.collectionView, numberOfItemsInSection: 0)
        wait(for: [collectionViewNumberOfItemsCallsPresenterNumberOfMoviesExpectation!], timeout: 2)
    }

    func testConfigurePaginationCallsPresenterNumberOfMovies() throws {
        configurePaginationCallsPresenterNumberOfMoviesExpectation =
        expectation(description: "expect presenter numberOfMovies fullfill this expectation")

        view.configurePagination(0)
        wait(for: [configurePaginationCallsPresenterNumberOfMoviesExpectation!], timeout: 1)
    }

}

extension TestTopRatedMoviesView: TopRatedMoviesPresenterViewInterface {

    func configureContextMenu(index: Int, imageData: Data) -> UIContextMenuConfiguration {
        UIContextMenuConfiguration()
    }

    var movieImagesCache: NSCache<NSNumber, UIImage> {
        NSCache<NSNumber, UIImage>()
    }

    func viewDidLoad() {

    }

    func alertRetryButtonDidTap() {

    }

    func getMovieImage(index: Int, completion: @escaping (UIImage) -> Void) {

    }

    func getMovieTitle(index: Int) -> String {
        DispatchQueue.main.async {
            self.configureContextMenuCallsPresenterGetMovieTitleExpectation?.fulfill()
        }
        return ""
    }

    func movieSelected(at index: Int) {
        DispatchQueue.main.async {
            self.collectionViewDidSelectRowATCallsPresenterMovieSelectedExpectation?.fulfill()
        }
    }

    func addToWatchList(index: Int, imageData: Data) {

    }

    func getTopRatedMovies() {

    }

    func getSavedMovies() -> [CoreDataMovie] {
        DispatchQueue.main.async {
            self.configureContextMenuCallsPresenterGetSavedMoviesExpectation?.fulfill()
        }
        return [CoreDataMovie(title: "", poster: Data(), id: 0, date: Date(), voteAverage: 0.0)]
    }

    var topRatedMovies: [Movie] {
        return [Movie(title: "", poster: nil, id: 1, voteAverage: 1.0)]
    }

    var numberOfMovies: Int {
        DispatchQueue.main.async {
            self.collectionViewNumberOfItemsCallsPresenterNumberOfMoviesExpectation?.fulfill()
            self.configurePaginationCallsPresenterNumberOfMoviesExpectation?.fulfill()
        }
        return 1
    }

}
