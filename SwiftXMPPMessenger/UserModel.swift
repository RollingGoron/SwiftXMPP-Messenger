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

struct UserModel {
    var jid : String?
    var nickName : String?
    var userState : UserState
    
}