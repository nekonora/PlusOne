//
//  CountersCV.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 30/06/2020.
//

import CoreData
import UIKit

class CountersCV: UIViewController {
    
    // MARK: - Private Properties
    private var countersCollectionView: UICollectionView!
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
        view.backgroundColor = UIColor.poBackground
        
        setupCollectionView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { self.setupDataSource() }
    }
    
    // MARK: - CollectionView
    func setupCollectionView() {
        let layout = generateLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        collectionView.backgroundColor = UIColor.poBackground
        //        collectionView.delegate = self
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
                print(counter.identifier, $0)
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
            print("Error retrieving counters")
        }
    }
    
    func updateSnapshot() {
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Int, Counter>()
        diffableDataSourceSnapshot.appendSections([0])
        diffableDataSourceSnapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        dataSource.apply(diffableDataSourceSnapshot, animatingDifferences: true)
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
}

extension CountersCV: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        updateSnapshot()
    }
}
