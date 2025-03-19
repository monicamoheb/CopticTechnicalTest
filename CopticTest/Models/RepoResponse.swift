//
//  MyResponse.swift
//  CopticTest
//
//  Created by kevin marco on 18/03/2025.
//

import Foundation
// https://github.com/orgs/github/repositories


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)
// MARK: - WelcomeElement
struct RepoResponse: Codable {
    var id: Int?
    var nodeID, name, fullName: String?
    var url: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case url
    }
}


