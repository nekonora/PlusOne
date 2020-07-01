//
//  CounterPreviewVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 01/07/2020.
//

import UIKit

class CounterPreviewVC: UIViewController {
    
    private let imageView = UIImageView()
    
    override func loadView() { view = imageView }
    
    init(counter: Counter) {
        super.init(nibName: nil, bundle: nil)
        preferredContentSize = CGSize(width: 300, height: 200)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
