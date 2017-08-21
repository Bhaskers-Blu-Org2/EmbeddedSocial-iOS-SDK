//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

enum RepliesSocialAction: Int {
    case like, unlike
}

class CommentRepliesInteractor: CommentRepliesInteractorInput {

    weak var output: CommentRepliesInteractorOutput!
    private var isLoading = false
    
    var repliesService: RepliesServiceProtcol?
    var likeService: LikesServiceProtocol?
    
    // MARK: Social Actions
    
    func replyAction(replyHandle: String, action: RepliesSocialAction) {
        
        let completion: LikesServiceProtocol.CommentCompletionHandler = { [weak self] (handle, error) in
            self?.output.didPostAction(replyHandle: replyHandle, action: action, error: error)
        }
        
        switch action {
        case .like:
            likeService?.likeReply(replyHandle: replyHandle, completion: completion)
        case .unlike:
            likeService?.unlikeReply(replyHandle: replyHandle, completion: completion)
        }
        
    }

    func fetchReplies(commentHandle: String, cursor: String?, limit: Int) {
        isLoading = true
        repliesService?.fetchReplies(commentHandle: commentHandle, cursor: cursor, limit: limit) { (result) in
            guard result.error == nil else {
                return
            }
            
            self.isLoading = false
            self.output.fetched(replies: result.replies,  cursor: result.cursor)
        }
    }
    
    func fetchMoreReplies(commentHandle: String, cursor: String?, limit: Int) {
        if cursor == "" || cursor == nil || isLoading == true {
            return
        }
        
        isLoading = true
        repliesService?.fetchReplies(commentHandle: commentHandle, cursor: cursor, limit: limit, resultHandler: { (result) in
            guard result.error == nil else {
                return
            }
            
            self.isLoading = false
            self.output.fetchedMore(replies: result.replies, cursor: result.cursor)
        })
        
    }
    
    func postReply(commentHandle: String, text: String) {
        let request = PostReplyRequest()
        request.text = text
        
        repliesService?.postReply(commentHandle: commentHandle, request: request, success: { (response) in
            self.repliesService?.reply(replyHandle: response.replyHandle!, success: { (reply) in
                self.output.replyPosted(reply: reply)
            }, failure: { (error) in
                
            })
        }, failure: { (error) in
            self.output.replyFailPost(error: error)
        })
    }

    
}
