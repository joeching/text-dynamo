require File.dirname(__FILE__) + '/markov_chain'

class TextGenerator
  attr_reader :markov_chain
  
  def initialize
    @markov_chain = MarkovChain.new
  end
  
  def seed(text)
    sentences(text).each do |sentence|
      words = sentence.split
      if words.size > 1 && words.last =~ /[\.!\?]/
        # skip one word sentences and sentences that don't end in a period, exclamation mark, or question mark
        words.each_with_index do |x,i|
          y = words[i+1]
          @markov_chain.increment_probability(x, y) if y
        end
      end
    end
  end
  
  def sentences(text)
    text.gsub(/[\r\n]{4,4}?/, '. ').gsub(/[\r\n]{2,2}?\s*/, ' ').split(/\B\s+(?=[A-Z])/)
  end
  
  def generate(start)
    @markov_chain.random_walk(start).join(" ")
  end
end