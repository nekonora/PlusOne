//
//  CountersCollectionVM.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 18/03/21.
//

import CoreData
import Foundation
import UIKit.NSDiffableDataSourceSectionSnapshot
import UIKit.UIDiffableDataSource

protocol CountersCollectionViewModel: AnyObject {
    var countersFetchedResultsController: NSFetchedResultsController<Counter> { get }
    
    var onViewDidLoad: (() -> Void)? { get set }
    var onSnapshotUpdated: ((NSDiffableDataSourceSnapshot<CountersCollectionSection, CountersCollectionCellType>) -> Void)? { get set }
    var onNeedsToShowEmptyState: ((Bool) -> Void)? { get set }
    
    func viewDidLoad()
    func fetchData()
    func updateCounterValue(_ counter: Counter, to newValue: Float)
}

enum CountersCollectionSection: Hashable, CaseIterable {
    case groups
    case counters
}

enum CountersCollectionCellType: Hashable {
    case group(name: String)
    case counter(counter: Counter)
}

final class CountersCollectionVM: NSObject, CountersCollectionViewModel {
    
    // MARK: - Properties
    private let coreDataManager: CoreDataManager
    let countersFetchedResultsController: NSFetchedResultsController<Counter>
    let tagsFetchedResultsController: NSFetchedResultsController<Tag>
    
    var onViewDidLoad: (() -> Void)?
    var onSnapshotUpdated: ((NSDiffableDataSourceSnapshot<CountersCollectionSection, CountersCollectionCellType>) -> Void)?
    var onNeedsToShowEmptyState: ((Bool) -> Void)?
    
    // MARK: - Init
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
        
        countersFetchedResultsController = NSFetchedResultsController(
            fetchRequest: coreDataManager.createFetch(for: nil, dateSorted: true) as NSFetchRequest<Counter>,
            managedObjectContext: coreDataManager.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        tagsFetchedResultsController = NSFetchedResultsController(
            fetchRequest: coreDataManager.createFetch(for: nil, dateSorted: false) as NSFetchRequest<Tag>,
            managedObjectContext: coreDataManager.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    // MARK: - Methods
    func viewDidLoad() {
        countersFetchedResultsController.delegate = self
        onViewDidLoad?()
    }
    
    func fetchData() {
        do {
            try countersFetchedResultsController.performFetch()
            try tagsFetchedResultsController.performFetch()
            getUpdatedSnapshot()
        } catch {
            DevLogger.shared.logMessage(.coreData(message: "CountersCollectionVC - Error retrieving counters"))
        }
    }
    
    func updateCounterValue(_ counter: Counter, to newValue: Float) {
        coreDataManager.updateCounterValue(counter, to: newValue)
    }
}

// MARK: - Internal
private extension CountersCollectionVM {
    
    func getUpdatedSnapshot() {
        let newCounterData = countersFetchedResultsController.fetchedObjects ?? []
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<CountersCollectionSection, CountersCollectionCellType>()
        diffableDataSourceSnapshot.appendSections(CountersCollectionSection.allCases)
        
        let newTagsData = tagsFetchedResultsController.fetchedObjects ?? []
        let tagsCells = newTagsData.map { CountersCollectionCellType.group(name: $0.name) }
        diffableDataSourceSnapshot.appendItems(tagsCells, toSection: .groups)
        
        let counters = newCounterData.map(CountersCollectionCellType.counter(counter: ))
        diffableDataSourceSnapshot.appendItems(counters, toSection: .counters)
        
        onSnapshotUpdated?(diffableDataSourceSnapshot)
        onNeedsToShowEmptyState?(newCounterData.isEmpty)
    }
    
    func resetSnapshot() {
        var diffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<CountersCollectionSection, CountersCollectionCellType>()
        diffableDataSourceSnapshot.appendSections(CountersCollectionSection.allCases)
        diffableDataSourceSnapshot.appendItems([], toSection: .groups)
        diffableDataSourceSnapshot.appendItems([], toSection: .counters)
        onSnapshotUpdated?(diffableDataSourceSnapshot)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CountersCollectionVM: NSFetchedResultsControllerDelegate {
    
}
