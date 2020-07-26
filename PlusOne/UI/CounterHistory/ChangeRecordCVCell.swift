//
//  ChangeRecordCVCell.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 26/07/2020.
//

import Foundation
import UIKit

final class ChangeRecordCVCell: UICollectionViewCell {
    
    // MARK: - UI
    private let mainStackView = UIStackView()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.font = .roundedFont(ofSize: .headline, weight: .regular)
        return label
    }()
    private let oldValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .roundedFont(ofSize: .headline, weight: .semibold)
        return label
    }()
    private let incrementLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .roundedFont(ofSize: .headline, weight: .semibold)
        return label
    }()
    private let arrowImage: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(weight: .semibold)
        imageView.image = UIImage(systemName: "arrow.right", withConfiguration: config)
        imageView.tintColor = UIColor.poBackground3
        return imageView
    }()
    private let newValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .right
        label.font = .roundedFont(ofSize: .headline, weight: .semibold)
        return label
    }()
    
    // MARK: - External methods
    func setupWith(_ changeRecord: ChangeRecord) {
        setupContentIfNeeded()
        updateContent(with: changeRecord)
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanUp()
    }
}

// MARK: - Setup
private extension ChangeRecordCVCell {
    
    func updateContent(with changeRecord: ChangeRecord) {
        let increment: String = {
            let delta = changeRecord.newValue - changeRecord.oldValue
            if delta > 0 {
                return "+" + delta.stringTruncatingZero()
            } else {
                return delta.stringTruncatingZero()
            }
        }()
        
        dateLabel.text = Utils.shared.formatDateToShort(changeRecord.date)
        oldValueLabel.text = changeRecord.oldValue.stringTruncatingZero()
        incrementLabel.text = increment
        newValueLabel.text = changeRecord.newValue.stringTruncatingZero()
    }
    
    func setupContentIfNeeded() {
        guard contentView.subviews.isEmpty else { return }
        contentView.addSubview(mainStackView)
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fill
        mainStackView.alignment = .center
        mainStackView.spacing = 15
        mainStackView.fillSuperview(padding: 0)

        mainStackView.addArrangedSubview(dateLabel)
        
        mainStackView.addArrangedSubview(oldValueLabel)
        oldValueLabel.setConstraints { $0.width(50) }
        
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.alignment = .center
            stack.axis = .horizontal
            stack.spacing = -6
            return stack
        }()
        
        let container: UIView = {
            let view = UIView()
            view.layer.cornerCurve = .continuous
            view.layer.cornerRadius = 15
            view.backgroundColor = UIColor.poBackground3
            return view
        }()
        container.addSubview(incrementLabel)
        incrementLabel.fillSuperview()
        container.setConstraints {
            $0.width(50)
            $0.height(30)
        }
        
        stackView.addArrangedSubview(container)
        stackView.addArrangedSubview(arrowImage)
        arrowImage.setConstraints {
            $0.width(25)
            $0.height(25)
        }
        
        mainStackView.addArrangedSubview(stackView)
        
        mainStackView.addArrangedSubview(newValueLabel)
        newValueLabel.setConstraints { $0.width(50) }
    }
    
    func cleanUp() {
        dateLabel.text = nil
        oldValueLabel.text = nil
        incrementLabel.text = nil
        newValueLabel.text = nil
    }
}
