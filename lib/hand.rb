require 'byebug'
class Hand
  RANKS = [
    :royal_flush,
    :straight_flush,
    :four_of_a_kind,
    :full_house,
    :flush,
    :straight,
    :three_of_a_kind,
    :two_pair,
    :one_pair,
    :high_card
  ]

  attr_reader :cards

  def initialize(cards)
    raise 'must have five cards' unless cards.length == 5
    @cards = cards
  end

  def trade_cards(discard_cs, receive_cs)
    raise 'must have five cards' unless discard_cs.length == receive_cs.length
    raise 'cannot discard unowned card' unless discard_cs.all? do |c|
      @cards.include?(c)
    end

    discard_cs.each { |card| @cards.delete(card) }
    @cards.concat(receive_cs)
  end

  def rank
    return :royal_flush if royal? && flush?
    return :straight_flush if straight? && flush?
    return :four_of_a_kind if four_of_a_kind?
  end

  def <=>(other)
    case RANKS.index(rank) <=> RANKS.index(other.rank)
    when -1
      -1
    when 0
      @cards.max <=> other.cards.max
    when 1
      1
    end
  end

  protected

  def suits
    @cards.map(&:suit)
  end

  def value_ranks
    @cards.map(&:value_rank).sort
  end

  def flush?
    suits.uniq.length == 1
  end

  def straight?
    lowest = value_ranks.min
    sequence = (lowest..(lowest + 4)).to_a
    value_ranks == sequence
  end

  def royal?
    value_ranks.all? { |v| v >= 10 }
  end

  def count_vals
    vals = Hash.new { |h, k| h[k] = 0 }
    value_ranks.each { |rank| vals[rank] += 1 }
    vals
  end

  def four_of_a_kind?
    count_vals.values.sort == [1, 4]
  end

end
