//
//  ViewController.swift
//  TransitionAnimator
//
//  Created by Adnann Muratovic on 30.08.21.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var menuItems = [
        MenuItem(name: "Slide Down", imageName: "Doodle Icons-41"),
        MenuItem(name: "Slide Right", imageName: "Doodle Icons-42"),
        MenuItem(name: "Pop", imageName: "Doodle Icons-43"),
        MenuItem(name: "Rotate", imageName: "Doodle Icons-44"),
    ]
    lazy var dataSource = configureDataSource()
    
    let slideDownTransitionAnimator = SlideDownTransitionAnimator()
    let slideRighTransitionAnimator = SlideRightTransitionAnimator()
    let popTransitionAnimator = PopTransitionAnimator()
    let rotateTransitionAnimator = RotateTransitionAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createGridLayout()
        
        updateSnapshot()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toViewController = segue.destination
        let sourceViewController = segue.source as! MenuViewController
        
        if let selectedIndexPaths = sourceViewController.collectionView.indexPathsForSelectedItems {
            switch selectedIndexPaths[0].row {
            case 0: toViewController.transitioningDelegate = slideDownTransitionAnimator
            case 1: toViewController.transitioningDelegate = slideRighTransitionAnimator
            case 2: toViewController.transitioningDelegate = popTransitionAnimator
            case 3: toViewController.transitioningDelegate = rotateTransitionAnimator
            default:
                break
            }
        }
    }
}


extension MenuViewController {
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    enum Section {
        case all
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, MenuItem> {
        let dataSource = UICollectionViewDiffableDataSource<Section, MenuItem>(collectionView: collectionView) {
            (collectionView, indexPath, imageName) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuCell
            
            if let item = self.dataSource.itemIdentifier(for: indexPath) {
                cell.titleLabel.text = item.name
                cell.imageName.image = UIImage(named: item.imageName)
            }
            
            return cell
        }
        
        return dataSource
    }
    
    private func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MenuItem>()
        snapshot.appendSections([.all])
        snapshot.appendItems(menuItems, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
}
