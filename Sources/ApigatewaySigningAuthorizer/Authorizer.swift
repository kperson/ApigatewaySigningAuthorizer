//
//  Authorizer.swift
//  AWSLambdaAdapter
//
//  Created by Kelton Person on 10/27/19.
//

import Foundation
import NIO
import SwiftAWS

//sourcery: AutoMockable
public protocol Authorizer {
    
    func fetchSecret(key: String) -> EventLoopFuture<String?>
    func markRequestIdSent(requestId: String) -> EventLoopFuture<Bool>
    
}


extension Dictionary where Key == String, Value == Any {
 
    func parseRequest(pathPrefix: String? = nil) -> SignedRequest? {
        if
            let method = self["httpMethod"] as? String,
            let relativePath = self["path"] as? String
        {
            let path = (pathPrefix ?? "") + relativePath
            let headers: [String : String] = self["headers"] as? [String : String] ?? [:]
            let lowercaseHeaders: [(String, String)] = headers.map { (k, v) in (k.lowercased(), v) }
            let lowercaseHeadersDict = lowercaseHeaders.reduce(into: [:]) { $0[$1.0] = $1.1 }
            let queryParams = self["queryStringParameters"] as? [String : String] ?? [:]
            return SignedRequest(method: method, path: path, headers: lowercaseHeadersDict, queryParams: queryParams, body: nil)
        }
        else {
            return nil
        }
    }
    
    
}

 public extension AWSApp {
    
    
    func addRequestAuthorizer(
        authorizer: Authorizer,
        pathPrefixResolver: @escaping ([String : Any]) -> String? = { _ in nil },
        modifyResponse: ((SignedRequest, [String : Any]) -> EventLoopFuture<[String : Any]>)? = nil
    ) {
        addCustom(name: "com.github.kperson.signing.request") { payload in
            let pathPrefix = pathPrefixResolver(payload.data)
            if  let request = payload.data.parseRequest(pathPrefix: pathPrefix),
                let apiKey = request.headers["x-request-api-key"],
                let methodArn = payload.data["methodArn"] as? String
            {
            
                let f = authorizer.fetchSecret(key: apiKey).map { secretOpt -> String? in
                    if let secret = secretOpt, let requestId = request.verifySignature(secret: secret) {
                        return requestId
                    }
                    return nil
                }.then { requestIdOpt -> EventLoopFuture<Bool> in
                    if let requestId = requestIdOpt {
                        return authorizer.markRequestIdSent(requestId: requestId)
                    }
                    else {
                        return payload.eventLoop.newSucceededFuture(result: false)
                    }
                }.map { isSuccessful in
                    AWSApp.authorizationResponse(isAuthorized: isSuccessful, methodArn: methodArn)
                }
                if let mod = modifyResponse {
                    return f.then { res in
                        return mod(request, res)
                    }
                }
                else {
                    return f
                }
            }
            return payload.eventLoop.newSucceededFuture(result: AWSApp.authorizationResponse(isAuthorized: false, methodArn: "*"))
        }
    }
    
    static func authorizationResponse(isAuthorized: Bool, methodArn: String) -> [String : Any] {
        return [
            "principalId": "user",
            "policyDocument": [
                "Version": "2012-10-17",
                "Statement": [
                    [
                        "Action": "execute-api:Invoke",
                        "Effect": isAuthorized ? "Allow": "Deny",
                        "Resource": methodArn
                    ]
                ]
            ]
        ]
    }
    
}
