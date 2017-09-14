//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class BlockCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var user = User()
        let sut = BlockCommand(user: user)
        
        // when
        sut.apply(to: &user)
        
        // then
        XCTAssertEqual(user.followingStatus, .blocked)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let user = User()
        let sut = BlockCommand(user: user)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertTrue(inverseCommand is UnblockCommand)
        XCTAssertEqual(sut.user, inverseCommand.user)
    }
    
    func testThatItReturnsCorrectCombinedHandle() {
        // given
        let user = User()
        let sut = BlockCommand(user: user)
        
        // when
        let handle = sut.combinedHandle
        
        // then
        XCTAssertEqual(handle, "BlockCommand-\(user.uid)")
    }
}
