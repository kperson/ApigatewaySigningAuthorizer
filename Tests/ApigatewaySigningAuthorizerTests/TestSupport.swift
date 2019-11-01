import Foundation
import XCTest
import NIO
import Vapor
import SwiftAWS

extension XCTestCase {
    
    func check<T>(
        _ future: EventLoopFuture<T>,
        _ description: String,
        _ duration: TimeInterval,
        _ f: (T) -> Void
    ) {
        var fValue: T?
        var fError: Error?
        let delayExpectation = expectation(description: description)
        future.whenSuccess { val in
            fValue = val
            DispatchQueue.main.sync {
                delayExpectation.fulfill()
            }
        }
        future.whenFailure { error in
            fError = error
            DispatchQueue.main.sync {
                delayExpectation.fulfill()
            }
        }

        wait(for: [delayExpectation], timeout: duration)
        if let v = fValue {
            f(v)
        }
        else if let e = fError {
            XCTFail(e.localizedDescription)
        }
        else {
            XCTFail("unknown failure")
        }

    }
    
}

extension AWSApp {
    
    static var testRouter: Router {
        return EngineRouter.default()
    }
    
}


extension Router {
        
    func testRequest(group: EventLoopGroup, httpRequest: HTTPRequest) -> EventLoopFuture<Response> {
        do {
            let application = try Application()
            let request = Request(
                http: httpRequest,
                using: application
            )
            guard let responder = route(request: request) else {
                let rs: EventLoopFuture<Response> = group.future(
                    Response(http:
                        .init(
                            status: .notFound,
                            version: .init(major: 1, minor: 1),
                            headers:
                            .init(),
                            body: ""
                        ),
                        using: application
                    )
                )
                return rs
            }
            let rs = try responder.respond(to: request)
            return rs
        }
        catch let error {
            return  group.future(error: error)
        }
    }
}

extension Response {
    
    func decode<T: Decodable>(_ type: T.Type, decoder: JSONDecoder = JSONDecoder()) -> T? {
        if let data = http.body.data {
            do {
                let value = try decoder.decode(type, from: data)
                return value
            }
            catch _ {
                return nil
            }
        }
        return nil
    }
    
}
