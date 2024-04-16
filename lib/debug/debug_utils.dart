import 'package:flutter/material.dart';
import '../policy/policy.dart';

Policy getMockPolicy() {
  // // TODO ensure unique IDS?
  final priv = TagNode('priv', Offset(500, 350));
  final pub = TagNode('pub', Offset(700, 350));
  final stdin = EntryNode('stdin', Offset(300, 250));
  final stdout = ExitNode('stdout', Offset(900, 250));

  return Policy(name: 'Policy 1', nodes: [
    priv,
    pub,
    stdin,
    stdout
  ], edges: [
    Edge(stdin, priv, EdgeType.boundary),
    Edge(priv, pub, EdgeType.oblivious),
    Edge(priv, pub, EdgeType.aware),
    Edge(pub, pub, EdgeType.aware),
    Edge(pub, pub, EdgeType.oblivious),
    Edge(pub, priv, EdgeType.aware),
    Edge(pub, stdout, EdgeType.boundary),
  ]);

// ---- TRIANGLE ----
  // final a = TagNode(Offset(100, 300), 'a');
  // final b = TagNode(Offset(200, 100), 'b');
  // final c = TagNode(Offset(300, 300), 'c');

  // return Policy(name: 'Policy 1', nodes: [
  //   a,
  //   b,
  //   c,
  // ], edges: [
  //   Edge(a, b, EdgeType.aware),
  //   Edge(b, c, EdgeType.oblivious),
  //   Edge(c, a, EdgeType.oblivious),
  //   Edge(a, a, EdgeType.aware),
  //   Edge(b, b, EdgeType.aware),
  //   // Edge(c, c, EdgeType.aware),
  // ]);
}

List<Policy> getMockPolicies() {
  // Node stdin1 = EntryNode(Offset(0, 0), 'stdin1');
  // Node x = TagNode(Offset(100, 100), 'X');
  // Node y = TagNode(Offset(100, 250), 'Y');

  // Edge stdinX = Edge(stdin1, x, EdgeType.boundary);
  // Edge xy = Edge(x, y, EdgeType.aware);

  // Policy p1 = Policy(name: 'Policy 1', nodes: [x, y, stdin1], edges: [xy, stdinX]);

  // Node stdin2 = EntryNode(Offset(0, 0), 'stdin2');
  // Node a = TagNode(Offset(100, 100), 'A');
  // Node b = TagNode(Offset(250, 100), 'B');
  // Node c = TagNode(Offset(400, 100), 'C');
  // Node d = TagNode(Offset(550, 100), 'D');

  // Edge stdin2A = Edge(stdin2, a, EdgeType.boundary);
  // Edge ab = Edge(a, b, EdgeType.oblivious);
  // Edge bc = Edge(b, c, EdgeType.oblivious);
  // Edge cd = Edge(c, d, EdgeType.oblivious);

  // Policy p2 = Policy(name: 'Policy 2', nodes: [a, b, c, d, stdin2], edges: [ab, bc, cd, stdin2A]);

  // return [p1, p2];
  return [];
}

List<Policy> getTensorDemoPolicies1() {
  Node stdinPol1 = EntryNode('stdin', Offset(100, 100));

  Node pub = TagNode('pub', Offset(200, 200));
  Node priv = TagNode('priv', Offset(400, 200));

  // All edges are oblivious
  Edge pubPriv = Edge(pub, priv, EdgeType.oblivious);
  Edge pubPub = Edge(pub, pub, EdgeType.oblivious);
  Edge privPriv = Edge(priv, priv, EdgeType.oblivious);
  Edge stdinPub = Edge(stdinPol1, pub, EdgeType.boundary);

  Policy p1 = Policy(name: 'Policy 1', nodes: [stdinPol1, pub, priv], edges: [pubPriv, pubPub, privPriv, stdinPub]);

  // same label as entry in pol1
  Node stdinPol2 = EntryNode('stdin', Offset(0, 0));

  Node low = TagNode('low', Offset(500, 100));
  Node high = TagNode('high', Offset(700, 100));

  Edge highLow = Edge(high, low, EdgeType.oblivious);
  Edge highHigh = Edge(high, high, EdgeType.oblivious);
  Edge lowLow = Edge(low, low, EdgeType.oblivious);
  Edge stdinLow = Edge(stdinPol2, low, EdgeType.boundary);

  Policy p2 = Policy(name: 'Policy 2', nodes: [high, low, stdinPol2], edges: [highLow, highHigh, lowLow, stdinLow]);

  return [p1, p2];
}

List<Policy> getTensorDemoPolicies2() {
  Node stdin1 = EntryNode('stdin', Offset(100, 100));

  Node pub = TagNode('pub', Offset(200, 200));
  Node priv = TagNode('priv', Offset(400, 200));

  Edge pubPriv = Edge(pub, priv, EdgeType.aware); // Aware!
  Edge pubPub = Edge(pub, pub, EdgeType.oblivious);
  Edge privPriv = Edge(priv, priv, EdgeType.oblivious);
  Edge stdinPub = Edge(stdin1, pub, EdgeType.boundary);

  Policy p1 = Policy(name: 'Policy 1', nodes: [stdin1, pub, priv], edges: [pubPriv, pubPub, privPriv, stdinPub]);

  Node stdin2 = EntryNode('stdin', Offset(0, 0));

  Node low = TagNode('low', Offset(500, 100));
  Node high = TagNode('high', Offset(700, 100));

  Edge highLow = Edge(high, low, EdgeType.oblivious);
  Edge highHigh = Edge(high, high, EdgeType.oblivious);
  Edge lowLow = Edge(low, low, EdgeType.oblivious);
  Edge stdinLow = Edge(stdin2, low, EdgeType.boundary);

  Policy p2 = Policy(name: 'Policy 2', nodes: [high, low, stdin2], edges: [highLow, highHigh, lowLow, stdinLow]);

  return [p1, p2];
}
