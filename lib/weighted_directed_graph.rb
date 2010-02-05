require 'set'

class WeightedDirectedGraph
  attr_accessor :edges, :vertices
  
  def initialize
    @vertices = Hash.new
    @edges = Hash.new
  end
  
  def add_node(name)
    @vertices[name] ||= Vertex.new(name)
  end
  
  def [](name)
    @vertices[name]
  end
  
  def random_node
    @vertices.keys[(@vertices.size * rand).to_i]
  end
  
  def connect(a,b,weight=1)
    e = DirectedEdge.new(self[a], self[b], weight)
    @edges[e] ||= e
    @edges[e].connect
  end
  
  def edge(a, b)
    @edges[DirectedEdge.new(self[a], self[b])]
  end
  
  def edge_weight(a,b)
    e = DirectedEdge.new(self[a], self[b])
    @edges[e] && @edges[e].weight
  end
  
  def contains?(name)
    @vertices[name]
  end
  
  def out_degree_of(name)
    @vertices[name].edges.size
  end
end

class Vertex
  attr_accessor :value, :edges
  
  def initialize(value)
    @value = value
    @edges = Set.new
  end
  
  def eql?(other)
    return false unless other.is_a? Vertex
    @value == other.value
  end
  
  def hash
    @value.hash
  end
  
  def endpoint?
    @edges.size == 0
  end
  
  def random_jump(visited)
    largest = 0
    current = nil
    @edges.each do |edge|
      val = edge.weight * rand
      node = edge.destination
      # make weight less and less noticable if we continually visit the node
      val = val - (rand * visited[node]) if visited[node]
      if val > largest
        largest = val
        current = edge
      end
    end
    current && current.destination
  end
end

class DirectedEdge
  attr_accessor :weight, :origin, :destination
  
  def initialize(origin, destination, weight = 1)
    @origin = origin
    @destination = destination
    @weight = weight
  end

  def connect
    @origin.edges.add(self)
  end

  def eql?(other)
    return false unless other.is_a? DirectedEdge
    @origin.eql?(other.origin) && @destination.eql?(other.destination)
  end
  
  def hash
    (@origin.value + @destination.value).hash
  end
end