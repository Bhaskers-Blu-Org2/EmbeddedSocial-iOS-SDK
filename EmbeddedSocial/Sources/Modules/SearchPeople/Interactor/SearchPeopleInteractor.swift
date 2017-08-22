//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchPeopleInteractor: SearchPeopleInteractorInput {
    
    func makeBackgroundListHeaderView() -> UIView {
        let cell = GroupHeaderTableCell.fromNib()
        cell.apply(style: .peopleSearch)
        cell.configure(title: L10n.Search.Label.basedOnWhoYouFollow.uppercased())
        return cell
    }
    
    func runSearchQuery(for searchController: UISearchController, usersListModule: UserListModuleInput) {
        guard let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        let api = QueryPeopleAPI(query: searchText, searchService: SearchService())
        usersListModule.reload(with: api)
    }
}