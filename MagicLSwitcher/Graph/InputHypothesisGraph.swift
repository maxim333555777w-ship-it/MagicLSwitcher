//
//  InputHypothesisGraph.swift
//  MagicLSwitcher
//
//  Created by Khachatur Abramian on 21.4.2026.
//

import Foundation

final class InputHypothesisGraph {
    private(set) var nodes: [GraphNode] = []
    private(set) var edges: [GraphEdge] = []
    
    func addNode(_ node: GraphNode) {
        nodes.append(node)
    }
    func addEdge(_ edge: GraphEdge) {
        edges.append(edge)
    }
    func connect(parent: GraphNode, child: GraphNode, weight: Double = 0.0) {
        addNode(child)
        addEdge(GraphEdge(fromID: parent.id, toID: child.id, weight: weight))
    }
    func children(of nodeID: UUID) -> [GraphNode] {
        let childIDs = edges
            .filter { $0.fromID == nodeID }
            .map { $0.toID }
        return nodes.filter { childIDs.contains($0.id) }
    }
    func parents(of nodeID: UUID) -> [GraphNode] {
        let parentIDs = edges
            .filter { $0.toID == nodeID }
            .map { $0.fromID }
        return nodes.filter { parentIDs.contains($0.id) }
    }
    func node(withID id: UUID) -> GraphNode? {
        nodes.first { $0.id == id }
    }
    func bestNode() -> GraphNode? {
        nodes.max(by: { $0.score < $1.score } )
    }
    func nodes(at position: Int) -> [GraphNode] {
        nodes.filter { $0.position == position }
    }
    func reset() {
        nodes.removeAll()
        edges.removeAll()
    }
}
