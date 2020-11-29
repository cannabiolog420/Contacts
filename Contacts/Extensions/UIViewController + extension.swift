//
//  UIViewController + extension.swift
//  Contacts
//
//  Created by cannabiolog420 on 08.11.2020.
//

import UIKit


extension UIViewController{
    
    
    func configure<T:SelfConfiguringCell>(collectionView:UICollectionView,cellType:T.Type,with user:ContactsModel.User,for indexPath:IndexPath)->T{
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else { fatalError("unable te dequeue \(cellType)")}
        cell.configure(with: user)
        
        return cell
        
    }
}
