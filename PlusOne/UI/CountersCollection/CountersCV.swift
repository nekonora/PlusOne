//
//  CountersCV.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 30/06/2020.
//

import CoreData
import UIKit

final class CountersCV: UIViewController {
    
    // MARK: - UI
    private var countersCollectionView: UICollectionView!
    private var emptyStateLabel = UILabel()
    
    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<Int, Counter>!
    private var fetchedResultsController: NSFetchedResultsController<Counter>!
    
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
private extension CountersCV {
    
    func setupUI() {
        setupEmptyStateLabel()
        setupCollectionView()
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
        
        emptyStateLabel.text = "You have no counters at the moment,\nuse the + button to add one!"
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
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.setConstraints {
            $0.top(to: view.safeAreaLayoutGuide.topAnchor)
            $0.leading(to: view.leadingAnchor)
            $0.trailing(to: view.trailingAnchor)
            $0.bottom(to: view.bottomAnchor)
        }
        
        #if targetEnvironment(macCatalyst)
        collectionView.backgroundColor = .systemBackground
        #else
        collectionView.backgroundColor = UIColor.poBackground
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
        
        let cellRegistration = UICollectionView.CellRegistration<CounterCVCell, Counter> { cell, indexPath, counter in
            cell.setupWith(counter) {
                CoreDataManager.shared.updateCounterValue(counter, to: $0)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Counter>(collectionView: countersCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Counter) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        initialSnapshot()
    }
    
    // MARK: - Layout
    func generateLayout() -> UICollectionViewLayout {
        let sizeClass = traitCollection.horizontalSizeClass
        let value: CGFloat = {
            if sizeClass == .compact {
                return 0.5
            } else {
                return 0.25
            }
        }()
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(value),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(value))
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
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, Counter>()
        diffableDataSourceSnapshot.appendSections([0])
        diffableDataSourceSnapshot.appendItems(newData)
        dataSource.apply(diffableDataSourceSnapshot, animatingDifferences: true)
        toggleEmptyState(newData.isEmpty)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.countersCollectionView.reloadData()
        }
    }
    
    func resetSnapshot() {
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, Counter>()
        diffableDataSourceSnapshot.appendSections([0])
        diffableDataSourceSnapshot.appendItems([])
        dataSource.apply(diffableDataSourceSnapshot, animatingDifferences: true)
        countersCollectionView.setCollectionViewLayout(generateLayout(), animated: true) { _ in
            self.updateSnapshot()
        }
    }
    
    func toggleEmptyState(_ toggle: Bool) {
        emptyStateLabel.isHidden = !toggle
        countersCollectionView.isHidden = toggle
    }
}

// MARK: - NSFetchedResultControllerDelegate
extension CountersCV: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        updateSnapshot()
    }
}

// MARK: - ContextMenu
extension CountersCV: UICollectionViewDelegate {
    
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
