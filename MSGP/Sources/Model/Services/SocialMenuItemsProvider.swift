//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
        
        guard let builder = items[.authenticated]?[index].builder else {
            return UIViewController()
        }
        
        return builder(self.coordinator)
    }
    
    // MARK: Items
    
    typealias ModuleBuilder = (_ coordinator: CrossModuleCoordinator) -> UIViewController
    
    static var builderForSignIn: ModuleBuilder = { coordinator in
        
        let module = LoginConfigurator()
        module.configure(moduleOutput: coordinator)
        return module.viewController
    }
    
    static var builderForDummy: ModuleBuilder = { coordinator in
        return UIViewController()
    }
    
    var items = [State.authenticated: [
        (title: "Home", image: UIImage(asset: Asset.iconHome), builder: builderForDummy),
        (title: "Search", image: UIImage(asset: Asset.iconSearch), builder: builderForDummy),
        (title: "Popular", image: UIImage(asset: Asset.iconPopular), builder: builderForDummy),
        (title: "My pins", image: UIImage(asset: Asset.iconPins), builder: builderForDummy),
        (title: "Activity Feed", image: UIImage(asset: Asset.iconActivity), builder: builderForDummy),
        (title: "Settings", image: UIImage(asset: Asset.iconSettings), builder: builderForDummy)
        ], State.unauthenticated: [
            (title: "Search", image: UIImage(asset: Asset.iconSearch), builder: builderForDummy),
            (title: "Popular", image: UIImage(asset: Asset.iconPopular), builder: builderForDummy)
        ]]
}
