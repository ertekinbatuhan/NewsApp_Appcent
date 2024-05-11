//
//  News_AppUITests.swift
//  News_AppUITests
//
//  Created by Batuhan Berk Ertekin on 8.05.2024.
//

import XCTest

final class News_AppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSearchBar() throws {
        
        let app = XCUIApplication()
        app.launch()
        XCUIApplication().searchFields["Search"].tap()
        
    }
   
    func testTabBar()  throws{
        
        let app = XCUIApplication()
        app.launch()
        let tabBar = XCUIApplication().tabBars["Tab Bar"]
        tabBar.buttons["Favorites"].tap()
        tabBar.buttons["News"].tap()
    }
    
    
    func testToDetailsViewController() throws {
        
        let app = XCUIApplication()
        app.launch()
        let favoriteButton =  app.tabBars["Tab Bar"].buttons["Favorites"]
        favoriteButton.tap()
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"When notifications remind us of things we’d rather forget")/*[[".cells.containing(.staticText, identifier:\"Transferring photos from the cloud to an external drive is one way to fix that problem.\")",".cells.containing(.staticText, identifier:\"When notifications remind us of things we’d rather forget\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0).tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["News Source"]/*[[".buttons[\"News Source\"].staticTexts[\"News Source\"]",".staticTexts[\"News Source\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["News Source"].buttons["Back"].tap()
    }
    

    func testSourceButton() throws {
        
        let app = XCUIApplication()
        app.launch()
        app.tabBars["Tab Bar"].buttons["Favorites"].tap()
        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Plant-Based Meat Boomed. Here Comes the Bust")/*[[".cells.containing(.staticText, identifier:\"Sales of vegan meat are trending downwards in the US, with companies scrambling to win back customers.\")",".cells.containing(.staticText, identifier:\"Plant-Based Meat Boomed. Here Comes the Bust\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0).tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["News Source"]/*[[".buttons[\"News Source\"].staticTexts[\"News Source\"]",".staticTexts[\"News Source\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    
    func testShareButton() throws {
        
        let app = XCUIApplication()
        app.launch()
        app.tables.firstMatch.tap()
        app.navigationBars["News_App.NewsDetailsView"].buttons["Share"].tap()
        app.collectionViews.cells["Copy"].children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 2).tap()
    }
    
    func testFavoriteButton() throws {
        
        let app = XCUIApplication()
        app.launch()
        app.tabBars["Tab Bar"].buttons["Favorites"].tap()
        app.tables.firstMatch.tap()
        let loveButton = app.navigationBars["News_App.NewsDetailsView"].buttons["love"]
        loveButton.tap()
        loveButton.tap()
    }
    
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
