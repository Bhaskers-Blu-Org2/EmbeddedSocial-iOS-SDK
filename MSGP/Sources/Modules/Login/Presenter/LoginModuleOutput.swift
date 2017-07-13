//
//  LoginModuleOutput.swift
//  SocialPlusv0
//
//  Created by Vadim Bulavin on 7/6/17.
//  Copyright © 2017 Microsoft Corporation. All rights reserved.
//

protocol LoginModuleOutput: class {
    func onLogin(_ user: User)
}
