//
//  NewCounterVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 10/07/2020.
//

import UIKit
import SwiftUI

final class NewCounterVC: UIHostingController<NewCounterView> {

    convenience init() {
        self.init(rootView: NewCounterView())
        self.rootView.dismiss = dismiss
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
