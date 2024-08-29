//  
//  LibraryEntity.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

class LibraryEntity {
}

enum LibraryTag: CaseIterable {
    case favorite
    case watchLater
    case watched
    case disliked
    
    var title: String {
        switch self {
        case .favorite:
            return "Favorites"
        case .watchLater:
            return "Watch-Later"
        case .watched:
            return "Watched"
        case .disliked:
            return "Disliked"
        }
    }
}
