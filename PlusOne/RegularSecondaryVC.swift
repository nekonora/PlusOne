//
//  RegularSecondaryVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit

class RegularSecondaryVC: UIViewController {
    
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Secondary"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.poBackground
    }

}
