//
//  NewCounterVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 10/07/2020.
//

import UIKit
import SwiftUI

final class NewCounterVC: UIHostingController<NewCounterView> {
    
    private var onDismiss: (() -> Void)?

    convenience init(editingCounter: Counter? = nil, onDismiss: (() -> Void)? = nil) {
        let viewModel = NewCounterVM(counterToEdit: editingCounter)
        self.init(rootView: NewCounterView(viewModel: viewModel))
        viewModel.dismiss = dismiss
        self.onDismiss = onDismiss
    }
    
    func dismiss() {
        onDismiss?()
        dismiss(animated: true, completion: nil)
    }
}
