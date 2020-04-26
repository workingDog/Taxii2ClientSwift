import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Taxii2ClientTests.allTests),
    ]
}
#endif
