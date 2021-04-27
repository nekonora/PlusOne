//
//  CountersCV.swift
//  PlusOne
//
//  Created by Filippo Zaffoni on 30/06/2020.
//

import CoreData
import UIKit

final class CountersCollectionVC: ViewController<CountersCollectionViewModel> {
    
    // MARK: - UI
    private var countersCollectionView: UICollectionView!
    private var emptyStateLabel = UILabel()
    
    // MARK: - Properties
    private var dataSource: UICollectionViewDiffableDataSource<CountersCollectionSection, CountersCollectionCellType>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    override func bind() {
        viewModel.onViewDidLoad = { [weak self] in
            self?.setupUI()
        }
        
        viewModel.onSnapshotUpdated = { [weak self] in
            self?.applySnaphot($0)
        }
        
        viewModel.onNeedsToShowEmptyState = { [weak self] in
            self?.toggleEmptyState($0)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard
            traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass
            || traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass
            else { return }
        
        countersCollectionView.setCollectionViewLayout(generateLayout(), animated: true) { [weak self] _ in
            self?.viewModel.fetchData()
        }
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

        emptyStateLabel.text = R.string.localizable.countersCollectionEmptyLabelMessage()
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
        let groupCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, String> { cell, indexPath, group in
            cell.contentConfiguration = GroupCellConfiguration(name: group)
        }
        
        let counterCellRegistration = UICollectionView.CellRegistration<CounterCell, Counter> { cell, indexPath, counter in
            cell.setupWith(counter) { [weak self] in
                self?.viewModel.updateCounterValue(counter, to: $0)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<CountersCollectionSection, CountersCollectionCellType>(collectionView: countersCollectionView) { (collectionView, indexPath, data) -> UICollectionViewCell? in
            switch data {
            case .group(let name):
                return collectionView.dequeueConfiguredReusableCell(using: groupCellRegistration, for: indexPath, item: name)
            case .counter(let counter):
                return collectionView.dequeueConfiguredReusableCell(using: counterCellRegistration, for: indexPath, item: counter)
            }
        }
        
        viewModel.fetchData()
    }
    
    // MARK: - Layout
    func generateLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            sectionIndex == 0 ? self.setupGroupsSection() : self.setupCountersSection()
        }
    }
    
    func setupGroupsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(6)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 6
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 18)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func setupCountersSection() -> NSCollectionLayoutSection {
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
    func applySnaphot(_ snapshot: NSDiffableDataSourceSnapshot<CountersCollectionSection, CountersCollectionCellType>) {
        dataSource.apply(snapshot, animatingDifferences: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.countersCollectionView.reloadData()
        }
    }
    
    func toggleEmptyState(_ toggle: Bool) {
        emptyStateLabel.isHidden = !toggle
    }
}

// MARK: - NSFetchedResultControllerDelegate
extension CountersCollectionVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        viewModel.fetchData()
    }
}

// MARK: - ContextMenu
extension CountersCollectionVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let counters = viewModel.fetchedResultsController.fetchedObjects else { return nil }
        
        switch indexPath.section {
        case 0:
            return nil
        default:
            return UIContextMenuConfiguration(identifier: nil) {
                CounterPreviewVC(counter: counters[indexPath.item])
            } actionProvider: { _ in
                self.makeContextMenuFor(counter: counters[indexPath.item])
            }
        }
    }
    
    private func makeContextMenuFor(counter: Counter) -> UIMenu {
        let info = UIAction(title: R.string.localizable.counterCellOptionsHistory(), image: UIImage(systemSymbol: .scroll)) { _ in
            let vc = CounterHistoryVC.instance(for: counter)
            self.present(vc, animated: true, completion: nil)
        }
        let edit = UIAction(title: R.string.localizable.counterCellOptionsEdit(), image: UIImage(systemSymbol: .rectangleAndPencilAndEllipsis)) { _ in
            self.showEditCounter(for: counter)
        }
        let delete = UIAction(title: R.string.localizable.counterCellOptionsDelete(), image: UIImage(systemSymbol: .trash), attributes: .destructive) { _ in
            self.showDeleteAlert(for: counter)
        }
        return UIMenu(title: "", children: [info, edit, delete])
    }
    
    private func showDeleteAlert(for counter: Counter) {
        let ac = UIAlertController(
            title: R.string.localizable.counterCellDeleteAlertTitle(counter.name),
            message: R.string.localizable.counterCellDeleteAlertMessage(),
            preferredStyle: .alert
        )
        ac.addAction(UIAlertAction(title: R.string.localizable.alertCancel(), style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: R.string.localizable.alertYes(), style: .destructive, handler: { _ in
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
