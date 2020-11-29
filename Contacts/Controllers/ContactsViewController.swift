//
//  ContactsViewController.swift
//  Contacts
//
//  Created by cannabiolog420 on 07.11.2020.
//

import UIKit

class ContactsViewController: UIViewController {

    var collectionView:UICollectionView!
    var dataSource:UICollectionViewDiffableDataSource<ContactsModel.UserCollection,ContactsModel.User>! = nil
    var currentSnapshot:NSDiffableDataSourceSnapshot<ContactsModel.UserCollection,ContactsModel.User>! = nil
    let contactsModel = ContactsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        setupNavigationBar()
        setupCollectionView()
        createDataSource()
        reloadData()
    }

    
    
    
    
    func setupNavigationBar(){
        
        let searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Groups", style: .plain, target: self, action: #selector(addTapped))
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Contacts"
    }
    
    func setupCollectionView(){
        
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout:createCompositionalLayout())
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier:ProfileCell.reuseIdentifier)
        collectionView.register(FavouriteCell.self, forCellWithReuseIdentifier:FavouriteCell.reuseIdentifier)
        collectionView.register(ContactCell.self, forCellWithReuseIdentifier:ContactCell.reuseIdentifier)
        
    }
    
    func createCompositionalLayout()->UICollectionViewCompositionalLayout{
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let type = self.currentSnapshot.sectionIdentifiers[sectionIndex].type
            
            switch type{
            case .profile:
              return self.createProfile()
            case .favourites:
                return self.createFavourite()
            case .contacts:
                return self.createContacts()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        layout.configuration = config
        return layout
        
    }
    
    private func createProfile()->NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(58))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
       let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        return section
    }
    
    private func createFavourite()->NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension:.absolute(120))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func createContacts()->NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:.absolute(55))
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(25))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
    
    
    
    func createDataSource(){
        
        dataSource = UICollectionViewDiffableDataSource<ContactsModel.UserCollection,ContactsModel.User>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            
            var user = user
            let type = self.currentSnapshot.sectionIdentifiers[indexPath.section].type
            let users = self.currentSnapshot.sectionIdentifiers[indexPath.section].users
            
            if type == .contacts{
                if users.count > 1,users.first == user{
                    user.direction = .top
                }else if users.count == 1{
                    user.direction = .all
                }else if users.last == user{
                    user.direction = .bottom
                }else{
                    user.direction = .nope
                }
            }
            
            switch type{
            
            case .profile:
                return self.configure(collectionView: collectionView, cellType: ProfileCell.self, with: user, for: indexPath)
            case .favourites:
                return self.configure(collectionView: collectionView, cellType: FavouriteCell.self, with: user, for: indexPath)
            case .contacts:
                return self.configure(collectionView: collectionView, cellType: ContactCell.self, with: user, for: indexPath)
            }
        })
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self, let snapshot = self.currentSnapshot else { return nil }
            
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader {
                let collection = snapshot.sectionIdentifiers[indexPath.section]
                sectionHeader.titleLabel.text = collection.header
                return sectionHeader
            } else {
                fatalError("Cannot create new supplementary")
            }
            
            
        }
    }
    
    private func reloadData(){
        
        currentSnapshot = NSDiffableDataSourceSnapshot<ContactsModel.UserCollection,ContactsModel.User>()
        

        contactsModel.collections.forEach { (collection) in
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.users)
            
        }
        
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }

}

extension ContactsViewController:UISearchControllerDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}



extension ContactsViewController{
    
    @objc func addTapped(){
        
    }
    
}
