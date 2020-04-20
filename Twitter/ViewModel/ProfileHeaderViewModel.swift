//
//  ProfileHeaderViewModel.swift
//  Twitter
//
//  Created by Dong Wei on 4/9/20.
//  Copyright © 2020 Dong Wei. All rights reserved.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String{
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    let usernameText: String
    
    var followersString: NSAttributedString?{
        return attributtedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    var followingString: NSAttributedString?{
        return attributtedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var actionButtonTitle: String {
        //if user if current user, set to edit profile
        //else fugoure out following/unfollow
        if user.isCurrentUser {
            return "Edit File"
        }else if !user.isFollowed{
            return "Follow"
            
        }else{
            return "Following"
        }
    }
    
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.username
    }
    
    fileprivate func attributtedText(withValue value: Int, text: String)-> NSAttributedString {
        let attributtedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributtedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributtedTitle
    }
}
