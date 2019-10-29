//
//  SignedRequest.swift
//  AWSLambdaAdapter
//
//  Created by Kelton Person on 10/27/19.
//

import Foundation
import CryptoSwift


public struct SignedRequest: Equatable {
    
    public let method: String
    public let path: String
    public let headers: [String : String]
    public let queryParams: [String : String]?
    public let body: Data?
    
}


public extension SignedRequest {
    
    var signingData: (String, [String]) {
        let qParams = queryParams ?? [:]
        let sortedQueryParams = qParams.keys.sorted()
        let lowercaseHeaders = headers.map { (k, v) in (k.lowercased(), v) }
        let lowercaseHeadersDict = Dictionary(uniqueKeysWithValues: lowercaseHeaders)
        let sortedHeadersKeys = lowercaseHeadersDict.keys.sorted()
        let sortedHeadersKVString = sortedHeadersKeys.map { k in "\(k)=\(lowercaseHeadersDict[k]!)" }.joined(separator: "&")
        let queryParamsKVString = sortedQueryParams.map { k in "\(k)=\(qParams[k]!)" }.joined(separator: "&")

        let signingStr = method + "\n" +
        path + "\n" +
        sortedHeadersKVString + "\n" +
        queryParamsKVString
        return (signingStr, sortedHeadersKeys)
    }
    
    func sign(secret: String) -> (String, [String]) {
        let (stringToSign, headers) = signingData
        let hmac = try! HMAC(key: secret, variant: .sha256)
        let signedBytes = try! hmac.authenticate(stringToSign.bytes)
        return (Data(signedBytes).hexDescription, headers)
    }
    
    func prepareRequest(
        key: String,
        secret: String,
        requestTime: TimeInterval? = nil,
        requestId: String? = nil
    ) -> SignedRequest {
        var allHeaders = headers
        allHeaders["x-request-time"] = String(Int(requestTime ?? Date().timeIntervalSince1970))
        allHeaders["x-request-id"] = requestId ?? UUID().uuidString
        allHeaders["x-request-signature-version"] = "1"
        allHeaders["x-request-api-key"] = key
       
        let newRequest = SignedRequest(
            method: method,
            path: path,
            headers: allHeaders,
            queryParams: queryParams,
            body: body
        )
        
        let (signature, headers) = newRequest.sign(secret: secret)
        
        allHeaders["x-request-signature"] = signature
        allHeaders["x-request-headers-to-sign"] = headers.joined(separator: ",")
        return SignedRequest(
            method: method,
            path: path,
            headers: allHeaders,
            queryParams: queryParams,
            body: body
        )
    }
    
    func verifySignature(secret: String) -> String? {
        let requiredHeadersToSign = [
            "x-request-time",
            "x-request-id",
            "x-request-api-key",
            "x-request-signature-version"
        ]
        let requiredHeaders = requiredHeadersToSign + [
            "x-request-headers-to-sign",
            "x-request-signature"
        ]
        
        let lowercaseHeaders = headers.map { (k, v) in (k.lowercased(), v) }
        let lowercaseHeadersDict = Dictionary(uniqueKeysWithValues: lowercaseHeaders)
        let missingRequiredHeaders = requiredHeaders.map { lowercaseHeadersDict[$0] }.contains(nil)
        
        if missingRequiredHeaders {
            return nil
        }
        let headersToSign = lowercaseHeadersDict["x-request-headers-to-sign"]!.split(separator: ",").map { String($0) }
        
        let headersToSignMissingRequired = requiredHeadersToSign.map { headersToSign.contains($0) }.contains(false)
        if headersToSignMissingRequired {
            return nil
        }
        
        let maxRequestTime: TimeInterval = 60 //1 minute
        if let requestTimeHeader = lowercaseHeadersDict["x-request-time"],
            let requestTimeInterval = TimeInterval(requestTimeHeader) {
            if(abs(requestTimeInterval - Date().timeIntervalSince1970) > maxRequestTime) {
                return nil
            }
        }
        else {
            return nil
        }
    
        let finalHeaders = Dictionary(uniqueKeysWithValues: headersToSign.map { ($0, lowercaseHeadersDict[$0]!) })
        let req = SignedRequest(method: method, path: path, headers: finalHeaders, queryParams: queryParams, body: body)
        
        if  let sentSignature = lowercaseHeadersDict["x-request-signature"],
            let requestId = lowercaseHeadersDict["x-request-id"] {
            let (computedSignature, _) = req.sign(secret: secret)
            if computedSignature == sentSignature {
                return requestId
            }
        }
        return nil
    }
    
}

extension Data {
    
    var hexDescription: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }

}
