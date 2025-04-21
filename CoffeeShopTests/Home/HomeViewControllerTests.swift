//
//  HomeViewControllerTests.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//


import XCTest
@testable import CoffeeShop

final class HomeViewControllerTests: XCTestCase {

    var viewModel: MockHomeViewModel!
    var sut: HomeViewController!

    override func setUp() {
        super.setUp()
        viewModel = MockHomeViewModel()
        sut = HomeViewController(viewModel: viewModel)
    }

    override func tearDown() {
        viewModel = nil
        sut = nil
        super.tearDown()
    }

    func test_viewDidLoad_showsLoadingAndFetchesData() {
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()

        XCTAssertTrue(viewModel.fetchCampaignsCalled)
        XCTAssertTrue(viewModel.fetchCategoriesCalled)
        XCTAssertTrue(viewModel.fetchFavoritesCalled)
    }

    func test_scrollViewIsHiddenInitially() {
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.scrollView.isHidden)
    }

    func test_favoriteViewGetsAdded_whenUserLoggedIn() {
        viewModel.isUserLoggedIn = true
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.view.subviews.contains(where: { $0 is UIScrollView }))
    }
}
