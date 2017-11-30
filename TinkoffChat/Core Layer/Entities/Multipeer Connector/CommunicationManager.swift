//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 24.10.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation
/*


protocol ICommunicationManager: class {
    var newChatsUpdate: ((_ chats: [Chat]) -> ())? { get set }
    var newMessagesUpdate: ((_ chats: Chat) -> ())? { get set }
    func sendMessage(string: String, to chat: Chat, completion: ((_ success: Bool, _ error: Error?) -> Void)?)
    weak var delegate: ICommunicationManagerDelegate
    weak var 
}

protocol ICommunicationManagerDelegate: class {
    func chatCreated(chat: Chat)
    func chatChanged(chat: Chat)
    func didLostUser(withID userID: String)
}

class CommunicationManager: ICommunicatorDelegate, ICommunicationManager {
    
//    var dataManager: CoreDataManager
    
    func sendMessage(string: String, to chat: Chat, completion: ((Bool, Error?) -> Void)?) {
        let message = Message(text: string, date: Date(), type: outbox)
        message.makeReaded()
        chat.messages.append(message)
        multiPeerCommunicator.sendMessage(string: string, to: chat.id) { [weak self](success, error) in
            if success {
                self?.newMessagesUpdate?(chat)
                self?.newChatsUpdate?((self?.chats)!)
                completion!(success, nil)
            } else {
                completion!(false, error)
            }
        }
    }
    
    weak var delegate: ChatsListDelegate?
    
    private var multiPeerCommunicator = MultipeerCommunicator()
    var chats = [Chat]()
    
    init(/*dataManager: CoreDataManager*/) {
//        self.dataManager = dataManager
        multiPeerCommunicator.delegate = self
    }
    
    func getChatFor(_ id: String) -> Chat? {
        for chat in chats {
            if chat.id == id { return chat }
        }
        return nil
    }
    
    func getChats(online: Bool) -> [Chat] {
        return chats.filter { $0.isOnline == online }
    }
    
    func communicationServices(enabled: Bool) {
        multiPeerCommunicator.online = enabled
    }
    
//    func didFindUser(userID: String, userName: String?) {
////        dataManager.appendChat(with userID: UserID, userName: UserName)
//
//        CoreDataManager.appendChat(with: userID, userName: userName)
//
////        print("*** didFindUser userName \(userName ?? "No Name User") userID \(userID) ")
////        if let chat = getChatFor(userID) {
////
////            chat.isOnline = true
////        } else {
////            let chat = Chat(id: userID, name: userName, isOnline: true)
////            chats.append(chat)
////            print("*** didFindUser chats.first.name \(chats.first?.name ?? "Nothing")")
////        }
////        print("*** \n\n newChatsUpdate\n")
////        newChatsUpdate?(chats)
//    }
    
//    func didLoseUser(userID: String) {
//        CoreDataManager.deleteChat(with: userID)
////        if let chat = getChatFor(userID) {
////            chat.isOnline = false
////        }
////        print("*** \n\n newChatsUpdate\n")
////        newChatsUpdate?(chats)
//    }
    
//    func failedToStartBrowsingForUsers(error: Error) {
//        print("*** \n\n failedToStartBrowsingForUsers\n")
//    }
//
//    func failedToStartAdvertising(error: Error) {
//        print("*** \n\n failedToStartAdvertising\n")
//    }
    
//    func didReceiveMessage(text: String, fromUser userID: String, toUser receiver: String) {
//        CoreDataManager.saveMessage(with: text, with: userID, type: inbox)
////        if let chat = getChatFor(fromUser) {
////            let message = Message(text: text, date: Date(), type: inbox)
////            chat.messages.append(message)
////            print("*** \n\n newChatsUpdate\n")
////            print("*** \n\n newMessagesUpdate\n")
////            newMessagesUpdate?(chat)
////            newChatsUpdate?(chats)
////        }
//    }
}
*/
