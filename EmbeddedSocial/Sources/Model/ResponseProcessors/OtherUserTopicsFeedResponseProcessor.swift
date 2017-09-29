//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class OtherUserTopicsFeedResponseProcessor: TopicsFeedResponseProcessor {
    
    override var fetchTopicsPredicate: NSPredicate {
        return predicateBuilder.allTopicActionCommands()
    }
}