//
//  UIFont + Extension.swift
//  Contacts
//
//  Created by cannabiolog420 on 12.11.2020.
//

import UIKit



extension UIFont{
    
    
    enum RoundedWeight{
        case medium,regular,semibold
    }
    
    static func sfProRounded(ofSize:CGFloat,weight:RoundedWeight)->UIFont?{
        
        switch weight {
        case .medium:
            return UIFont.init(name: "SFProRounded-Medium", size: ofSize)
        case .regular:
            return UIFont.init(name: "SFProRounded-Regular", size: ofSize)
        case .semibold:
            return UIFont.init(name: "SFProRounded-Semibold", size: ofSize)
        }
    }
    
    
}
