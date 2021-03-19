//
//  ViewController.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 18/03/21.
//

import UIKit

protocol ViewControllerProtocol: AnyObject {
    associatedtype VM
    init(viewModel: VM)
}

class ViewController<U>: UIViewController, ViewControllerProtocol {
    
    typealias VM = U
    let viewModel: VM
    
    required init(viewModel: U) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() { }
}
