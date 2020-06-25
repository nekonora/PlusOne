//
//  RegularPrimaryVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit

// MARK: - Sidebar sections
private enum Section: CaseIterable {
    case main
    
    var defaultMenuItems: [OutlineItem] {
        switch self {
        case .main:
            return [
                OutlineItem(title: "Counters", subitems: [
                    OutlineItem(title: "All", subitems: [], viewController: nil),
                    OutlineItem(title: "Group1", subitems: [], viewController: nil),
                    OutlineItem(title: "Group2", subitems: [], viewController: nil)
                ], viewController: nil),
                OutlineItem(title: "Tags", subitems: [
                    OutlineItem(title: "All", subitems: [], viewController: nil),
                    OutlineItem(title: "Tag1", subitems: [], viewController: nil),
                    OutlineItem(title: "Tag2", subitems: [], viewController: nil)
                ], viewController: nil),
                OutlineItem(title: "Stats", subitems: [
                ], viewController: nil)
            ]
        }
    }
}

// MARK: - Sidebar outline item
private struct OutlineItem: Hashable {
    
    private let identifier = UUID()
    
    let title: String
    let subitems: [OutlineItem]
    let viewController: UIViewController.Type?
    
    static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool { lhs.identifier == rhs.identifier }
    
    func hash(into hasher: inout Hasher) { hasher.combine(identifier) }
}

class RegularPrimaryVC: UIViewController {
    
    // MARK: - Private Properties
    private var outlineCollectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>! = nil
    
    private var selectedItem: OutlineItem?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.poBackground2
        navigationItem.title = "PlusOne"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureCollectionView()
        configureDataSource()
    }
}

// MARK: - Setup
private extension RegularPrimaryVC {
    
    // MARK: - CollectionView
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.poBackground2
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        outlineCollectionView = collectionView
    }
    
    // MARK: - DataSource
    func configureDataSource() {
        let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { (cell, indexPath, menuItem) in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration
            
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
            cell.accessories = [.outlineDisclosure(options:disclosureOptions)]
            cell.backgroundConfiguration = UIBackgroundConfiguration.listSidebarHeader()
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { cell, indexPath, menuItem in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = menuItem.title
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.listSidebarCell()
            cell.isSelected = menuItem == self.selectedItem
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, OutlineItem>(collectionView: outlineCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: OutlineItem) -> UICollectionViewCell? in
            if item.subitems.isEmpty {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: containerCellRegistration, for: indexPath, item: item)
            }
        }
        
        let snapshot = initialSnapshot()
        dataSource.apply(snapshot, to: .main, animatingDifferences: false)
    }
    
    // MARK: - Layout
    func generateLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        listConfiguration.backgroundColor = UIColor.poBackground2
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }
    
    // MARK: - Snapshot
    func initialSnapshot() -> NSDiffableDataSourceSectionSnapshot<OutlineItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<OutlineItem>()
        let items = Section.main.defaultMenuItems
        snapshot.append(items, to: nil)
        items
            .filter { !$0.subitems.isEmpty }
            .forEach { snapshot.append($0.subitems, to: $0) }
        return snapshot
    }
}

// MARK: - CollectionViewDelegate
extension RegularPrimaryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selected = dataSource.itemIdentifier(for: indexPath) else { return }
        selectedItem = selected
        collectionView.reloadData()
    }
}
