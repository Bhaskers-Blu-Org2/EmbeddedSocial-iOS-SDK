//
//  CreatePostCreatePostViewInput.swift
//  MSGP-Framework
//
//  Created by generamba setup on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

protocol CreatePostViewInput: class {

    /**
        @author generamba setup
        Setup initial state of the view
    */

    func setupInitialState()
    func showError(error: Error)
}
