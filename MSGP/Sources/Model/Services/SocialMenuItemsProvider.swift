//
//  SocialMenuProvider.swift
//  MSGP
//
//  Created by Igor Popov on 7/13/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

class SocialMenuItemsProvider: SideMenuItemsProvider {
    
    weak var coordinator: CrossModuleCoordinator!
    
    init(coordinator: CrossModuleCoordinator) {
        self.coordinator = coordinator
    }
    
    enum State: Int {
        case authenticated, unauthenticated
    }
    
    enum Route: Int {
        case home, signin
    }
    
    var state: State {
        if SocialPlus.shared.modelStack != nil {
            return .authenticated
        } else {
            return .unauthenticated
        }
    }
    
    var items = [
        State.authenticated:[(title: "Home", image: UIImage(asset: Asset.iconLiked)),
            (title: "Sign In", image: UIImage(asset: Asset.iconLiked)),
            (title: "Search", image: UIImage(asset: Asset.iconSearch)),
            (title: "Popular", image: UIImage(asset: Asset.iconPopular)),
            (title: "My pins", image: UIImage(asset: Asset.iconPins)),
            (title: "Activity Feed", image: UIImage(asset: Asset.iconActivity)),
            (title: "Settings", image: UIImage(asset: Asset.iconSettings)),
            (title: "Log out", image: UIImage(asset: Asset.iconLogout))],
        State.unauthenticated:[(title: "Popular", image: UIImage(asset: Asset.iconPopular)),
            (title: "Sign In", image: UIImage(asset: Asset.iconLiked)),
        ]
    ]
    
    func numberOfItems() -> Int {
        return items[state]!.count
    }
    
    func image(forItem index: Int) -> UIImage {
        return items[state]![index].image
    }
    
    func title(forItem index: Int) -> String {
        return items[state]![index].title
    }
    
    func destination(forItem index: Int) -> UIViewController {
        
        guard let route = Route(rawValue: index) else {
            return UIViewController()
        }
        
        var destinationVC: UIViewController? = nil
        
        switch route {
        case .home:
            
            destinationVC = UIViewController()
            destinationVC?.view.backgroundColor = UIColor.purple
            
        case .signin:
            
            let loginModule = LoginConfigurator()
            loginModule.configure(moduleOutput: coordinator)
            destinationVC = loginModule.viewController
        }
        
        return destinationVC!
    }
}
