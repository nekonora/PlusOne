//
//  CounterCVCell.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 29/06/2020.
//

import UIKit

class CounterCVCell: UICollectionViewCell {
    
    // MARK: - UI
    private let mainStackView = UIStackView()
    private let nameLabel = UILabel()
    private let valueLabel = UILabel()
    private let stepperStackView = UIStackView()
    private let stepper = UIStepper()
    private var onStepperTapped: ((Float) -> Void)?
    
    // MARK: - External methods
    func setupWith(_ counter: Counter, onStepperTapped: ((Float) -> Void)?) {
        setupContentIfNeeded()
        updateContent(with: counter)
        self.onStepperTapped = onStepperTapped
    }
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanUp()
    }
}

// MARK: - Setup
private extension CounterCVCell {
    
    func updateContent(with counter: Counter) {
        nameLabel.text = counter.name
        valueLabel.text = "\(counter.currentValue)"
    }
    
    func setupContentIfNeeded() {
        guard contentView.subviews.isEmpty else { return }
        setupNameLabel()
        setupValueLabel()
        setupStepper()
        
        contentView.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
        mainStackView.fillSuperview(padding: 15)
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(valueLabel)
        
        stepperStackView.axis = .horizontal
        stepperStackView.addArrangedSubview(UIView())
        stepperStackView.addArrangedSubview(stepper)
        mainStackView.addArrangedSubview(stepperStackView)
        
        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = UIColor.poAccent
    }
    
    func setupNameLabel() {
        nameLabel.textColor = .systemBackground
        nameLabel.font = .roundedFont(ofSize: .headline, weight: .semibold)
    }
    
    func setupValueLabel() {
        valueLabel.textColor = .systemBackground
        valueLabel.textAlignment = .right
        valueLabel.font = .roundedFont(ofSize: .largeTitle, weight: .semibold)
    }
    
    func setupStepper() {
        stepper.tintColor = .systemBackground
        stepper.addTarget(self, action: #selector(didTapStepper(_:)), for: .primaryActionTriggered)
    }
    
    func cleanUp() {
        nameLabel.text = nil
        valueLabel.text = nil
    }
}

// MARK: - Actions
private extension CounterCVCell {
    
    @objc func didTapStepper(_ stepper: UIStepper) {
        onStepperTapped?(Float(stepper.value))
    }
}
