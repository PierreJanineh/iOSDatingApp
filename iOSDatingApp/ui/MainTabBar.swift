//
//  MainTabBarViewController.swift
//  iOSDatingApp
//
//  Created by Pierre Janineh on 07/03/2021.
//

import UIKit

class MainTabBar: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.Strings.MAIN_APP_TITLE
        
        delegate = self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController === FavouritesViewController.self {
            
        } else if viewController === DashboardViewController.self {
            
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
