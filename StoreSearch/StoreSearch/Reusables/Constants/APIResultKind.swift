//
//  ContentType.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/25/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation


enum APIResultKind: CaseIterable {
    case album
    case audioBook
    case ebook
    case book
    case coachedAudio
    case featureMovie
    case interactiveBooklet
    case musicVideo
    case pdf
    case podcast
    case podcastEpisode
    case software
    case song
    case tvEpisode
    case unknown
    
    
    init(rawString: String?) {
        switch rawString {
        case "album":
            self = .album
        case "audioBook":
            self = .audioBook
        case "ebook":
            self = .ebook
        case "book":
            self = .book
        case "coached-audio":
            self = .coachedAudio
        case "feature-movie":
            self = .featureMovie
        case "interactive-booklet":
            self = .interactiveBooklet
        case "music-video":
            self = .musicVideo
        case "pdf":
            self = .pdf
        case "podcast":
            self = .podcast
        case "podcast-episode":
            self = .podcastEpisode
        case "software",
             "software-package":
            self = .software
        case "song":
            self = .song
        case "tvEpisode":
            self = .tvEpisode
        default:
            self = .unknown
        }
    }
}


// MARK: - Computeds

extension APIResultKind {
    
    var displayName: String {
        switch self {
        case .album:
            return "Album"
        case .audioBook:
            return "Audio Book"
        case .ebook:
            return "E-Book"
        case .book:
            return "Book"
        case .coachedAudio:
            return "Coached Audio"
        case .featureMovie:
            return "Movie"
        case .interactiveBooklet:
            return "Interactive Book"
        case .musicVideo:
            return "Music Video"
        case .pdf:
            return "PDF"
        case .podcast:
            return "Podcast"
        case .podcastEpisode:
            return "Podcast Episode"
        case .software:
            return "Software"
        case .song:
            return "Song"
        case .tvEpisode:
            return "TV Episode"
        case .unknown:
            return "Unknown Content Type"
        }
    }
}
