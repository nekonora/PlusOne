//
//  GroupCell.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 16/03/21.
//

import UIKit

struct GroupCellConfiguration: UIContentConfiguration {
    
    let name: String
    
    func makeContentView() -> UIView & UIContentView {
        GroupCellContent(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> GroupCellConfiguration {
        self
    }
}

private final class GroupCellContent: UIView, UIContentView {
    
    // MARK: - Properties
    var configuration: UIContentConfiguration {
        didSet {
            self.configure()
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        return label
    }()
    
    // MARK: - Lifecycle
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func configure() {
        guard let config = self.configuration as? GroupCellConfiguration else { return }
        nameLabel.text = config.name
    }
    
    private func setupUI() {
        addSubview(nameLabel)
        nameLabel.setConstraints {
            $0.top(to: self.topAnchor)
            $0.bottom(to: self.bottomAnchor)
            $0.leading(to: self.leadingAnchor, constant: 10)
            $0.trailing(to: self.trailingAnchor, constant: -10, priority: .defaultHigh)
        }
        
        layer.cornerRadius = 6
        layer.cornerCurve = .continuous
        backgroundColor = .poBackground3
    }
}