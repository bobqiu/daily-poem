import XCTest

class DailyPoemUITests: XCTestCase {
  override func setUp() {
    super.setUp()

    let app = XCUIApplication()
    setupSnapshot(app)
    app.launch()

  
    sleep(1)
    
    next(app)
    snapshot("01Poem")
    next(app)
    snapshot("02Sidebar")
    next(app)
    snapshot("03Favorites")
   

    continueAfterFailure = false
    XCUIApplication().launch()
}

  override func tearDown() {
    super.tearDown()
  }
  
  func testExample() {
  }
  
  func next(app: XCUIApplication) {
    app.coordinateWithNormalizedOffset(CGVector(dx: 0, dy: 0)).coordinateWithOffset(CGVector(dx: 200, dy: 40)).tap()
    usleep(1 * 1000)
  }
}
