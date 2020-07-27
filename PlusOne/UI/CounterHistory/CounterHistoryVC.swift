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
    lazy private var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        return stack
    }()
    lazy private var historyTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .roundedFont(ofSize: .largeTitle, weight: .bold)
        label.text = "History"
        return label
    }()
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
}

// MARK: - Setup
private extension CounterHistoryVC {
    
    func setupUI() {
        view.addSubview(mainStack)
        mainStack.setConstraints {
            $0.top(to: view.safeAreaLayoutGuide.topAnchor)
            $0.leading(to: view.leadingAnchor)
            $0.trailing(to: view.trailingAnchor)
            $0.bottom(to: view.bottomAnchor)
        }
        
        setupEmptyStateLabel()
        setupCollectionView()
        title = counter.name
        view.backgroundColor = .systemBackground
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { self.setupDataSource() }
    }
    
    // MARK: - Infoheader
    
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
        mainStack.addArrangedSubview(historyTitleLabel)
        mainStack.addArrangedSubview(historyCollectionView)
        
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
            cell.contentView.backgroundColor = indexPath.item.isMultiple(of: 2) ? .systemBackground : UIColor.poBackgroundAltList
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
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
    
    func toggleEmptyState(_ toggle: Bool) {
        emptyStateLabel.isHidden = !toggle
        mainStack.isHidden = toggle
    }
}

// MARK: - ContextMenu
extension CounterHistoryVC: UICollectionViewDelegate {
    
}
