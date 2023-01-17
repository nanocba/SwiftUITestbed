import CustomDump
import XCTest
import SwiftUI
import Combine
@testable import SwiftUITestbed

extension ObservableViewModel {
    func assert(
        _ execute: @autoclosure () -> Void,
        update updateStateToExpectedResult: ((inout State) -> Void)? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        var testState = state
        updateStateToExpectedResult?(&testState)
        execute()
        checkDiff(testState, expectingMutations: updateStateToExpectedResult != nil, file: file, line: line)
    }

    func assert(
        _ execute: @escaping @autoclosure () async -> Void,
        beforeSuspension updateStateBeforeSuspension: ((inout State) -> Void)? = nil,
        afterSuspension updateStateAfterSuspension: ((inout State) -> Void)? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) async {
        let currentState = state
        var testState = currentState
        updateStateBeforeSuspension?(&testState)
        let task = Task { await execute() }
        while currentState == state {
            await Task.yield()
        }
        checkDiff(testState, expectingMutations: updateStateBeforeSuspension != nil, id: "before suspension", file: file, line: line)

        updateStateAfterSuspension?(&testState)

        await task.value

        checkDiff(testState, expectingMutations: updateStateAfterSuspension != nil, id: "after suspension", file: file, line: line)
    }

    func assertThrowing(
        _ execute: @escaping @autoclosure () async throws -> Void,
        _ assertion: AsyncAssertion<State>,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws -> Void {
        let currentState = state
        var testState = currentState
        assertion.beforeSuspension?(&testState)
        let execution = TaskExecution(task: execute)

        let task = Task {
            try await execution.execute()
        }

        while await !execution.started {
            await Task.yield()
            await Task.yield()
            await Task.yield()
            await Task.yield()
        }

        checkDiff(testState, expectingMutations: assertion.beforeSuspension != nil, id: "before suspension", file: file, line: line)

        assertion.afterSuspension?(&testState)

        try await task.value

        checkDiff(testState, expectingMutations: assertion.afterSuspension != nil, id: "after suspension", file: file, line: line)
    }

    func assertThrowing<Output>(
        _ execute: @escaping @autoclosure () async throws -> Output,
        beforeSuspension updateStateBeforeSuspension: ((inout State) -> Void)? = nil,
        afterSuspension updateStateAfterSuspension: ((inout State) -> Void)? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws -> Output {
        let currentState = state
        var testState = currentState
        updateStateBeforeSuspension?(&testState)
        let task = Task { try await execute() }
        while currentState == state {
            await Task.yield()
        }
        checkDiff(testState, expectingMutations: updateStateBeforeSuspension != nil, id: "before suspension", file: file, line: line)

        updateStateAfterSuspension?(&testState)

        let value = try await task.value

        checkDiff(testState, expectingMutations: updateStateAfterSuspension != nil, id: "after suspension", file: file, line: line)

        return value
    }

    private func checkDiff(_ testState: State, expectingMutations: Bool, id: String? = nil, file: StaticString = #file, line: UInt = #line) {
        if testState != state {
            let current = state
            let difference = diff(testState, current, format: .proportional)
              .map { "\($0.indent(by: 4))\n\n(Expected: −, Actual: +)" }
              ?? """
              Expected:
              \(String(describing: testState).indent(by: 2))

              Actual:
              \(String(describing: current).indent(by: 2))
              """
            var messageHeading =
              expectingMutations
              ? "A state change does not match expectation"
              : "State was not expected to change, but a change occurred"

            messageHeading = id.map { "\(messageHeading) in \($0)" } ?? messageHeading

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

typealias UpdateStateClosure<State> = ((inout State) -> Void)

enum AsyncAssertion<State: Equatable> {
    case beforeSuspension(UpdateStateClosure<State>)
    case afterSuspension(UpdateStateClosure<State>)
    case before(UpdateStateClosure<State>, after: UpdateStateClosure<State>)

    var beforeSuspension: UpdateStateClosure<State>? {
        switch self {
        case .beforeSuspension(let c), .before(let c, after: _):
            return c
        case .afterSuspension:
            return nil
        }
    }

    var afterSuspension: UpdateStateClosure<State>? {
        switch self {
        case .beforeSuspension:
            return nil
        case .afterSuspension(let c), .before(_, let c):
            return c
        }
    }
}

actor TaskExecution {
    var started: Bool = false
    let task: () async throws -> Void

    init(task: @escaping () async throws -> Void) {
        self.task = task
    }

    func execute() async throws -> Void {
        started = true
        try await task()
    }
}

fileprivate extension String {
  func indent(by indent: Int) -> String {
    let indentation = String(repeating: " ", count: indent)
    return indentation + self.replacingOccurrences(of: "\n", with: "\n\(indentation)")
  }
}

enum AsyncError: Error {
    case finishedWithoutValue
}

extension AnyPublisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            var finishedWithoutValue = true
            cancellable = first().sink { result in
                switch result {
                case .finished:
                    if finishedWithoutValue {
                        continuation.resume(throwing: AsyncError.finishedWithoutValue)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
                cancellable?.cancel()
            } receiveValue: { value in
                finishedWithoutValue = false
                continuation.resume(with: .success(value))
            }
        }
    }
}

