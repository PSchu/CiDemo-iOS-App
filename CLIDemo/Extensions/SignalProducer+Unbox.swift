//
//  SignalProducer+Unbox.swift
//  Moya-Unbox
//
//  Created by Ryoga Kitagawa on 9/13/16.
//  Copyright © 2016 Ryoga Kitagawa. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import Moya
import Unbox

public extension SignalProducerProtocol where Value: Moya.Response {
    public func unbox<T: Unboxable>(object: T.Type) -> SignalProducer<T, AnyError> {
        return producer
            .materialize()
            .map { (event: ReactiveSwift.Signal<Value, Error>.Event) -> ReactiveSwift.Signal<T, AnyError>.Event in
                return unwrapThrowable(event: event, { try $0.unbox(object: T.self) })
            }
            .dematerialize()
    }
    
    public func unbox<T: Unboxable>(object: T.Type, atKey: String) -> SignalProducer<T, AnyError> {
        return producer
            .materialize()
            .map { (event: ReactiveSwift.Signal<Value, Error>.Event) -> ReactiveSwift.Signal<T, AnyError>.Event in
                return unwrapThrowable(event: event, { try $0.unbox(object: T.self, atKey: atKey) })
            }
            .dematerialize()
    }
    
    public func unbox<T: Unboxable>(object: T.Type, atKeyPath: String) -> SignalProducer<T, AnyError> {
        return producer
            .materialize()
            .map { (event: ReactiveSwift.Signal<Value, Error>.Event) -> ReactiveSwift.Signal<T, AnyError>.Event in
                return unwrapThrowable(event: event, { try $0.unbox(object: T.self, atKeyPath: atKeyPath) })
            }
            .dematerialize()
    }
    
    public func unbox<T: Unboxable>(array: T.Type) -> SignalProducer<[T], AnyError> {
        return producer
            .materialize()
            .map { (event: ReactiveSwift.Signal<Value, Error>.Event) -> ReactiveSwift.Signal<[T], AnyError>.Event in
                return unwrapThrowable(event: event, { try $0.unbox(array: T.self) })
            }
            .dematerialize()
    }
    
    public func unbox<T: Unboxable>(array: T.Type, atKey: String) -> SignalProducer<[T], AnyError> {
        return producer
            .materialize()
            .map { (event: ReactiveSwift.Signal<Value, Error>.Event) -> ReactiveSwift.Signal<[T], AnyError>.Event in
                return unwrapThrowable(event: event, { try $0.unbox(array: T.self, atKey: atKey) })
            }
            .dematerialize()
    }
    
    public func unbox<T: Unboxable>(array: T.Type, atKeyPath: String) -> SignalProducer<[T], AnyError> {
        return producer
            .materialize()
            .map { (event: ReactiveSwift.Signal<Value, Error>.Event) -> ReactiveSwift.Signal<[T], AnyError>.Event in
                return unwrapThrowable(event: event, { try $0.unbox(array: T.self, atKeyPath: atKeyPath) })
            }
            .dematerialize()
    }
}

private func unwrapThrowable<T, Response: Moya.Response, Error>(event: ReactiveSwift.Signal<Response, Error>.Event,
                                                                _ throwable: (Response) throws -> T) -> ReactiveSwift.Signal<T, AnyError>.Event {
    switch event {
    case .value(let response):
        do {
            return .value(try throwable(response))
        } catch {
            return .failed(AnyError(error))
        }
    case .failed(let error):
        return .failed(AnyError(error))
    case .completed:
        return .completed
    case .interrupted:
        return .interrupted
    }
}

