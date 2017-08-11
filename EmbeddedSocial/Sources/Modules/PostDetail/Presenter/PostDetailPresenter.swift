//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class PostDetailPresenter: PostDetailModuleInput, PostDetailViewOutput, PostDetailInteractorOutput {

    weak var view: PostDetailViewInput!
    var interactor: PostDetailInteractorInput!
    var router: PostDetailRouterInput!
    
    var post: Post?

    var comments = [Comment]()
    
    // MARK: PostDetailInteractorOutput
    func didFetch(comments: [Comment]) {
        self.comments = comments
        view.reload(animated: true)
    }
    
    func didFetchMore(comments: [Comment]) {
        self.comments.append(contentsOf: comments)
        view.reloadTable()
    }
    
    func didFail(error: CommentsServiceError) {
    }
    
    
    func commentDidPosted(comment: Comment) {
        comments.append(comment)
        view.postCommentSuccess()
    }
    
    func commentPostFailed(error: Error) {
        
    }
    
    func commentLiked(comment: Comment) {
        guard let index = comments.index(of: comment) else {
            return
        }
        
        view.refreshCell(index: index)
    }
    
    func commentUnliked(comment: Comment) {
        guard let index = comments.index(of: comment) else {
            return
        }
        
        view.refreshCell(index: index)
    }
    
    // MAKR: PostDetailViewOutput
    
    func viewIsReady() {
        view.setupInitialState()
        interactor.fetchComments(topicHandle: (post?.topicHandle)!)
    }
    
    func likeComment(comment: Comment) {
        interactor.likeComment(comment: comment)
    }
    
    func unlikeComment(comment: Comment) {
        interactor.unlikeComment(comment: comment)
    }
    
    func numberOfItems() -> Int {
        return comments.count
    }
    
    func fetchMore() {
        interactor.fetchMoreComments(topicHandle: (post?.topicHandle)!)
    }
    
    func comment(index: Int) -> Comment {
        return comments[index]
    }
    
    func postComment(photo: Photo?, comment: String) {
        interactor.postComment(photo: photo, topicHandle: (post?.topicHandle)!, comment: comment)
    }
}
