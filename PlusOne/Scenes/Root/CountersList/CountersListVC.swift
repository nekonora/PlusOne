//
//  CountersListVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 16/09/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit
import SwiftUI

class CountersListVC: UIHostingController<CountersListUI> {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rootView = CountersListUI()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
    }
}
