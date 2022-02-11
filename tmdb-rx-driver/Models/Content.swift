//
//  Content.swift
//  tmdb-rx-driver
//
//  Created by Стожок Артём on 11.02.2022.
//

import Foundation

enum Content {
    case movie(Movie)
    case person(Person)
    case tv(Show)
}

extension Content: Decodable {
    private enum CodingKeys: String, CodingKey {
        case type = "media_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let singleContainer = try decoder.singleValueContainer()

        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "movie":
            let movie = try singleContainer.decode(Movie.self)
            self = .movie(movie)
        case "person":
            let person = try singleContainer.decode(Person.self)
            self = .person(person)
        case "tv":
            let show = try singleContainer.decode(Show.self)
            self = .tv(show)
        default:
            fatalError("Unknown type of content.")
        }
    }
}
