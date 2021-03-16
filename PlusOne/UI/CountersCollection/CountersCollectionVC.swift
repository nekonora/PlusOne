//
//  CountersCV.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 30/06/2020.
//

import CoreData
import UIKit

struct CountersCollectionStrings {
    let title = "Counters"
    let emptyLabel = "You have no counters at the moment,\nuse the + button to add one!"
}

final class CountersCollectionVC: UIViewController {
    
    // MARK: - Types
    private enum Section: Hashable, CaseIterable {
        case groups
        case counters
    }
    
    private enum CellType: Hashable {
        case group(name: String)
        case counter(counter: Counter)
    }
    
    // MARK: - UI
    private var countersCollectionView: UICollectionView!
    private var emptyStateLabel = UILabel()
    
    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<Section, CellType>!
    private var fetchedResultsController: NSFetchedResultsController<Counter>!
    let strings = CountersCollectionStrings()
    
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
        
        resetSnapshot()
    }
}

// MARK: - Setup
private extension CountersCollectionVC {
    
    func setupUI() {
        setupCollectionView()
        setupEmptyStateLabel()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { self.setupDataSource() }
    }
    
    // MARK: - Empty state label
    func setupEmptyStateLabel() {
        emptyStateLabel.textColor = UIColor.poAccent
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.alpha = 0.5
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "plus")

        emptyStateLabel.text = strings.emptyLabel
        emptyStateLabel.font = .roundedFont(ofSize: .callout, weight: .medium)
        countersCollectionView.addSubview(emptyStateLabel)
        emptyStateLabel.setConstraints {
            $0.centerX(to: view.safeAreaLayoutGuide.centerXAnchor)
            $0.centerY(to: view.safeAreaLayoutGuide.centerYAnchor)
        }
        emptyStateLabel.isHidden = true
    }
    
    // MARK: - CollectionView
    func setupCollectionView() {
        let layout = generateLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.fillSafeArea()
        
        #if targetEnvironment(macCatalyst)
        collectionView.backgroundColor = .systemBackground
        #else
        collectionView.backgroundColor = .secondarySystemBackground
        #endif
        
        collectionView.delegate = self
        countersCollectionView = collectionView
    }
    
    // MARK: - DataSource
    func setupDataSource() {
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: CoreDataManager.shared.createFetch(for: nil, dateSorted: true) as NSFetchRequest<Counter>,
            managedObjectContext: CoreDataManager.shared.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        
        let groupCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, String> { cell, indexPath, group in
            cell.contentConfiguration = GroupCellConfiguration(name: group)
        }
        
        let counterCellRegistration = UICollectionView.CellRegistration<CounterCell, Counter> { cell, indexPath, counter in
            cell.setupWith(counter) {
                CoreDataManager.shared.updateCounterValue(counter, to: $0)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, CellType>(collectionView: countersCollectionView) { (collectionView, indexPath, data) -> UICollectionViewCell? in
            switch data {
            case .group(let name):
                return collectionView.dequeueConfiguredReusableCell(using: groupCellRegistration, for: indexPath, item: name)
            case .counter(let counter):
                return collectionView.dequeueConfiguredReusableCell(using: counterCellRegistration, for: indexPath, item: counter)
            }
        }
        
        initialSnapshot()
    }
    
    // MARK: - Layout
    func generateLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            sectionIndex == 0 ? self.setupGroupsSection() : self.setupCountersSection()
        }
    }
    
    private func setupGroupsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(6)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 6
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 18)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func setupCountersSection() -> NSCollectionLayoutSection {
        let sizeClass = self.traitCollection.horizontalSizeClass
        let value: CGFloat = {
            if sizeClass == .compact {
                return 0.5
            } else {
                return 0.25
            }
        }()
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(value), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(value))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    // MARK: - Snapshot
    func initialSnapshot() {
        do {
            try fetchedResultsController.performFetch()
            updateSnapshot()
        } catch {
            DevLogger.shared.logMessage(.coreData(message: "CountersCollectionVC - Error retrieving counters"))
        }
    }
    
    func updateSnapshot() {
        let newData = fetchedResultsController.fetchedObjects ?? []
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, CellType>()
        diffableDataSourceSnapshot.appendSections(Section.allCases)
        
        let groups = ["new", "updated", "old", "another one", "other", "maybe that", "hehe"].map(CellType.group(name: ))
        diffableDataSourceSnapshot.appendItems(groups, toSection: .groups)
        
        let counters = newData.map(CellType.counter(counter: ))
        diffableDataSourceSnapshot.appendItems(counters, toSection: .counters)
        
        dataSource.apply(diffableDataSourceSnapshot, animatingDifferences: true)
        toggleEmptyState(newData.isEmpty)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.countersCollectionView.reloadData()
        }
    }
    
    func resetSnapshot() {
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, CellType>()
        diffableDataSourceSnapshot.appendSections(Section.allCases)
        diffableDataSourceSnapshot.appendItems([], toSection: .groups)
        diffableDataSourceSnapshot.appendItems([], toSection: .counters)
        dataSource.apply(diffableDataSourceSnapshot, animatingDifferences: true)
        countersCollectionView.setCollectionViewLayout(generateLayout(), animated: true) { _ in
            self.updateSnapshot()
        }
    }
    
    func toggleEmptyState(_ toggle: Bool) {
        emptyStateLabel.isHidden = !toggle
    }
}

// MARK: - NSFetchedResultControllerDelegate
extension CountersCollectionVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        updateSnapshot()
    }
}

// MARK: - ContextMenu
extension CountersCollectionVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let counters = self.fetchedResultsController.fetchedObjects else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            return CounterPreviewVC(counter: counters[indexPath.item])
        }, actionProvider: { suggestedActions in
            return self.makeContextMenuFor(counter: counters[indexPath.item])
        })
    }
    
    private func makeContextMenuFor(counter: Counter) -> UIMenu {
        let info = UIAction(title: "History", image: UIImage(systemName: "scroll")) { _ in
            let vc = CounterHistoryVC.instance(for: counter)
            self.present(vc, animated: true, completion: nil)
        }
        let edit = UIAction(title: "Edit", image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis")) { _ in
            self.showEditCounter(for: counter)
        }
        let delete = UIAction(title: "Delete...", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.showDeleteAlert(for: counter)
        }
        return UIMenu(title: "", children: [info, edit, delete])
    }
    
    private func showDeleteAlert(for counter: Counter) {
        let ac = UIAlertController(
            title: "Delete \(counter.name)?",
            message: "Are you sure you want to delete this counter?",
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            CoreDataManager.shared.delete(object: counter)
        }))
        present(ac, animated: true, completion: nil)
    }
    
    private func showEditCounter(for counter: Counter) {
        let editCounterVC = NewCounterVC(editingCounter: counter)
        editCounterVC.modalPresentationStyle = .formSheet
        present(editCounterVC, animated: true, completion: nil)
    }
}
