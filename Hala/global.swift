//
//  global.swift
//  Hala
//
//  Created by Marina Sauca on 08/10/2016.
//  Copyright © 2016 Mariwi Tech. All rights reserved.
//

class Global {
    public let global = Global(componentID: "componentID", chatID: "chatId")
    var componentID:String
    var chatID:String
    private init(componentID:String, chatID:String) {
        self.componentID = componentID
        self.chatID = chatID
    }
}
//var global = Global(componentID: "componentID",chatID: "chatID")
