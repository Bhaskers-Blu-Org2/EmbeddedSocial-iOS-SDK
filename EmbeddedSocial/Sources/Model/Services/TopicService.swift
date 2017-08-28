//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//
import Foundation
import Alamofire

typealias TopicPosted = (PostTopicRequest) -> Void
typealias Failure = (Error) -> Void

enum FeedServiceError: Error {
    case failedToFetch(message: String)
    case failedToLike(message: String)
    case failedToUnLike(message: String)
    case failedToPin(message: String)
    case failedToUnPin(message: String)
    
    var message: String {
        switch self {
        case .failedToFetch(let message),
             .failedToPin(let message),
             .failedToUnPin(let message),
             .failedToLike(let message),
             .failedToUnLike(let message):
            return message
        }
    }
}

typealias FetchResultHandler = ((PostFetchResult) -> Void)

struct PopularFeedQuery {
    var cursor: Int32?
    var limit: Int32?
    var timeRange: TopicsAPI.TimeRange_topicsGetPopularTopics!
}

struct RecentFeedQuery {
    var cursor: String?
    var limit: Int32?
}

struct UserFeedQuery {
    var cursor: String?
    var limit: Int32?
    var user: UserHandle!
    
    func cursorInt() -> Int32? {
        return (cursor == nil) ? nil : Int32(cursor!)
    }
}

struct HomeFeedQuery {
    var cursor: String?
    var limit: Int32?
}

struct MyFeedQuery {
    var cursor: String?
    var limit: Int32?
    
    func cursorInt() -> Int32? {
        return (cursor == nil) ? nil : Int32(cursor!)
    }
}

protocol PostServiceProtocol {
    
    func fetchHome(query: HomeFeedQuery)
    func fetchPopular(query: PopularFeedQuery)
    func fetchRecent(query: RecentFeedQuery)
    func fetchRecent(query: UserFeedQuery)
    func fetchPopular(query: UserFeedQuery)
    func fetchPost(post: PostHandle)
    func fetchMyPosts(query: MyFeedQuery)
    func fetchMyPopular(query: MyFeedQuery)
    
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void))
}

protocol PostServiceDelegate: class {
    
    func didFetchHome(query: HomeFeedQuery, result: PostFetchResult)
}

extension PostServiceProtocol {
    
    func fetchHome(query: HomeFeedQuery, completion: @escaping FetchResultHandler) { Logger.log("No Implementation") }
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) { Logger.log("No Implementation") }
    func fetchRecent(query: RecentFeedQuery, completion: @escaping FetchResultHandler) { Logger.log("No Implementation") }
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) { Logger.log("No Implementation") }
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) { Logger.log("No Implementation") }
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) { Logger.log("No Implementation") }
    func fetchMyPosts(query: MyFeedQuery, completion: @escaping FetchResultHandler) { Logger.log("No Implementation") }
    func fetchMyPopular(query: MyFeedQuery, completion: @escaping FetchResultHandler) { Logger.log("No Implementation") }
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void)) { Logger.log("No Implementation") }
}


class TopicService: BaseService, PostServiceProtocol {
    
    private var imagesService: ImagesServiceType!
    private var delegate: PostServiceDelegate!
    
    init(imagesService: ImagesServiceType, delegate: PostServiceDelegate) {
        super.init()
        self.delegate = delegate
        self.imagesService = imagesService
    }
    
    func postTopic(topic: PostTopicRequest, photo: Photo?, success: @escaping TopicPosted, failure: @escaping Failure) {
        guard let network = NetworkReachabilityManager() else {
            failure(APIError.unknown)
            return
        }
        
        guard network.isReachable else {
            cacheTopic(topic, with: photo)
            return
        }
        
        guard let image = photo?.image else {
            postTopic(request: topic, success: success, failure: failure)
            return
        }
        
        imagesService.uploadContentImage(image) { [unowned self] result in
            if let handle = result.value {
                topic.blobHandle = handle
                topic.blobType = .image
                self.postTopic(request: topic, success: success, failure: failure)
            } else if self.errorHandler.canHandle(result.error) {
                self.errorHandler.handle(result.error)
            } else {
                failure(result.error ?? APIError.unknown)
            }
        }
    }
    
    private func cacheTopic(_ topic: PostTopicRequest, with photo: Photo?) {
        if let photo = photo {
            cache.cacheOutgoing(photo)
            topic.blobHandle = photo.uid
        }
        cache.cacheOutgoing(topic)
    }
    
    private func postTopic(request: PostTopicRequest, success: @escaping TopicPosted, failure: @escaping Failure) {
        TopicsAPI.topicsPostTopic(request: request, authorization: authorization) { response, error in
            if response != nil {
                success(request)
            } else if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else {
                failure(error ?? APIError.unknown)
            }
        }
    }
    
    
    
    // MARK: GET
    
    func fetchHome(query: HomeFeedQuery) {
        
        let request = SocialAPI.myFollowingGetTopicsWithRequestBuilder(authorization: authorization,
                                                                       cursor: query.cursor,
                                                                       limit: query.limit)
        
        processCache(with: request) { response, error in
            self.parseResponse(requestURL: nil, response: response, error: error) { 
                self.delegate.didFetchHome(query: query, result: <#T##PostFetchResult#>)
            }
            self.delegate.didFetchHome(query: query, result: <#T##PostFetchResult#>)
        }
        processRequest(request, completion: completion)
    }
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        
        let request = TopicsAPI.topicsGetPopularTopicsWithRequestBuilder(timeRange: query.timeRange,
                                                                         authorization: authorization,
                                                                         cursor: query.cursor,
                                                                         limit: query.limit)
        
        processCache(with: request, completion: completion)
        processRequest(request, completion: completion)
    }
    
    func fetchRecent(query: RecentFeedQuery, completion: @escaping FetchResultHandler) {
        
        let request = TopicsAPI.topicsGetTopicsWithRequestBuilder(authorization: authorization,
                                                                  cursor: query.cursor,
                                                                  limit: query.limit)
        
        processCache(with: request, completion: completion)
        processRequest(request, completion: completion)
    }
    
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        
        let request = UsersAPI.userTopicsGetTopicsWithRequestBuilder(userHandle: query.user,
                                                                     authorization: authorization,
                                                                     cursor: query.cursor,
                                                                     limit: query.limit)
        
        processCache(with: request, completion: completion)
        processRequest(request, completion: completion)
    }
    
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        
        let request = UsersAPI.userTopicsGetPopularTopicsWithRequestBuilder(userHandle: query.user,
                                                                            authorization: authorization,
                                                                            cursor: query.cursorInt(),
                                                                            limit: query.limit)
        
        processCache(with: request, completion: completion)
        processRequest(request, completion: completion)
    }
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        TopicsAPI.topicsGetTopic(topicHandle: post, authorization: authorization) { (topic, error) in
            
            var result = PostFetchResult()
            
            guard let data = topic else {
                if self.errorHandler.canHandle(error) {
                    self.errorHandler.handle(error)
                } else {
                    let message = error?.localizedDescription ?? L10n.Error.noItemFor("\(post)")
                    result.error = FeedServiceError.failedToFetch(message: message)
                    completion(result)
                }
                return
            }
            
            result.posts = [Post(data: data)]
            completion(result)
        }
    }
    
    func fetchMyPosts(query: MyFeedQuery, completion: @escaping FetchResultHandler) {
        
        let request = UsersAPI.myTopicsGetTopicsWithRequestBuilder(authorization: authorization,
                                                                   cursor: query.cursor,
                                                                   limit: query.limit)
        
        processCache(with: request, completion: completion)
        processRequest(request, completion: completion)
    }
    
    func fetchMyPopular(query: MyFeedQuery, completion: @escaping FetchResultHandler) {
        let request = UsersAPI.myTopicsGetPopularTopicsWithRequestBuilder(authorization: authorization,
                                                                          cursor: query.cursorInt(),
                                                                          limit: query.limit)
        
        processCache(with: request, completion: completion)
        processRequest(request, completion: completion)
        
    }
    
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void)) {
        TopicsAPI.topicsDeleteTopic(topicHandle: post, authorization: authorization) { (object, errorResponse) in
            if let error = errorResponse {
                self.errorHandler.handle(error: error, completion: completion)
            } else {
                completion(.success())
            }
        }
    }
    
    typealias FeedResponseHandler = ((response: FeedResponseTopicView?, error: Error?) -> ())
    
    // MARK: Private
    
    private func processRequest(_ requestBuilder:RequestBuilder<FeedResponseTopicView>,
                                completion: @escaping ProcessRequestHandler) {
        
        let requestURL = requestBuilder.URLString
        
        requestBuilder.execute { (response, error) in
            completion()
            self.parseResponse(requestURL: requestURL,
                               response: response?.body,
                               error: error,
                               completion: completion)
        }
    }
    
    private func processCache(with requestBuilder:RequestBuilder<FeedResponseTopicView>,
                              completion: @escaping FetchResultHandler) {
        
        let requestURL = requestBuilder.URLString
        
        if let cachedResponse = cache.firstIncoming(ofType: FeedResponseTopicView.self, typeID: requestURL) {
            self.parseResponse(response: cachedResponse, error: nil, completion: completion)
        }
    }
    
    private func parseResponse(requestURL: String? = nil,
                               response: FeedResponseTopicView?,
                               error: Error?) -> PostFetchResult?
    {
        
        var result = PostFetchResult()
        
        guard let response = response else {
            if errorHandler.canHandle(error) {
                errorHandler.handle(error)
            } else {
                let message = error?.localizedDescription ?? L10n.Error.noItemsReceived
                result.error = FeedServiceError.failedToFetch(message: message)
            }
            return result
        }
        
        if let data = response.data {
            result.posts = data.map(Post.init)
        }
        result.cursor = response.cursor
        
        completion(result)
        
        if let requestURL = requestURL {
            cache.cacheIncoming(response, for: requestURL)
        }
    }
}
