require File.dirname(__FILE__) + '/weighted_directed_graph'

class MarkovChain
  attr_accessor :graph
  
  def initialize
    @graph = WeightedDirectedGraph.new
  end
  
  def increment_probability(a,b)
    @graph.add_node(a)
    @graph.add_node(b)
    @graph.connect(a,b,0)
    edge = @graph.edge(a, b)
    edge.weight = edge.weight + 1
  end

  def random_walk(start = nil)
    visited = Hash.new
    start = @graph.random_node unless start
    walk = []
    thenext = @graph[start]
    while(thenext) do
      walk.push(thenext.value)
      thenext = thenext.random_jump(visited)
      visited[thenext] = (visited[thenext] || 0) + 1
    end
    walk
  end
end