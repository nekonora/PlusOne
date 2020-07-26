//
//  CounterCVCell.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 29/06/2020.
//

import UIKit

final class CounterCVCell: UICollectionViewCell {
    
    // MARK: - UI
    private let mainStackView = UIStackView()
    private let nameLabel = UILabel()
    private let valueLabel = UILabel()
    private let unitLabel = UILabel()
    private let valueStack = UIStackView()
    private let progressView = UIProgressView()
    private let stepperStackView = UIStackView()
    private let stepper = UIStepper()
    private var onStepperTapped: ((Float) -> Void)?
    
    // MARK: - Properties
    private var completionValue: Float = 0
    
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
        valueLabel.text = counter.currentValue.stringTruncatingZero()
        unitLabel.text = counter.unit
        stepper.value = Double(counter.currentValue)
        stepper.stepValue = Double(counter.increment)
        completionValue = counter.completionValue
        if counter.completionValue > 0 {
            progressView.progress = counter.currentValue / counter.completionValue
        } else {
            progressView.progress = 0
        }
    }
    
    func setupContentIfNeeded() {
        guard contentView.subviews.isEmpty else { return }
        setupNameLabel()
        setupValueLabel()
        setupUnitLabel()
        setupStepper()
        
        contentView.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
        mainStackView.fillSuperview(padding: 15)
        
        mainStackView.addArrangedSubview(nameLabel)
        
        valueStack.axis = .horizontal
        valueStack.spacing = 10
        valueStack.alignment = .lastBaseline
        valueStack.addArrangedSubview(unitLabel)
        valueStack.addArrangedSubview(valueLabel)
        mainStackView.addArrangedSubview(valueStack)
        
        progressView.tintColor = .white
        mainStackView.addArrangedSubview(progressView)
        
        stepperStackView.axis = .horizontal
        stepperStackView.addArrangedSubview(UIView())
        stepperStackView.addArrangedSubview(stepper)
        mainStackView.addArrangedSubview(stepperStackView)
        
        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = UIColor.poBackground3
    }
    
    func setupNameLabel() {
        nameLabel.textColor = .white
        nameLabel.font = .roundedFont(ofSize: .headline, weight: .semibold)
    }
    
    func setupValueLabel() {
        valueLabel.textColor = .white
        valueLabel.textAlignment = .right
        valueLabel.font = .roundedFont(ofSize: .largeTitle, weight: .semibold)
    }
    
    func setupUnitLabel() {
        unitLabel.textColor = .white
        unitLabel.textAlignment = .right
        unitLabel.font = .roundedFont(ofSize: .headline, weight: .semibold)
    }
    
    func setupStepper() {
        stepper.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: UIFont.systemFontSize, weight: .bold, scale: .large)
        stepper.setDecrementImage(UIImage(systemName: "minus", withConfiguration: imageConfig), for: .normal)
        stepper.setIncrementImage(UIImage(systemName: "plus", withConfiguration: imageConfig), for: .normal)
        stepper.subviews.forEach { $0.backgroundColor = UIColor.poAccent?.withAlphaComponent(0.5) }
        stepper.addTarget(self, action: #selector(didTapStepper(_:)), for: .primaryActionTriggered)
        stepper.maximumValue = 999_999_999_999
        stepper.minimumValue = -999_999_999_999
    }
    
    func cleanUp() {
        nameLabel.text = nil
        valueLabel.text = nil
        unitLabel.text = nil
        stepper.value = 0
        stepper.stepValue = 1
        progressView.progress = 0
        completionValue = 0
    }
}

// MARK: - Actions
private extension CounterCVCell {
    
    @objc func didTapStepper(_ stepper: UIStepper) {
        valueLabel.text = Float(stepper.value).stringTruncatingZero()
        progressView.progress = Float(stepper.value) / completionValue
        onStepperTapped?(Float(stepper.value))
    }
}
