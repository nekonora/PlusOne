//
//  RegularSecondaryVC.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 24/06/2020.
//

import UIKit
import CoreData

// MARK: - Controller
class RegularSecondaryVC: UIViewController {
    
    // MARK: - Private Properties
    private var countersCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, Counter>!
    private var fetchedResultsController: NSFetchedResultsController<Counter>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Setup
private extension RegularSecondaryVC {
    
    func setupUI() {
        navigationItem.title = "All counters"
        view.backgroundColor = UIColor.poBackground
        
        setupNavBar()
        setupCollectionView()
        setupDataSource()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTapped))
        ]
    }
    
    // MARK: - CollectionView
    func setupCollectionView() {
        let layout = generateLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Counter> { cell, indexPath, counter in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = counter.name
            contentConfiguration.secondaryText = counter.updatedAt.description
            var backgroundConfiguration = UIBackgroundConfiguration.clear()
            backgroundConfiguration.backgroundColor = UIColor.poAccent
            cell.backgroundConfiguration = backgroundConfiguration
            cell.contentConfiguration = contentConfiguration
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Counter>(collectionView: countersCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Counter) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        initialSnapshot()
    }
    
    // MARK: - Layout
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
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
}

extension RegularSecondaryVC: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        updateSnapshot()
    }
}

// MARK: - Actions
private extension RegularSecondaryVC {
    
    @objc private func onAddTapped() {
        let config = CounterConfig(
            name: "Hey",
            currentValue: 0,
            increment: 0,
            completionValue: nil,
            group: nil
        )
        CoreDataManager.shared.newCounter(config)
    }
}
