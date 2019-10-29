//
//  AuthorizerTests.swift
//  AWSLambdaAdapter
//
//  Created by Kelton Person on 10/27/19.
//

import Foundation
import XCTest
import NIO
import SwiftAWS
@testable import ApigatewaySigningAuthorizer

class AuthorizerTests: XCTestCase {
    
    static let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

    let reqDict: [String : Any] = [
        "httpMethod": "GET",
        "headers": ["k1": "v1"],
        "queryStringParameters": ["q2": "v2"],
        "path": "/hello-world"
    ]
    
    let req = SignedRequest(
        method: "GET",
        path: "/hello-world",
        headers: ["k1": "v1"],
        queryParams: ["q2": "v2"],
        body: nil
    )
    
    func testParseRequest() {
        XCTAssertEqual(reqDict.parseRequest(), req)
    }
    
    func testAddRequestAuthorizer() {
        let signed = req.prepareRequest(key: "k1", secret: "secret")
        let m = AuthorizerMock()
        m.given(.fetchSecret(key: .value("k1"), willReturn: AuthorizerTests.eventLoopGroup.future("secret")))
        m.given(.markRequestIdSent(requestId: ._, willReturn: AuthorizerTests.eventLoopGroup.future(true)))
        let awsApp = AWSApp()
        awsApp.addRequestAuthorizer(authorizer: m)
        let rs = try! awsApp.testCustomCall(name: "com.github.kperson.signing.request", payload: [
            "httpMethod": "GET",
            "headers": signed.headers,
            "queryStringParameters": ["q2": "v2"],
            "path": "/hello-world",
            "methodArn": "TEST_ARN"
        ]).wait()
        let expected: [String : Any] = [
            "principalId": "user",
            "policyDocument": [
                "Version": "2012-10-17",
                "Statement": [
                    [
                        "Action": "execute-api:Invoke",
                        "Effect": "Allow",
                        "Resource": "TEST_ARN"
                    ]
                ]
            ]
        ]
        XCTAssert(NSDictionary(dictionary: expected).isEqual(to: rs))
    }
    
    func testAddRequestAuthorizerFailedKey() {
        let signed = req.prepareRequest(key: "k1", secret: "secret")
        let m = AuthorizerMock()
        m.given(.fetchSecret(key: .value("k1"), willReturn: AuthorizerTests.eventLoopGroup.future(nil)))
        m.given(.markRequestIdSent(requestId: ._, willReturn: AuthorizerTests.eventLoopGroup.future(true)))
        let awsApp = AWSApp()
        awsApp.addRequestAuthorizer(authorizer: m)
        let rs = try! awsApp.testCustomCall(name: "com.github.kperson.signing.request", payload: [
            "httpMethod": "GET",
            "headers": signed.headers,
            "queryStringParameters": ["q2": "v2"],
            "path": "/hello-world",
            "methodArn": "TEST_ARN"
        ]).wait()
        let expected: [String : Any] = [
            "principalId": "user",
            "policyDocument": [
                "Version": "2012-10-17",
                "Statement": [
                    [
                        "Action": "execute-api:Invoke",
                        "Effect": "Deny",
                        "Resource": "TEST_ARN"
                    ]
                ]
            ]
        ]
        XCTAssert(NSDictionary(dictionary: expected).isEqual(to: rs))
    }
    
    func testAddRequestAuthorizerRequestExist() {
        let signed = req.prepareRequest(key: "k1", secret: "secret")
        let m = AuthorizerMock()
        m.given(.fetchSecret(key: .value("k1"), willReturn: AuthorizerTests.eventLoopGroup.future("secret")))
        m.given(.markRequestIdSent(requestId: ._, willReturn: AuthorizerTests.eventLoopGroup.future(false)))
        let awsApp = AWSApp()
        awsApp.addRequestAuthorizer(authorizer: m)
        let rs = try! awsApp.testCustomCall(name: "com.github.kperson.signing.request", payload: [
            "httpMethod": "GET",
            "headers": signed.headers,
            "queryStringParameters": ["q2": "v2"],
            "path": "/hello-world",
            "methodArn": "TEST_ARN"
        ]).wait()
        let expected: [String : Any] = [
            "principalId": "user",
            "policyDocument": [
                "Version": "2012-10-17",
                "Statement": [
                    [
                        "Action": "execute-api:Invoke",
                        "Effect": "Deny",
                        "Resource": "TEST_ARN"
                    ]
                ]
            ]
        ]
        XCTAssert(NSDictionary(dictionary: expected).isEqual(to: rs))
    }
    
    func testAddRequestAuthorizerRequestInvalidSecret() {
        let signed = req.prepareRequest(key: "k1", secret: "secret_bad")
        let m = AuthorizerMock()
        m.given(.fetchSecret(key: .value("k1"), willReturn: AuthorizerTests.eventLoopGroup.future("secret")))
        m.given(.markRequestIdSent(requestId: ._, willReturn: AuthorizerTests.eventLoopGroup.future(true)))
        let awsApp = AWSApp()
        awsApp.addRequestAuthorizer(authorizer: m)
        let rs = try! awsApp.testCustomCall(name: "com.github.kperson.signing.request", payload: [
            "httpMethod": "GET",
            "headers": signed.headers,
            "queryStringParameters": ["q2": "v2"],
            "path": "/hello-world",
            "methodArn": "TEST_ARN"
        ]).wait()
        let expected: [String : Any] = [
            "principalId": "user",
            "policyDocument": [
                "Version": "2012-10-17",
                "Statement": [
                    [
                        "Action": "execute-api:Invoke",
                        "Effect": "Deny",
                        "Resource": "TEST_ARN"
                    ]
                ]
            ]
        ]
        XCTAssert(NSDictionary(dictionary: expected).isEqual(to: rs))

    }
    
    func testAuthorizationResponse() {
        for b in [(true, "Allow"), (false, "Deny")] {
            let (isAllowed, key) = b
            let rs = AWSApp.authorizationResponse(isAuthorized: isAllowed, methodArn: "TEST_ARN")
            let expected: [String : Any] = [
                "principalId": "user",
                "policyDocument": [
                    "Version": "2012-10-17",
                    "Statement": [
                        [
                            "Action": "execute-api:Invoke",
                            "Effect": key,
                            "Resource": "TEST_ARN"
                        ]
                    ]
                ]
            ]
            XCTAssert(NSDictionary(dictionary: expected).isEqual(to: rs))
        }
    }
    
}
