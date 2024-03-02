import 'node.dart';
import 'edge.dart';

export 'edge.dart';
export 'node.dart';
export 'graph_object.dart';
export 'utils.dart';

class Policy {
  late String name;
  late final List<Node> nodes;
  late final List<Edge> edges;

  Policy({required this.name, List<Node>? nodes, List<Edge>? edges})
      : nodes = nodes ?? [],
        edges = edges ?? [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nodes': nodes.map((node) => node.toJson()).toList(),
      'edges': edges.map((edge) => edge.toJson()).toList(),
    };
  }

  Policy.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nodes = json['nodes'].map<Node>((node) {
      if (node['type'] == NodeType.tag.value) {
        return TagNode.fromJson(node);
      }

      if (node['type'] == NodeType.entry.value) {
        return EntryNode.fromJson(node);
      }

      if (node['type'] == NodeType.exit.value) {
        return ExitNode.fromJson(node);
      }
      throw ArgumentError('Unknown node type: ${node['type']}');
    }).toList();
    edges = json['edges'].map<Edge>((edge) => Edge.fromJson(edge, nodes)).toList();
  }

  // Cartesian product
  Policy operator *(Policy otherPolicy) {
    final List<_CombinedNode> combinedNodes = [];

    final nodes1 = this.nodes;
    final nodes2 = otherPolicy.nodes;

    for (var node1 in nodes1) {
      for (var node2 in nodes2) {
        // TODO - No edges from/to boundary nodes are created if we just match combine nodes of same type :(

        NodeType? combinedNodeType;
        if (node1 is EntryNode && node2 is EntryNode) {
          combinedNodeType = NodeType.entry;
        } else if (node1 is ExitNode && node2 is ExitNode) {
          combinedNodeType = NodeType.exit;
        } else if (node1 is TagNode && node2 is TagNode) {
          combinedNodeType = NodeType.tag;
        }

        if (combinedNodeType != null) {
          combinedNodes.add(_CombinedNode(node1: node1, node2: node2, type: combinedNodeType));
        }
      }
    }

    List<({int source, int destination, EdgeType type})> combineEdges(List<Edge> edges, {bool compareFirstComponent = true}) {
      List<({int source, int destination, EdgeType type})> combinedEdges = [];
      for (var edge in edges) {
        for (var i = 0; i < combinedNodes.length; i++) {
          for (var j = 0; j < combinedNodes.length; j++) {
            if (i == j) continue;
            var combinedNode1 = combinedNodes[i];
            var combinedNode2 = combinedNodes[j];

            if (combinedNode1 == combinedNode2 ||
                (compareFirstComponent
                    ? combinedNode1.node2 != combinedNode2.node2
                    : combinedNode1.node1 != combinedNode2.node1)) {
              continue;
            }

            final comparedComponent1 = compareFirstComponent ? combinedNode1.node1 : combinedNode1.node2;
            final comparedComponent2 = compareFirstComponent ? combinedNode2.node1 : combinedNode2.node2;

            if (edge.source == comparedComponent1 && edge.target == comparedComponent2) {
              combinedEdges.add((source: i, destination: j, type: edge.type));
            } else if (edge.source == comparedComponent2 && edge.target == comparedComponent1) {
              combinedEdges.add((source: j, destination: i, type: edge.type));
            }
          }
        }
      }
      return combinedEdges;
    }

    final newEdges = [
      ...combineEdges(this.edges, compareFirstComponent: true),
      ...combineEdges(otherPolicy.edges, compareFirstComponent: false)
    ];

    List<Node> nodes = [];
    List<Edge> edges = [];

    for (var node in combinedNodes) {
      final combinedLabel = '${node.node1.label}/${node.node2.label}';
      final combinedPosition = node.node1.position + node.node2.position;
      nodes.add(node.type == NodeType.tag
          ? TagNode(combinedPosition, combinedLabel)
          : BoundaryNode.create(node.type, combinedPosition, combinedLabel));
    }

    for (var edge in newEdges) {
      edges.add(Edge(nodes[edge.source], nodes[edge.destination], edge.type));
    }

    return Policy(name: '$name x ${otherPolicy.name}', nodes: nodes, edges: edges);
  }
}

class _CombinedNode {
  final Node node1;
  final Node node2;
  final NodeType type;

  _CombinedNode({required this.node1, required this.node2, required this.type});
}
