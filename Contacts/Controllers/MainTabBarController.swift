//
//  MainTabBarController.swift
//  Contacts
//
//  Created by cannabiolog420 on 07.11.2020.
//

import UIKit



class MainTabBarController:UITabBarController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        let contactsVC = ContactsViewController()
        let recentVC = RecentViewController()
        
        viewControllers = [generateNavigationController(rootViewController: contactsVC, title: "Contacts", image: UIImage(systemName: "person.crop.circle")!),generateNavigationController(rootViewController: recentVC, title: "Recent", image: UIImage(systemName:"clock.fill")!)]
        
    }
    
    
    
    
    
    private func generateNavigationController(rootViewController:UIViewController,title:String,image:UIImage)->UIViewController{
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image

        return navigationController
    }
    
}
