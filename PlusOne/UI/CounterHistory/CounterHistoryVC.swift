//
//  CounterHistoryVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 26/07/2020.
//

import CoreData
import UIKit

final class CounterHistoryVC: UIViewController {
    
    // MARK: - UI
    private var collectionView: UICollectionView!
    private var emptyStateLabel = UILabel()
    
    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<Int, ChangeRecord>!
    private var fetchedResultsController: NSFetchedResultsController<ChangeRecord>!
    private var counter: Counter!
    
    // MARK: - Lifecycle
    static func instance(for counter: Counter) -> UINavigationController {
        let vc = CounterHistoryVC()
        vc.counter = counter
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        guard
//            traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass
//                || traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass
//        else { return }
//
//        resetSnapshot()
//    }
}

// MARK: - Setup
private extension CounterHistoryVC {
    
    func setupUI() {
        setupEmptyStateLabel()
        setupCollectionView()
        title = "\(counter.name) hystory"
        view.backgroundColor = .systemBackground
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { self.setupDataSource() }
    }
    
    // MARK: - Empty state label
    func setupEmptyStateLabel() {
        emptyStateLabel.textColor = UIColor.poAccent
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.alpha = 0.5
        
        emptyStateLabel.text = "This counter has no activity yet."
        emptyStateLabel.font = .roundedFont(ofSize: .callout, weight: .medium)
        view.addSubview(emptyStateLabel)
        emptyStateLabel.setConstraints {
            $0.centerX(to: view.centerXAnchor)
            $0.centerY(to: view.centerYAnchor)
        }
        emptyStateLabel.isHidden = true
    }
    
    // MARK: - CollectionView
    func setupCollectionView() {
        let layout = generateLayout()
        let historyCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(historyCollectionView)
        historyCollectionView.setConstraints {
            $0.top(to: view.safeAreaLayoutGuide.topAnchor)
            $0.leading(to: view.leadingAnchor)
            $0.trailing(to: view.trailingAnchor)
            $0.bottom(to: view.bottomAnchor)
        }
        
        #if targetEnvironment(macCatalyst)
        historyCollectionView.backgroundColor = .systemBackground
        #else
        historyCollectionView.backgroundColor = UIColor.poBackground
        #endif
        
        historyCollectionView.delegate = self
        self.collectionView = historyCollectionView
    }
    
    // MARK: - DataSource
    func setupDataSource() {
        let predicate = NSPredicate(format: "counter == %@", self.counter)
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: CoreDataManager.shared.createGenericFetch(predicate: predicate, dateSorted: true) as NSFetchRequest<ChangeRecord>,
            managedObjectContext: CoreDataManager.shared.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        let cellRegistration = UICollectionView.CellRegistration<ChangeRecordCVCell, ChangeRecord> { cell, indexPath, changeRecord in
            cell.setupWith(changeRecord)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, ChangeRecord>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: ChangeRecord) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        initialSnapshot()
    }
    
    // MARK: - Layout
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // MARK: - Snapshot
    func initialSnapshot() {
        do {
            try fetchedResultsController.performFetch()
            updateSnapshot()
        } catch {
            DevLogger.shared.logMessage(.coreData(message: "CountersCV - Error retrieving counters"))
        }
    }
    
    func updateSnapshot() {
        let newData = fetchedResultsController.fetchedObjects ?? []
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, ChangeRecord>()
        diffableDataSourceSnapshot.appendSections([0])
        diffableDataSourceSnapshot.appendItems(newData)
        dataSource.apply(diffableDataSourceSnapshot, animatingDifferences: true)
        toggleEmptyState(newData.isEmpty)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.collectionView.reloadData()
        }
    }
    
//    func resetSnapshot() {
//        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, ChangeRecord>()
//        diffableDataSourceSnapshot.appendSections([0])
//        diffableDataSourceSnapshot.appendItems([])
//        dataSource.apply(diffableDataSourceSnapshot, animatingDifferences: true)
//        countersCollectionView.setCollectionViewLayout(generateLayout(), animated: true) { _ in
//            self.updateSnapshot()
//        }
//    }
    
    func toggleEmptyState(_ toggle: Bool) {
        emptyStateLabel.isHidden = !toggle
        collectionView.isHidden = toggle
    }
}

// MARK: - ContextMenu
extension CounterHistoryVC: UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        guard let counters = self.fetchedResultsController.fetchedObjects else { return nil }
//
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
//            return CounterPreviewVC(counter: counters[indexPath.item])
//        }, actionProvider: { suggestedActions in
//            return self.makeContextMenuFor(counter: counters[indexPath.item])
//        })
//    }
//
//    private func makeContextMenuFor(counter: Counter) -> UIMenu {
//        let edit = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { _ in
//            self.showEditCounter(for: counter)
//        }
//        let history = UIAction(title: "History", image: UIImage(systemName: "clock")) { _ in
//            for change in counter.changes?.allObjects as [ChangeRecord] {
//                print(change.oldValue, change.newValue)
//            }
//        }
//        let delete = UIAction(title: "Delete...", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
//            self.showDeleteAlert(for: counter)
//        }
//        return UIMenu(title: "", children: [edit, history, delete])
//    }
//
//    private func showDeleteAlert(for counter: Counter) {
//        let ac = UIAlertController(
//            title: "Delete \(counter.name)?",
//            message: "Are you sure you want to delete this counter?",
//            preferredStyle: .alert
//        )
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        ac.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
//            CoreDataManager.shared.delete(object: counter)
//        }))
//        present(ac, animated: true, completion: nil)
//    }
//
//    private func showEditCounter(for counter: Counter) {
//        let editCounterVC = NewCounterVC(editingCounter: counter)
//        editCounterVC.modalPresentationStyle = .formSheet
//        present(editCounterVC, animated: true, completion: nil)
//    }
}
