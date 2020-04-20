//
//  NotificationService.swift
//  Twitter
//
//  Created by Dong Wei on 4/13/20.
//  Copyright © 2020 Dong Wei. All rights reserved.
//

import Firebase
//通知 在 like rely retweet时都会有
struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(toUser user: User,
                            type: NotificationType,
                            tweetID: String? = nil){// 不一定有，默认值是nil
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var values: [String: Any] =  ["timestamp": Int(NSDate().timeIntervalSince1970),
                                      "uid": uid,
                                      "type": type.rawValue]
        
        if let tweetID = tweetID {//reply, follow 都有 user，tweetID不一定有
            values["tweetID"] = tweetID
        }
        REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
    }
    
    fileprivate func getNotifications(uid: String, completion: @escaping([Notification])->Void) {
        //无通知不进去遍历
        var notifications = [Notification]()
        REF_NOTIFICATIONS.child(uid).observe( .childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            //获取uid2的user2，新建通知数组返回completion
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notification(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
    
    func fetchNotifications(completion: @escaping([Notification])->Void){
        let notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        //make sure notification exists for user
        REF_NOTIFICATIONS.child(uid).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                //no notification return completion to active RefreshEnding
                completion(notifications)
            }else{
                self.getNotifications(uid: uid, completion: completion)
            }
        }
    }
}


