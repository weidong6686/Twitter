//
//  AuthService.swift
//  Twitter
//
//  Created by Dong Wei on 4/2/20.
//  Copyright © 2020 Dong Wei. All rights reserved.
//

import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    //create static instance service
    static let shared = AuthService()
    
    func logUserIn(withEmail email:String, password:String, completion:AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        print("DEBUG: Email is \(email), passward is \(password)")
    }
    
    
    func registerUser(credentials : AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        // upload image data and download image url
        let email = credentials.email
        let password = credentials.password
        let username = credentials.username
        let fullname = credentials.fullname
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl =  url?.absoluteString else {return}
                //firebase api check sign up error
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error{
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    let values = ["email": email, "username": username, "fullname": fullname, "profileImageUrl": profileImageUrl]
                    // util DB constants replace reference URL
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
