//
//  File.swift
//  
//
//  Created by Kelton Person on 11/23/19.
//

import Foundation
import Vapor
import CryptoSwift


public struct RequestBodySigningMiddleware: Middleware {
    
    let secretHeaderKey: String
    let signatureHeaderKey: String
    
    public init(secretHeaderKey: String, signatureHeaderKey: String) {
        self.secretHeaderKey = secretHeaderKey
        self.signatureHeaderKey = signatureHeaderKey
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        if let data = request.http.body.data, !data.isEmpty {
            if
                let bodySignature = request.http.headers[signatureHeaderKey].first,
                let secret = request.http.headers[secretHeaderKey].first
            {
                let hmac = try! HMAC(key: secret, variant: .sha256)
                let signedBytes = try! hmac.authenticate(data.bytes)
                let computedSignature = Data(signedBytes).hexDescription
                if computedSignature != bodySignature {
                    throw Abort(.unauthorized)
                }
            }
            else {
                throw Abort(.unauthorized)
            }
            
        }
        return try next.respond(to: request)
        
    }
    
    
}


extension Data {
    
    var hexDescription: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }

}
