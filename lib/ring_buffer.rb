require_relative "static_array"

class RingBuffer

  attr_reader :length

  def initialize
    @store = StaticArray.new(1)
    @capacity = 1
    @length = 0
    @start_idx = 0
  end

  def[](idx)
    check_bounds(idx)
    @store[(@start_idx + idx) % @capacity]
  end

  def[]=(idx, value)
    check_bounds(idx)
    @store[(@start_idx + idx) % @capacity] = value
    @store[(@start_idx + idx) % @capacity]
  end

  def push(item)
    if @capacity <= @length
      old_store = @store
      resize

      (0...@length).each do |idx|
        @store[idx] = old_store[idx]
      end
    end

    @store[@length] = item
    @length += 1
    @store
  end

  def pop
    return nil if @length < 1

    @length -= 1
    @store[@length]
  end

  def shift
    return nil if @length < 1

    old_store = @store
    @length -= 1

    #omits the 0th element of the old store
    (1..@length).each do |idx|
      @store[idx - 1] = old_store[idx]
    end

    old_store[0] #element to be removed
  end

  def unshift(item)
    old_store = @store
    resize if @capacity <= @length

    @store[0] = item
    (0...@length).each do |idx|
      @store[idx + 1] = old_store[idx]
    end

    @length += 1
    @store
  end

  private


  def check_bounds(index)
    if (index >= 0) && (index < @length)
      true
    elsif (index < 0) && (index.abs <= @length)
      true
    else
      raise "index out of bounds"
    end
  end

  def resize
    @capacity *= 2
    @store = StaticArray.new(@capacity)
  end

end
