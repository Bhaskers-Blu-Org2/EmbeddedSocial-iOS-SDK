//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

enum CommentSocialAction: Int {
    case like, unlike
}

class PostDetailInteractor: PostDetailInteractorInput {

    weak var output: PostDetailInteractorOutput?
    
    var commentsService: CommentServiceProtocol?
    var topicService: PostServiceProtocol?
    var isLoading = false
    
    private var pages: [CommentsPage] = []
    private var pendingPages: Set<String> = Set()
    
    private let queue = DispatchQueue(label: "PostDetailInteractor-queue")
    
    func fetchComments(topicHandle: String, cursor: String?, limit: Int32) {
            self.isLoading = true
            self.commentsService?.fetchComments(topicHandle: topicHandle, cursor: cursor, limit: limit, cachedResult: { (cachedResult) in
                if !cachedResult.comments.isEmpty {
                    self.fetchedItems(result: cachedResult)
                }
            }, resultHandler: { (webResult) in
                    self.fetchedItems(result: webResult)
            })
    }

    private func fetchedItems(result: CommentFetchResult) {
        guard result.error == nil else {
            return
        }
        
        self.isLoading = false
        self.output?.didFetch(comments: result.comments, cursor: result.cursor)
    }
    
    func fetchMoreComments(topicHandle: String, cursor: String?, limit: Int32) {
        
        if cursor == "" || cursor == nil || self.isLoading == true {
                return
        }
        
        self.isLoading = true
        self.commentsService?.fetchComments(topicHandle: topicHandle, cursor: cursor, limit: limit, cachedResult: { (cachedResult) in
            if !cachedResult.comments.isEmpty {
                self.fetchedMoreItems(result: cachedResult)
            }
        }, resultHandler: { (webResult) in
            self.fetchedMoreItems(result: webResult)
        })

    }
    
    private func fetchedMoreItems(result: CommentFetchResult) {
        guard result.error == nil else {
            return
        }
        
        self.isLoading = false
        self.output?.didFetchMore(comments: result.comments, cursor: result.cursor)
    }
    
    func postComment(photo: Photo?, topicHandle: String, comment: String) {
        let request = PostCommentRequest()
        request.text = comment
        
        commentsService?.postComment(topicHandle: topicHandle, request: request, photo: photo, resultHandler: { (response) in
            self.commentsService?.comment(commentHandle: response.commentHandle!, cachedResult: { (cachedComment) in
                self.output?.commentDidPost(comment: cachedComment)
            }, success: { (webComment) in
                self.output?.commentDidPost(comment: webComment)
            }, failure: { (errpr) in
                print("error fetching single comment")
            })

        }, failure: { (error) in
            print("error posting comment")
        })
        
    }
    
    private func getNextCommentsPage(skipCache: Bool, completion: @escaping (Result<[Comment]>) -> Void) {
        isLoading = true
        
        let pageID = UUID().uuidString
        pendingPages.insert(pageID)
        
        
    }
    
    private func addUniquePage(_ page: CommentsPage) {
        queue.sync {
            if let index = pages.index(of: page) {
                pages[index] = page
            } else {
                pages.append(page)
            }
        }
    }
}

extension PostDetailInteractor {
    
    struct CommentsPage: Hashable {
        let uid: String
        let response: CommentFetchResult
        
        var hashValue: Int {
            return uid.hashValue
        }
        
        static func ==(lhs: CommentsPage, rhs: CommentsPage) -> Bool {
            return lhs.uid == rhs.uid
        }
    }
}
