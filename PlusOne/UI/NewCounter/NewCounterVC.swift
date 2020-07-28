//
//  NewCounterVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 10/07/2020.
//

import UIKit
import SwiftUI

final class NewCounterVC: UIHostingController<NewCounterView> {
    
    // MARK: - Properties
    private var onDismiss: (() -> Void)?

    // MARK: - Lifecycle
    convenience init(editingCounter: Counter? = nil, onDismiss: (() -> Void)? = nil) {
        let viewModel = NewCounterVM(counterToEdit: editingCounter)
        self.init(rootView: NewCounterView(viewModel: viewModel))
        viewModel.dismiss = dismiss
        self.onDismiss = onDismiss
    }
    
    private override init(rootView: NewCounterView) { super.init(rootView: rootView) }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actins
    func dismiss() {
        onDismiss?()
        dismiss(animated: true, completion: nil)
    }
}
