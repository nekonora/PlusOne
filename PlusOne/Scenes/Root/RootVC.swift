//
//  ViewController.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 07/09/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit

class RootVC: UIViewController {
    
    // MARK - Outlets
    
    @IBOutlet weak var containerView: UIView!
    
    // MARK - Properties
    
    // MARK - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let countersListChild = Scenes.countersList.fromStoryboard() as? CountersListVC {
            addChild(countersListChild)
            countersListChild.view.frame = containerView.frame
            containerView.addSubview(countersListChild.view)
            countersListChild.didMove(toParent: self)
        }
    }
}
