//
//  EditProfileViewModel.swift
//  Twitter
//
//  Created by Dong Wei on 4/17/20.
//  Copyright © 2020 Dong Wei. All rights reserved.
//

import UIKit

struct EditProfileViewModel{
    
    private let user: User
    let option: EditProfileOptions
    
    
    var titleText: String {
        return option.desciption
    }
    
    var optionValue: String? {
        switch option {
        case .username: return user.username
        case .fullname: return user.fullname
        case .bio: return user.bio
        }
    }
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var shouldHideTextView: Bool {
        return  option != .bio
    }
    
    var shouldHidePlaceHolderLabel:Bool{
        return user.bio != nil
    }
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }

}


enum EditProfileOptions: Int, CaseIterable {
    
    case fullname
    case username
    case bio
    
    var desciption: String{
        switch self {
        case .username: return "Username"
        case .fullname: return "Name"
        case .bio: return "Bio"
        }
    }
}

