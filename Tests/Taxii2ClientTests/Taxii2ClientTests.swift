import XCTest
@testable import Taxii2Client

final class Taxii2ClientTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Taxii2Client().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
