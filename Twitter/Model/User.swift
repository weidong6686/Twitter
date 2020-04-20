//
//  User.swift
//  Twitter
//
//  Created by Dong Wei on 4/4/20.
//  Copyright © 2020 Dong Wei. All rights reserved.
//

import Firebase


struct User {
    var fullname:String
    let email:String
    var username:String
    var profileImageUrl:URL?
    let uid:String
    var isFollowed = false
    var stats: UserRelationStats?
    var bio: String?
    
    var isCurrentUser: Bool{ return Auth.auth().currentUser?.uid == uid}
    
    init(uid:String, dictionary:[String:AnyObject]) {
        self.uid = uid
        //diction key默认，但是val 是AnyObject？不一定存在，如果找不到key defaultVal就是“”
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        
        //作者优化方法nil or 有内容；但要清空bio时候会有问题；
//        if let bio = dictionary["bio"] as? String {
//            self.bio = bio
//        }
        
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else {return}
            self.profileImageUrl = url
        }
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
