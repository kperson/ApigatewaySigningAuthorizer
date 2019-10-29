// Generated using Sourcery 0.16.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT



// Generated with SwiftyMocky 3.3.4

import SwiftyMocky
#if !MockyCustom
import XCTest
#endif
import Foundation
import NIO
@testable import ApigatewaySigningAuthorizer


// MARK: - Authorizer
open class AuthorizerMock: Authorizer, Mock {
    init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }





    open func fetchSecret(key: String) -> EventLoopFuture<String?> {
        addInvocation(.m_fetchSecret__key_key(Parameter<String>.value(`key`)))
		let perform = methodPerformValue(.m_fetchSecret__key_key(Parameter<String>.value(`key`))) as? (String) -> Void
		perform?(`key`)
		var __value: EventLoopFuture<String?>
		do {
		    __value = try methodReturnValue(.m_fetchSecret__key_key(Parameter<String>.value(`key`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for fetchSecret(key: String). Use given")
			Failure("Stub return value not specified for fetchSecret(key: String). Use given")
		}
		return __value
    }

    open func markRequestIdSent(requestId: String) -> EventLoopFuture<Bool> {
        addInvocation(.m_markRequestIdSent__requestId_requestId(Parameter<String>.value(`requestId`)))
		let perform = methodPerformValue(.m_markRequestIdSent__requestId_requestId(Parameter<String>.value(`requestId`))) as? (String) -> Void
		perform?(`requestId`)
		var __value: EventLoopFuture<Bool>
		do {
		    __value = try methodReturnValue(.m_markRequestIdSent__requestId_requestId(Parameter<String>.value(`requestId`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for markRequestIdSent(requestId: String). Use given")
			Failure("Stub return value not specified for markRequestIdSent(requestId: String). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_fetchSecret__key_key(Parameter<String>)
        case m_markRequestIdSent__requestId_requestId(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Bool {
            switch (lhs, rhs) {
            case (.m_fetchSecret__key_key(let lhsKey), .m_fetchSecret__key_key(let rhsKey)):
                guard Parameter.compare(lhs: lhsKey, rhs: rhsKey, with: matcher) else { return false } 
                return true 
            case (.m_markRequestIdSent__requestId_requestId(let lhsRequestid), .m_markRequestIdSent__requestId_requestId(let rhsRequestid)):
                guard Parameter.compare(lhs: lhsRequestid, rhs: rhsRequestid, with: matcher) else { return false } 
                return true 
            default: return false
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_fetchSecret__key_key(p0): return p0.intValue
            case let .m_markRequestIdSent__requestId_requestId(p0): return p0.intValue
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func fetchSecret(key: Parameter<String>, willReturn: EventLoopFuture<String?>...) -> MethodStub {
            return Given(method: .m_fetchSecret__key_key(`key`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func markRequestIdSent(requestId: Parameter<String>, willReturn: EventLoopFuture<Bool>...) -> MethodStub {
            return Given(method: .m_markRequestIdSent__requestId_requestId(`requestId`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func fetchSecret(key: Parameter<String>, willProduce: (Stubber<EventLoopFuture<String?>>) -> Void) -> MethodStub {
            let willReturn: [EventLoopFuture<String?>] = []
			let given: Given = { return Given(method: .m_fetchSecret__key_key(`key`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (EventLoopFuture<String?>).self)
			willProduce(stubber)
			return given
        }
        public static func markRequestIdSent(requestId: Parameter<String>, willProduce: (Stubber<EventLoopFuture<Bool>>) -> Void) -> MethodStub {
            let willReturn: [EventLoopFuture<Bool>] = []
			let given: Given = { return Given(method: .m_markRequestIdSent__requestId_requestId(`requestId`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (EventLoopFuture<Bool>).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func fetchSecret(key: Parameter<String>) -> Verify { return Verify(method: .m_fetchSecret__key_key(`key`))}
        public static func markRequestIdSent(requestId: Parameter<String>) -> Verify { return Verify(method: .m_markRequestIdSent__requestId_requestId(`requestId`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func fetchSecret(key: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_fetchSecret__key_key(`key`), performs: perform)
        }
        public static func markRequestIdSent(requestId: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_markRequestIdSent__requestId_requestId(`requestId`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let invocations = matchingCalls(method.method)
        MockyAssert(count.matches(invocations.count), "Expected: \(count) invocations of `\(method.method)`, but was: \(invocations.count)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        invocations.append(call)
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher) }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType) -> [MethodType] {
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher) }
    }
    private func matchingCalls(_ method: Verify) -> Int {
        return matchingCalls(method.method).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        #if Mocky
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleMissingStubError(message: message, file: file, line: line)
        #endif
    }
}

