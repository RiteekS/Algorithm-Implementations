-- A point graph handler

-- This handler is devised for waypoints graphs.
-- waypoints are locations represented via labelled nodes
-- and are connected with edges having a positive weight.
-- It assumes edges are symmetric, that is if an edge exists
-- between a and b, weight(a -> b) ==  weight(b -> a)

-- Implements Node class (from node.lua)
local Node = require 'node'
function Node:initialize(name) self.name = name end
function Node:toString() return ('Node: %s'):format(self.name) end
function Node:isEqualTo(n) return self.name == n.name end

-- Internal graph data
local graph = {nodes = {}, edges = {}}

-- Looks for an edge between a and b.
local function find_edge(edges_list, a, b)
  for _, edge in ipairs(edges_list) do
    if (edge.from == a and edge.to == b)
    or (edge.from == b and edge.to == a)
    then
      return edge
    end
  end
end

-- Handler implementation
local handler = {}

-- Returns a Node
function handler.makeNode(name)
  return Node(name)
end

-- Returns the distance between node a and node b.
-- The distance should be the weight of the edge between the nodes
-- if existing, otherwise 0 (I could not figure anything better here).
function handler.distance(a, b)
  local e = find_edge(graph.edges, a, b)
  return e and e.weight or 0
end

-- Adds a new node labelled with name
function handler.addNode(name) graph.nodes[name] = Node(name) end

-- Adds a new edge between nodes labelled from and to
function handler.addEdge(from, to, weight)
  table.insert(graph.edges,
    {from = graph.nodes[from], to = graph.nodes[to], weight = weight})
end

-- Sets the weight of edge from -> to
function handler.setEdgeWeight(from, to, weight)
  local e = find_edge(graph.edges, graph.nodes[from], graph.nodes[to])
  if e then e.weight = weight end
end

-- Returns an array of neighbors of node n
function handler.getNeighbors(n)
  local neighbors = {}
  for _, edge in ipairs(graph.edges) do
    if edge.from == n then
      table.insert(neighbors, edge.to)
    elseif edge.to == n then
      table.insert(neighbors, edge.from)
    end
  end
  return neighbors
end

return handler
