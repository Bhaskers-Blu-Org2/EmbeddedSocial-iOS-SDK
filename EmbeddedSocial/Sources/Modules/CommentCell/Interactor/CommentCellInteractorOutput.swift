//
//  CommentCellCommentCellInteractorOutput.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 01/09/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import Foundation

protocol CommentCellInteractorOutput: class {
    func didPostAction(action: CommentSocialAction, error: Error?)
}
