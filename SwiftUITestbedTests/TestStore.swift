import CustomDump
import XCTest
@testable import SwiftUITestbed

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

fileprivate extension String {
  func indent(by indent: Int) -> String {
    let indentation = String(repeating: " ", count: indent)
    return indentation + self.replacingOccurrences(of: "\n", with: "\n\(indentation)")
  }
}
