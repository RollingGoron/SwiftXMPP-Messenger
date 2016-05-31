//
//  UserModel.swift
//  SwiftXMPPMessenger
//
//  Created by Peter Gosling on 5/21/16.
//  Copyright © 2016 SunfireSoft. All rights reserved.
//

import Foundation

enum UserState {
    case Available
    case Unavailable
    case Away
}

class UserModel : NSObject  {
    let jid : String?
    let nickName : String?
    var userState : UserState?
    var chatHistory = [MessageModel]()
    
    init(userJID : String?, userNickName : String?) {
        jid = userJID
        nickName = userNickName
    }
}

