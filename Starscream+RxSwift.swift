//
//  Starscream+RxSwift.swift
//
//  Created by Marin Bencevic on 28/01/16.

import Foundation
import Socket_IO_Client_Swift
import RxSwift

enum SocketEvent {
    case Connected
    case Message(String)
    case Data(NSData)
}

extension WebSocket {
    func rx_text()-> Observable<String> {
        return Observable.create { [weak self] observer in
            self?.onText = { text in observer.on(.Next(text)) }
            self?.onDisconnect = { error in
                if let error = error {
                    observer.on(.Error(error))
                } else {
                    let error = NSError(domain: "Unknown error", code: 0, userInfo: nil)
                    observer.on(.Error(error))
                }
            }
            
            return AnonymousDisposable {
                self?.disconnect()
            }
        }
    }
    
    func rx_data()-> Observable<NSData> {
        return Observable.create { [weak self] observer in
            self?.onData = { data in observer.on(.Next(data)) }
            self?.onDisconnect = { error in
                if let error = error {
                    observer.on(.Error(error))
                } else {
                    let error = NSError(domain: "Unknown error", code: 0, userInfo: nil)
                    observer.on(.Error(error))
                }
            }
            
            return AnonymousDisposable {
                self?.disconnect()
            }
        }
    }
    
    func rx_response()-> Observable<SocketEvent> {
        return Observable.create { [weak self] observer in
            self?.onConnect = { observer.on(.Next(.Connected)) }
            self?.onText = { text in observer.on(.Next(.Message(text))) }
            self?.onData = { data in observer.on(.Next(.Data(data))) }
            self?.onDisconnect = { error in
                if let error = error {
                    observer.on(.Error(error))
                } else {
                    let error = NSError(domain: "Unknown error", code: 0, userInfo: nil)
                    observer.on(.Error(error))
                }
            }
            
            return AnonymousDisposable {
                self?.disconnect()
            }
        }
    }
}
