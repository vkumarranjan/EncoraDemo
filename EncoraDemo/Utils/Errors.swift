//
//  Errors.swift
//  EncoraDemo
//
//  Created by Vinay Nation on 23/02/21.
//

import Foundation

typealias Closure = () -> Void
typealias ClosureWithError = ( _ error: iTunesErrors ) -> Void
typealias ClosureWithBool = ( _ success: Bool ) -> Void
typealias ClosureWithiTunes = ( _ items: [iTunesItem] ) -> Void
typealias ClosureWithString = ( _ xml: String ) -> Void


enum iTunesErrors: Error {
    case unknown
    case success
    case notFound
    case timedOut
    case connectionError(value: Int)
    case serverUnavailable
    case noData
    case invalidRequest
    case invalidCredentials
    
    static func netError( _ errorCode: Int32 ) -> iTunesErrors {
        
        switch errorCode {
        case 200:
            return .success
        case 400:
            return .invalidRequest
        case 401:
            return .invalidCredentials
        case 404:
            return .notFound
        default:
            return .unknown
        }
    }
    
    static func errorNo( _ errorCode: Int32 ) -> iTunesErrors {
        switch errorCode {
        case 0:  return unknown
        default: return unknown
        }
    }
    
}
