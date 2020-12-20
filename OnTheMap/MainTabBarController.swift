//
//  MainTabBarController.swift
//  OnTheMap
//
//  Created by Christopher J. Roura on 12/18/20.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    fileprivate func setupViews() {
        viewControllers = [
            createNavControllers(MapController(),
                                 title: "Map View",
                                 image: "mappin.circle"),
        
            createNavControllers(StudentLocationListController(),
                                 title: "Student Locations",
                                 image: "list.bullet.rectangle")
        ]
    }
    
    
    fileprivate func createNavControllers(_ viewController: UIViewController, title: String, image: String) -> UIViewController {
        let navController                   = UINavigationController(rootViewController: viewController)
        viewController.view.backgroundColor = .systemBackground
        viewController.title                = title
        navController.title                 = title
        navController.tabBarItem.image      = UIImage(systemName: image)
        return navController
    }
}


// MARK: - PREVIEW

struct MainTabBarController_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarControllerContainerView()
            .edgesIgnoringSafeArea(.all)
    }
    
    
    struct MainTabBarControllerContainerView: UIViewControllerRepresentable {
        typealias UIViewControllerType = MainTabBarController
        
        func makeUIViewController(context: Context) -> MainTabBarController {
            MainTabBarController()
        }
        
        func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {
        }
    }
}
