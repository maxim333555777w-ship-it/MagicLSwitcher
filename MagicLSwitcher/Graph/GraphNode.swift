//
//  GraphNode.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 21.4.2026.
//

import Foundation

struct GraphNode: Identifiable, Hashable {
    let id: UUID
    let layoutID: String
    let text: String
    let position: Int
    let score: Double
    let parentID: UUID?
    
    init(
        id: UUID = UUID(),
        layoutID: String,
        text: String,
        position: Int,
        score: Double,
        parentID: UUID? = nil
    ) {
        self.id = id
        self.layoutID = layoutID
        self.text = text
        self.position = position
        self.score = score
        self.parentID = parentID
    }
}
