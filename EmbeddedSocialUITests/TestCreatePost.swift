//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestCreatePost: UITestBase {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreatePostWithoutImage() {
        
        let sideMenu = SideMenu(app)
        sideMenu.navigateTo("Create post")

        app.buttons["push"].tap()
        
        let createPost = CreatePost(app)
        createPost.postTitle.tap()
        createPost.postTitle.typeText("Post Title")
        createPost.postText.tap()
        createPost.postText.typeText("Post Text")
        createPost.publish()
        
        let request = APIState.getLatestData(forService: "topics")
        
        XCTAssertEqual(request?["title"] as! String, "Post Title")
        XCTAssertEqual(request?["text"] as! String, "Post Text")
    }
    
}
