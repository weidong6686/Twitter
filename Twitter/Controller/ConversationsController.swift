//
//  ConversationsController.swift
//  Twitter
//
//  Created by Dong Wei on 3/30/20.
//  Copyright © 2020 Dong Wei. All rights reserved.
//

import UIKit

class ConversationsController: UIViewController {

    // Mark: Properties
    
    // Mark: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }
    
    // Mark: helper Func
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }

}
