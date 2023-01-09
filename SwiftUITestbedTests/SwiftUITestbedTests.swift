//
//  SwiftUITestbedTests.swift
//  SwiftUITestbedTests
//
//  Created by Mariano Donati on 04/01/2023.
//

import XCTest
import CustomDump
@testable import SwiftUITestbed

final class SwiftUITestbedTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let store = CounterStore(initialState: .init(count: 0))

        store.assert(store.incr()) {
            $0.count = 1
        }
    }
}

extension Store {
    func assert(
        _ execute: @autoclosure () -> Void,
        update updateStateToExpectedResult: ((inout State) -> Void)? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        var testState = state
        execute()
        updateStateToExpectedResult?(&testState)

        if testState != state {
            let difference = diff(testState, state, format: .proportional)
              .map { "\($0.indent(by: 4))\n\n(Expected: −, Actual: +)" }
              ?? """
              Expected:
              \(String(describing: testState).indent(by: 2))

              Actual:
              \(String(describing: state).indent(by: 2))
              """
            let messageHeading =
              updateStateToExpectedResult != nil
              ? "A state change does not match expectation"
              : "State was not expected to change, but a change occurred"

            XCTFail(
              """
              \(messageHeading): …

              \(difference)
              """,
              file: file,
              line: line
            )
        } else {
            XCTAssertEqual(testState, state, file: file, line: line)
        }
    }
}

extension String {
  func indent(by indent: Int) -> String {
    let indentation = String(repeating: " ", count: indent)
    return indentation + self.replacingOccurrences(of: "\n", with: "\n\(indentation)")
  }
}
