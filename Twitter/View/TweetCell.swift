//
//  TweetCell.swift
//  Twitter
//
//  Created by Dong Wei on 4/7/20.
//  Copyright © 2020 Dong Wei. All rights reserved.
//

import UIKit
import ActiveLabel

protocol TweetCellDelegate: class {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
    func handleFetchUser(withUsername username: String)
}


class TweetCell: UICollectionViewCell {
    
    // MARK: properties
    
    var tweet: Tweet? {
        didSet{configure()}
    }
    
    weak  var delegate: TweetCellDelegate?
    
    // lazy var 和 let比是可以动态更新action的网页
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.mentionColor = .twitterBlue
        return label
    }()
    
    private let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        return label
    }()
    
//    private lazy var commentButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "comment"), for: .normal)
//        button.tintColor = .darkGray
//        button.setDimensions(width: 20, height: 20)
//        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var retweetButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "retweet"), for: .normal)
//        button.tintColor = .darkGray
//        button.setDimensions(width: 20, height: 20)
//        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var likeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "like"), for: .normal)
//        button.tintColor = .darkGray
//        button.setDimensions(width: 20, height: 20)
//        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var shareButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "share"), for: .normal)
//        button.tintColor = .darkGray
//        button.setDimensions(width: 20, height: 20)
//        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
//        return button
//    }()
    //使用create button后refactor后优化代码 as TweetHeader
    private lazy var commentButton: UIButton = {
       let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
       let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
       let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
       let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    private let infoLabel = UILabel()
    
    
    //MARK: lifeCycle
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let captionStack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        captionStack.axis = .vertical
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 4
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionStack])
        imageCaptionStack.distribution = .fillProportionally
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
    
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingRight: 12)
           
        replyLabel.isHidden = true
        
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
        
        let underlineview = UIView()
        underlineview.backgroundColor = .systemGroupedBackground
        addSubview(underlineview)
        underlineview.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
        
        configureMentionHandler()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selectors
    
    @objc func handleProfileImageTapped(){
//        print("DEBUG: Profile Image tapped in cell.. ")
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleCommentTapped() {
        delegate?.handleReplyTapped(self)
    }
    
    @objc func handleRetweetTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(self)
    }
    
    @objc func handleShareTapped() {
        
    }
    
    //MARK: helper
    
    func configure(){
        guard let tweet = tweet else {return}
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        infoLabel.attributedText = viewModel.userInfoText
        //喜欢按钮变色更新， 用VM写的func
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        //@reply 显示和赋值
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
    }
    
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    func configureMentionHandler(){
        captionLabel.handleMentionTap {username in
//            print("DEBUG: Tap the mention handler \(username)...")
            self.delegate?.handleFetchUser(withUsername: username)
        }
    }

}
