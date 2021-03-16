//
//  SettingsVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/01/21.
//

import UIKit

struct SettingsStrings {
    let title = "Settings"
}

final class SettingsVC: UIViewController {
    
    // MARK: - Types
    enum SettingsCell {
        case tintColor, iCloudSync, leaveTip
        
        var title: String {
            switch self {
            case .tintColor: return "Tint Color"
            case .iCloudSync: return "iCloud Sync"
            case .leaveTip: return "Leave Tip"
            }
        }
    }
    
    // MARK: - UI
    private var settingsCollectionView: UICollectionView!
    
    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<Int, SettingsCell>!
    let strings = SettingsStrings()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard
            traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass
                || traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass
        else { return }
        
        initialSnapshot()
    }
}

// MARK: - Setup
private extension SettingsVC {
    
    func setupUI() {
        setupCollectionView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { self.setupDataSource() }
    }
    
    // MARK: - CollectionView
    func setupCollectionView() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.fillSafeArea()
        
        #if targetEnvironment(macCatalyst)
        collectionView.backgroundColor = .systemBackground
        #else
        collectionView.backgroundColor = UIColor.poBackground
        #endif
        
        collectionView.delegate = self
        settingsCollectionView = collectionView
    }
    
    // MARK: - DataSource
    func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SettingsCell> { cell, indexPath, settingsCell in
            cell.contentConfiguration = self.createConfigForCell(settingsCell, from: cell.defaultContentConfiguration())
            cell.accessories = []
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, SettingsCell>(collectionView: settingsCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: SettingsCell) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        initialSnapshot()
    }
    
    // MARK: - Snapshot
    func initialSnapshot() {
        let cells: [SettingsCell] = [
            .tintColor,
            .iCloudSync,
            .leaveTip
        ]
        
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, SettingsCell>()
        diffableDataSourceSnapshot.appendSections([0])
        diffableDataSourceSnapshot.appendItems(cells)
        dataSource.apply(diffableDataSourceSnapshot, animatingDifferences: false)
    }
    
    // MARK: - Cell setup
    func createConfigForCell(_ cell: SettingsCell, from config: UIListContentConfiguration) -> UIListContentConfiguration {
        var newConfig = config
        newConfig.text = cell.title
        
        switch cell {
        case .tintColor:
            newConfig.image = UIImage(systemName: "paintbrush.fill")
        case .iCloudSync:
            newConfig.image = UIImage(systemName: "arrow.clockwise.icloud.fill")
            newConfig.secondaryText = "Last synced: 12/12/2009"
        case .leaveTip:
            newConfig.image = UIImage(systemName: "heart.fill")
        }
        return newConfig
    }
}

// MARK: - UICollectionViewDelegate
extension SettingsVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
