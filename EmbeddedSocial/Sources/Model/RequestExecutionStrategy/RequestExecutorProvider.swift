//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias UsersFeedRequestExecutor = CacheRequestExecutionStrategy<FeedResponseUserCompactView, UsersListResponse>

typealias TopicsFeedRequestExecutor = CacheRequestExecutionStrategy<FeedResponseTopicView, FeedFetchResult>

typealias SuggestedUsersRequestExecutor = CacheRequestExecutionStrategy<[UserCompactView], UsersListResponse>

typealias OutgoingActionRequestExecutor = AtomicOutgoingCommandsExecutor<Object>

typealias MyActivityRequestExecutor = CacheRequestExecutionStrategy<FeedResponseActivityView, ListResponse<ActivityView> >

typealias OthersActivityRequestExecutor = CacheRequestExecutionStrategy<FeedResponseActivityView, ListResponse<ActivityView> >

protocol CacheRequestExecutorProviderType {
    static func makeUsersFeedExecutor(for service: BaseService) -> UsersFeedRequestExecutor
    
    static func makeTopicsFeedExecutor(for service: BaseService) -> TopicsFeedRequestExecutor
    
    static func makeSuggestedUsersExecutor(for service: BaseService) -> SuggestedUsersRequestExecutor
    
    static func makeOutgoingActionRequestExecutor(for service: BaseService) -> OutgoingActionRequestExecutor
    
    static func makeMyFollowingExecutor(for service: BaseService) -> UsersFeedRequestExecutor
    
    static func makeMyBlockedUsersExecutor(for service: BaseService) -> UsersFeedRequestExecutor
    
    static func makeMyActivityExecutor(for service: BaseService) -> MyActivityRequestExecutor
    
    static func makeMyFollowersExecutor(for service: BaseService) -> UsersFeedRequestExecutor
    
    static func makeMyPendingRequestsExecutor(for service: BaseService) -> UsersFeedRequestExecutor
}

struct CacheRequestExecutorProvider: CacheRequestExecutorProviderType {

    static func makeUsersFeedExecutor(for service: BaseService) -> UsersFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseUserCompactView.self,
                                  responseType: UsersListResponse.self,
                                  service: service,
                                  responseProcessor: UsersListResponseProcessor(cache: service.cache))
    }
    
    static func makeMyFollowingExecutor(for service: BaseService) -> UsersFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseUserCompactView.self,
                                  responseType: UsersListResponse.self,
                                  service: service,
                                  responseProcessor: MyFollowingResponseProcessor(cache: service.cache))
    }
    
    static func makeMyBlockedUsersExecutor(for service: BaseService) -> UsersFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseUserCompactView.self,
                                  responseType: UsersListResponse.self,
                                  service: service,
                                  responseProcessor: MyBlockedUsersResponseProcessor(cache: service.cache))
    }
    
    static func makeTopicsFeedExecutor(for service: BaseService) -> TopicsFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseTopicView.self,
                                  responseType: FeedFetchResult.self,
                                  service: service,
                                  responseProcessor: TopicsFeedResponseProcessor())
    }
    
    static func makeMyActivityExecutor(for service: BaseService) -> MyActivityRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseActivityView.self,
                                  responseType: ListResponse<ActivityView>.self,
                                  service: service,
                                  responseProcessor: ActivityFeedProcessor())
    }
    
    
    static func makeSuggestedUsersExecutor(for service: BaseService) -> SuggestedUsersRequestExecutor {
        let executor = SuggestedUsersRequestExecutionStrategy()
        bind(service: service, to: executor)
        return executor
    }
    
    static func makeOutgoingActionRequestExecutor(for service: BaseService) -> OutgoingActionRequestExecutor {
        let executor = OutgoingActionRequestExecutor()
        executor.cache = service.cache
        executor.errorHandler = service.errorHandler
        return executor
    }
    
    static func makeMyFollowersExecutor(for service: BaseService) -> UsersFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseUserCompactView.self,
                                  responseType: UsersListResponse.self,
                                  service: service,
                                  responseProcessor: MyFollowersResponseProcessor(cache: service.cache))
    }
    
    static func makeMyPendingRequestsExecutor(for service: BaseService) -> UsersFeedRequestExecutor {
        return makeCommonExecutor(requestType: FeedResponseUserCompactView.self,
                                  responseType: UsersListResponse.self,
                                  service: service,
                                  responseProcessor: PendingRequestsResponseProcessor(cache: service.cache))
    }
    
    private static func makeCommonExecutor<T: Cacheable, U>(
        requestType: T.Type,
        responseType: U.Type,
        service: BaseService,
        responseProcessor: ResponseProcessor<T, U>) -> CommonCacheRequestExecutionStrategy<T, U> {
        
        let executor = CommonCacheRequestExecutionStrategy<T, U>()
        bind(service: service, to: executor)
        executor.responseProcessor = responseProcessor
        return executor
    }
    
    private static func bind<T, U>(service: BaseService, to executor: CacheRequestExecutionStrategy<T, U>) {
        executor.cache = service.cache
        executor.errorHandler = service.errorHandler
        executor.networkTracker = service.networkStatusMulticast
    }
}
