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
            return NSLocalizedString(
                "Album",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: Album"
            )
        case .audioBook:
            return NSLocalizedString(
                "Audio Book",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: Audio Book"
            )
        case .ebook:
            return NSLocalizedString(
                "E-Book",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: E-Book"
            )
        case .book:
            return NSLocalizedString(
                "Book",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: Book"
            )
        case .coachedAudio:
            return NSLocalizedString(
                "Coached Audio",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: Coached Audio"
            )
        case .featureMovie:
            return NSLocalizedString(
                "Movie",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: Movie"
            )
        case .interactiveBooklet:
            return NSLocalizedString(
                "Interactive Book",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: Interactive Book"
            )
        case .musicVideo:
            return NSLocalizedString(
                "Music Video",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: Music Video"
            )
        case .pdf:
            return NSLocalizedString(
                "PDF",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: PDF"
            )
        case .podcast:
            return NSLocalizedString(
                "Podcast",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: Podcast"
            )
        case .podcastEpisode:
            return NSLocalizedString(
                "Podcast Episode",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: Podcast Episode"
            )
        case .software:
            return NSLocalizedString(
                "Software",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: Software"
            )
        case .song:
            return NSLocalizedString(
                "Song",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: Song"
            )
        case .tvEpisode:
            return NSLocalizedString(
                "TV Episode",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: TV Episode"
            )
        case .unknown:
            return NSLocalizedString(
                "Unknown Content Type",
                comment: "Localized display name for the \"kind\" value returned by the iTunes Search API for a piece of content: Unknown Content Type"
            )
        }
    }
}
