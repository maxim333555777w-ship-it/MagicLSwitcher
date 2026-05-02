//
//  GraphEdge.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 21.4.2026.
//

import Foundation

struct GraphEdge: Hashable {
    let fromID: UUID
    let toID: UUID
    let weight: Double
    
    init(fromID: UUID, toID: UUID, weight: Double = 0.0) {
        self.fromID = fromID
        self.toID = toID
        self.weight = weight
    }
}
