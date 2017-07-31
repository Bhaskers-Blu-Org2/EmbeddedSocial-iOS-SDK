//
//  MockUserProfileInteractor.swift
//  EmbeddedSocial
//
//  Created by Vadim Bulavin on 7/31/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

@testable import EmbeddedSocial

class MockUserProfileInteractor: UserProfileInteractorInput {
    private(set) var getUserCount = 0
    private(set) var getRecentPostsCount = 0
    private(set) var getPopularPostsCount = 0
    private(set) var getMyRecentPostsCount = 0
    private(set) var getMyPopularPostsCount = 0
    
    private(set) var followCount = 0
    private(set) var unfollowCount = 0
    private(set) var cancelPendingCount = 0
    private(set) var unblockCount = 0
    private(set) var blockCount = 0
    
    var userToReturn: User?
    
    func getUser(userID: String, completion: @escaping (Result<User>) -> Void) {
        getUserCount += 1
        if let user = userToReturn {
            completion(.success(user))
        }
    }
    
    func getRecentPosts(userID: String, completion: @escaping (Result<[Any]>) -> Void) {
        getRecentPostsCount += 1
    }
    
    func getPopularPosts(userID: String, completion: @escaping (Result<[Any]>) -> Void) {
        getPopularPostsCount += 1
    }
    
    func getMyRecentPosts(completion: @escaping (Result<[Any]>) -> Void) {
        getMyRecentPostsCount += 1
    }
    
    func getMyPopularPosts(completion: @escaping (Result<[Any]>) -> Void) {
        getMyPopularPostsCount += 1
    }
    
    func follow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        followCount += 1
    }
    
    func unfollow(userID: String, completion: @escaping (Result<Void>) -> Void) {
        unfollowCount += 1
    }
    
    func cancelPending(userID: String, completion: @escaping (Result<Void>) -> Void) {
        cancelPendingCount += 1
    }
    
    func unblock(userID: String, completion: @escaping (Result<Void>) -> Void) {
        unblockCount += 1
    }
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void) {
        blockCount += 1
    }
}
