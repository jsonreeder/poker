class Player
  attr_reader :bankroll, :hand, :change

  def initialize(bankroll)
    @bankroll = bankroll
    @hand = []
    @bet = 0
  end

  def deal_in(hand)
    @hand = hand
  end

  def take_bet(amount)
    change = amount - @bet
    raise 'not enough money' if bankroll - change < 0
    @bet += amount
    @bankroll -= change
    change
  end

  def self.buy_in(bankroll)
    Player.new(bankroll)
  end
end
