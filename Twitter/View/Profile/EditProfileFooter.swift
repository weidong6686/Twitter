//
//  EditProfileFooter.swift
//  Twitter
//
//  Created by Dong Wei on 4/19/20.
//  Copyright © 2020 Dong Wei. All rights reserved.
//

import UIKit

protocol EditProfileFooterDelegate: class {
    func handleLogout()
}

class EditProfileFooter: UIView {

//MARK: Properties
    
    weak var delegate: EditProfileFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        return button
    }()
    

 //MARK:Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
//        logoutButton.addConstraintsToFillView(self)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.centerY(inView: self)
    }
    
//    init(user: User) {
//        self.user = user
//        super.init(frame: .zero)
        
//        backgroundColor = .twitterBlue
        
                
//        addSubview(profileImageView)
//        profileImageView.center(inView: self, yConstant: -16)
//        profileImageView.setDimensions(width: 100, height: 100)
//        profileImageView.layer.cornerRadius = 100 / 2
//
//        addSubview(changePhotoButton)
//        changePhotoButton.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 8)
//
//        profileImageView.sd_setImage(with: user.profileImageUrl)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selectors
    
    @objc func handleLogout(){
        delegate?.handleLogout()
    }
    
    //MARK:APIs

    //MARK: Helpers
}
