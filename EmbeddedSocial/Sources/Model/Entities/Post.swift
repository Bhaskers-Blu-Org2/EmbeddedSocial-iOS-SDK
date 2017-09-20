//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct Post {
    var topicHandle: String!
    var createdTime: Date?
    
    var user: User?
    
    var title: String?
    var text: String?
    var imageUrl: String?
    var imageHandle: String?

    var deepLink: String?
    
    var totalLikes: Int = 0
    var totalComments: Int = 0

    var liked: Bool = false
    var pinned: Bool = false
    
    var userHandle: String? {
        return user?.uid
    }
    
    var userStatus: FollowStatus {
        get {
            return user?.followerStatus ?? .empty
        }
        set {
            user?.followerStatus = newValue
        }
    }
    
    var firstName: String? {
        return user?.firstName
    }
    
    var lastName: String? {
        return user?.lastName
    }
    
    var photoHandle: String? {
        return user?.photo?.uid
    }
    
    var photoUrl: String? {
        return user?.photo?.url
    }
}

extension Post {
    
    static func mock(seed: Int) -> Post {
        var post = Post()
        post.title = "Title \(seed)"
        post.text = "\n\(seed)\nL\n\no\nn\ng\nt\ne\nx\nt"
        post.liked = seed % 2 == 0
        post.pinned = false
        post.totalLikes = seed
        post.totalComments = seed + 10
        post.topicHandle = "topic handle \(seed)"
        post.user = User(uid: "user handle", followerStatus: .empty)
        return post
    }
}

extension Post {
    
    init(topicHandle: String) {
        self.init()
        self.topicHandle = topicHandle
    }
    
    init(request: PostTopicRequest, photo: Photo?) {
        self.init()
        topicHandle = UUID().uuidString
        title = request.title
        text = request.text
        imageHandle = photo?.uid
        imageUrl = photo?.url
    }
}

extension Post: JSONEncodable {
    
    init?(json: [String: Any]) {
        guard let topicHandle = json["topicHandle"] as? String else {
            return nil
        }
        
        self.init()
        
        self.topicHandle = topicHandle
        createdTime = json["createdTime"] as? Date
        if let userJSON = json["user"] as? [String: Any] {
            user = User(memento: userJSON)
        }
        title = json["title"] as? String
        text = json["text"] as? String
        imageUrl = json["imageUrl"] as? String
        deepLink = json["deepLink"] as? String
        totalLikes = json["totalLikes"] as? Int ?? 0
        totalComments = json["totalComments"] as? Int ?? 0
        liked = json["liked"] as? Bool ?? false
        pinned = json["pinned"] as? Bool ?? false
    }
    
    func encodeToJSON() -> Any {
        let json: [String: Any?] = [
            "topicHandle": topicHandle,
            "createdTime": createdTime,
            "user": user?.encodeToJSON(),
            "title": title,
            "text": text,
            "imageUrl": imageUrl,
            "deepLink": deepLink,
            "totalLikes": totalLikes,
            "totalComments": totalComments,
            "liked": liked,
            "pinned": pinned,
        ]
        return json.flatMap { $0 }
    }
}

extension Post {
    
    init(data: TopicView) {
        
        if let userCompactView = data.user {
            user = User(compactView: userCompactView)
        }
        
        createdTime = data.createdTime
        imageUrl = data.blobUrl
        title = data.title
        text = data.text
        pinned = data.pinned ?? false
        liked = data.liked ?? false
        topicHandle = data.topicHandle
        totalLikes = Int(exactly: Double(data.totalLikes ?? 0))!
        totalComments = Int(exactly: Double(data.totalComments ?? 0))!
    }
    
}

// MARK: Feed
struct Feed {
    var feedType: FeedType
    var items: [Post]
    var cursor: String? = nil
}

// MARK: PostsFetchResult
struct FeedFetchResult {
    var posts: [Post] = []
    var error: FeedServiceError?
    var cursor: String?
}

extension FeedFetchResult {
    init(response: FeedResponseTopicView?) {
        posts = response?.data?.map(Post.init) ?? []
        error = nil
        cursor = response?.cursor
    }
    
    init(error: Error) {
        self.error = FeedServiceError.failedToFetch(message: error.localizedDescription)
        posts = []
        cursor = nil
    }
}

extension FeedFetchResult {
    
    static func mock() -> FeedFetchResult {
        var result = FeedFetchResult()
        
        let number = arc4random() % 5 + 1
        
        for index in 0..<number {
            result.posts.append(Post.mock(seed: Int(index)))
        }
        return result
    }
}

