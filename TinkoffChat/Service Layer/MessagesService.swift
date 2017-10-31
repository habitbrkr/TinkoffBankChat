//
//  MessagesService.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 31.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol IMessagesService {
    func newMessagesFetch(completionHandler: @escaping ((Chat) -> Void))
}

class MessagesService: IMessagesService {
    
    var connectionManager: ConnectionManagerProtocol
    
    init(connectionManager: ConnectionManagerProtocol) {
        self.connectionManager = connectionManager
    }
    
    func newMessagesFetch(completionHandler: @escaping ((Chat) -> Void)) {
        connectionManager.newMessagesUpdate = {
            (chat: Chat) in
            completionHandler(chat)
        }
    }
    
    func sendMessage(string: String, to chat: Chat, completionHandler: ((Bool, Error?) -> Void)?) {
        connectionManager.sendMessage(string: string, to: chat, completionHandler: completionHandler)//) { (success, error) in
//            if success {
//                completionHandler!(true, nil)
//            } else {
//                completionHandler!(false, error)
//            }
    }
}
