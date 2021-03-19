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
                OutlineItem(title: R.string.localizable.sidebarSectionAllCounters(), image: UIImage(systemSymbol: .squareStack3dDownRight), subitems: [], viewController: nil),
                OutlineItem(title: R.string.localizable.sidebarSectionTags(), image: UIImage(systemSymbol: .tag), subitems: [], viewController: nil)
            ]
        }
    }
}

// MARK: - Sidebar outline item
private struct OutlineItem: Hashable {
    
    let identifier = UUID()
    
    let title: String
    let image: UIImage?
    let subitems: [OutlineItem]
    let viewController: UIViewController.Type?
    
    static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool { lhs.identifier == rhs.identifier }
    
    func hash(into hasher: inout Hasher) { hasher.combine(identifier) }
}

// MARK: - Controller
final class RegularPrimaryVC: UIViewController {
    
    // MARK: - UI
    private var outlineCollectionView: UICollectionView!
    
    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>!
    private var selectedItem: OutlineItem?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup
private extension RegularPrimaryVC {
    
    func setupUI() {
        #if targetEnvironment(macCatalyst)
        hideNavBar()
        #else
        setupNavBar()
        #endif
        
        configureCollectionView()
        configureDataSource()
    }
    
    func hideNavBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupNavBar() {
        navigationItem.title = R.string.localizable.appTitle()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - CollectionView
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = false
        outlineCollectionView = collectionView
    }
    
    // MARK: - DataSource
    func configureDataSource() {
//        let containerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { (cell, indexPath, menuItem) in
//            var contentConfiguration = cell.defaultContentConfiguration()
//            contentConfiguration.text = menuItem.title
//            contentConfiguration.image = menuItem.image
//            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .subheadline)
//            cell.contentConfiguration = contentConfiguration
//
//            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header)
//            cell.accessories = [.outlineDisclosure(options:disclosureOptions)]
//            cell.backgroundConfiguration = UIBackgroundConfiguration.listSidebarHeader()
//        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, OutlineItem> { cell, indexPath, menuItem in
            var contentConfiguration = cell.defaultContentConfiguration()
            
            if self.selectedItem == nil, menuItem.title == R.string.localizable.sidebarSectionAllCounters() {
                self.selectedItem = menuItem
            }
            
            contentConfiguration.text = menuItem.title
            contentConfiguration.image = menuItem.image
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration
            cell.backgroundConfiguration = UIBackgroundConfiguration.listSidebarCell()
            cell.isSelected = menuItem == self.selectedItem
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, OutlineItem>(collectionView: outlineCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: OutlineItem) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        let snapshot = initialSnapshot()
        dataSource.apply(snapshot, to: .main, animatingDifferences: false)
    }
    
    // MARK: - Layout
    func generateLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        
        #if !targetEnvironment(macCatalyst)
        listConfiguration.backgroundColor = UIColor.poBackground2
        #endif
        
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
