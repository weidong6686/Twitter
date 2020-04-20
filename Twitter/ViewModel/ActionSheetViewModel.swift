//
//  ActionSheetViewModel.swift
//  Twitter
//
//  Created by Dong Wei on 4/12/20.
//  Copyright © 2020 Dong Wei. All rights reserved.
//

import Foundation


struct ActionSheetViewModel {
    private let user: User
   
    var options:[ActionSheetOptions]{
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            results.append(.delete)
        }else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        results.append(.report)
//        results.append(.blockUser)
        return results
    }
    
    init(user: User) {
        self.user = user
    }
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
//    case blockUser
    
    var decription:String{
        switch self {
        case .follow(let user):
            return "Follow @\(user.username)"
        case .unfollow(let user):
            return "Unfollow @\(user.username)"
        case .report:
            return "Report Tweet"
        case .delete:
            return "Delete Tweet"
//        case .blockUser:
//            return "Block User"
        }
    }
}
