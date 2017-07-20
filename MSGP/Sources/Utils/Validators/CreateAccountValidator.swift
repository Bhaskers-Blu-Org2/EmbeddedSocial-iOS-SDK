//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct CreateAccountValidator: Validator {
    struct Options {
        let firstName: String?
        let lastName: String?
        let bio: String?
        let photo: UIImage?
    }
    
    static func validate(_ value: Options) -> Bool {
        guard let firstName = value.firstName,
            let lastName = value.lastName else {
                return false
        }
        
        return !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
