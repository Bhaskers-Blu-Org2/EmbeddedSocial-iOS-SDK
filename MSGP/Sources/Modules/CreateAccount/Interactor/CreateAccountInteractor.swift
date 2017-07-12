//
//  CreateAccountCreateAccountInteractor.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

final class CreateAccountInteractor: CreateAccountInteractorInput {
    
    private let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }
    
    func createAccount(email: String, password: String, completion: @escaping (Result<User>) -> Void) {
        
    }
}
