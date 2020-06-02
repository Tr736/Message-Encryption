//
//  Constants.swift
//  GettingStarted
//
//  Created by Paul Ardeleanu on 19/11/2019.
//  Copyright © 2019 Nexmo. All rights reserved.
//

import Foundation


enum User: String {
    case apurva = "Apurva"
    case tom = "Tom"
    
    var uuid: String {
        switch self {
        case .apurva:
            return "" //TODO: swap with apurva's user uuid
        case .tom:
            return "" //TODO: swap with tom's user uuid
        }
    }
    
    var jwt: String {
        switch self {
        case .apurva:
            return "" //TODO: swap with a token for apurva
        case .tom:
            return "" //TODO: swap with a token for tom
        }
    }
    
    static let conversationId = "" //TODO: swap with a conversation id
    
    var interlocutor: User {
        switch self {
        case .apurva:
            return User.tom
        case .tom:
            return User.apurva
        }
    }
}
