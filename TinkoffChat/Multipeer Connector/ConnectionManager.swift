//
//  ConnectionManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 24.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

protocol ConnectionManagerDelegate: class {
    func updateUI()
}

class ConnectionManager {
    weak var delegate: ConnectionManagerDelegate?
    
    let multiPeerConnector: MultipeerConnector
    var chats = [Chat]()
    
    init(connector: MultipeerConnector) {
        self.multiPeerConnector = connector
        multiPeerConnector.delegate = self
    }
    
    func getChatFor(_ userID: String) -> Chat? {
        for chat in chats {
            if chat.id == userID { return chat }
        }
        return nil
    }
    
    func getChats(online: Bool) -> [Chat] {
        return chats.filter { $0.isOnline == online }
    }
    
    func communicationServices(enabled: Bool) {
        multiPeerConnector.online = enabled
    }
    
    func sendMessage(text: String, to chat: Chat) {
        let message = Message(text: text, date: Date(), type: .outbox)
        message.makeReaded()
        chat.messages.append(message)
        multiPeerConnector.sendMessage(string: text, to: chat.id, completionHandler: nil)
        delegate?.updateUI()
    }
}

extension ConnectionManager: ConnectorDelegate {
    func didFindUser(userID: String, userName: String?) {
        if let chat = getChatFor(userID) {
            chat.isOnline = true
            
        } else {
            let chat = Chat(id: userID, name: userName, isOnline: true)
            chats.append(chat)
        }
        
    }
    
    func didLoseUser(userID: String) {
        if let chat = getChatFor(userID) {
            chat.isOnline = false
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if let chat = getChatFor(fromUser) {
            let message = Message(text: text, date: Date(), type: .inbox)
            chat.messages.append(message)
            delegate?.updateUI()
        }
    }
    
    
}