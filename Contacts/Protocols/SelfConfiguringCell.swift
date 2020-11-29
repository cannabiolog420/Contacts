//
//  SelfConfiguringCell.swift
//  Contacts
//
//  Created by cannabiolog420 on 08.11.2020.
//

import UIKit


protocol SelfConfiguringCell {
    
    static var reuseIdentifier:String { get }
    func configure(with:ContactsModel.User)
    
}
