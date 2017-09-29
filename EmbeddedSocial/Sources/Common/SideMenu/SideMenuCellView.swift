//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SideMenuCellView: UITableViewCell {
    
    @IBOutlet weak var picture: UIImageView?
    @IBOutlet weak var title: UILabel?

    func configure(withModel model: SideMenuItemModel)  {
        picture!.image = model.isSelected ? model.imageHighlighted : model.image
        title!.text = model.title
        isSelected = model.isSelected
    }
    
    override public var isSelected: Bool {
        didSet {
            title?.textColor = isSelected ? Constants.Menu.selectedItemColor : Constants.Menu.defaultItemColor
        }
    }
}