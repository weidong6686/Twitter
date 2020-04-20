//
//  NotificationsController.swift
//  Twitter
//
//  Created by Dong Wei on 3/30/20.
//  Copyright © 2020 Dong Wei. All rights reserved.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {
    // MARK: Properties
    
    private var notifications = [Notification]() {
        didSet{ tableView.reloadData()}//初始化更新data后刷新下view
    }
    
    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: Selectors
    //刷新 通知页状态
    @objc func handleRefresh(){
        fetchNotifications()
    }
    
    // MARK： API
    
    func fetchNotifications(){
        refreshControl?.beginRefreshing()// 调用刷新开始
        NotificationService.shared.fetchNotifications { notifications in
            self.refreshControl?.endRefreshing()//得到数据刷新结束
            self.notifications = notifications
            self.checkIfUserIsFollowed(notificaions: notifications)
        }
    }
    
    //helper func above
    func checkIfUserIsFollowed(notificaions:[Notification]){
        guard !notifications.isEmpty else {return}
        
        notifications.forEach { notification in
            guard case .follow = notification.type else {return}
            let user = notification.user
            
            UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                
                if let index = self.notifications.firstIndex(where: {$0.user.uid == notification.user.uid}){
                    self.notifications[index].user.isFollowed = isFollowed
                    
                }
            }
        }
    }
    

    // MARK: helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
    }

}
//MARK: UITableViewDataSource
extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self//确认可以点击NotificaionCell头像通过delegate回到其他页面
        return cell
    }
}

//MARK: UITableViewDelegate
extension NotificationsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        //func fetch 单独一条tweet；之前是fetch一组tweets
        guard let tweetID = notification.tweetID else {return}
        TweetService.shared.fetchTweet(withTweetID: tweetID) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


//确认 delegate protocol 所以要写 extension
//MARK:NotificationCellDelegate
extension NotificationsController: NotificationCellDelegate{
    func didTapFollow(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        
        if user.isFollowed{
            UserService.shared.unfollowUser(uid: user.uid) { (err, ref) in
                cell.notification?.user.isFollowed = false
            }
        }else {
            UserService.shared.followUser(uid: user.uid) { (err, ref) in
                cell.notification?.user.isFollowed = true
            }
        }
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)//tap通知头像转到user profileView
    }
}
