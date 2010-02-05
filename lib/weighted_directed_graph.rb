require 'set'

class WeightedDirectedGraph
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
    count = 0
    @vertices.values.select{|v| v.spout && count+=1}[(count * rand).to_i].value
  end
  
  def connect(a, b, weight=1)
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
    @vertices[name].outgoing.size
  end
end

class Vertex
  attr_accessor :outgoing, :incoming
  attr_reader :value, :sink, :spout
  
  def initialize(value)
    @value = value
    # memoize hash
    @hash = @value.hash
    @outgoing = Set.new
    @incoming = Set.new
    @sink = true
    @spout = true
  end
  
  def eql?(other)
    return false unless other.is_a? Vertex
    @value == other.value
  end
  
  def hash
    @hash
  end
  
  def endpoint?
    @outgoing.size == 0
  end
  
  def random_jump(visited)
    largest = 0
    current = nil
    @outgoing.each do |edge|
      val = edge.weight * rand
      node = edge.destination
      # make weight less and less noticable if we continually visit the node
      # this also prevents cycles from happening
      val = val - (rand * 2 * visited[node]) if visited[node]
      if val > largest
        largest = val
        current = edge
      end
    end
    current && current.destination
  end
  
  def add_outgoing_edge(edge)
    @outgoing.add(edge)
    @sink = false
  end
  
  def add_incoming_edge(edge)
    @incoming.add(edge)
    @spout = false
  end
end

class DirectedEdge
  attr_accessor :weight
  attr_reader :origin, :destination
  
  def initialize(origin, destination, weight = 1)
    @origin = origin
    @destination = destination
    # memoize hash
    @hash = "#{@origin.value}#{@destination.value}".hash
    @weight = weight
  end

  def connect
    @origin.add_outgoing_edge(self)
    @destination.add_incoming_edge(self)
  end

  def eql?(other)
    return false unless other.is_a? DirectedEdge
    @origin.eql?(other.origin) && @destination.eql?(other.destination)
  end
  
  def hash
    @hash
  end
end