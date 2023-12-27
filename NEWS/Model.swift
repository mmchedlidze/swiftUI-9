//
//  Model.swift
//  NEWS
//
//  Created by Mariam Mchedlidze on 28.12.23.
//

import SwiftUI


import Foundation

// MARK: - Article
struct Article: Decodable {
    let articles: [News]
}

// MARK: - News
struct News: Decodable {
    let title: String
}
