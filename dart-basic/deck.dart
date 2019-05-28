void main() {
  var deck = new Deck();
  //deck.shuffle();
  //print(deck.cardsWidthSuit('Clubs'));
  print(deck);
  print(deck.deal(5));
  print(deck);
}

class Deck {
  List<Card> cards = [];

  Deck() {
    var suits = ['Diamonds', 'Hearts', 'Clubs', 'Spades'];
    var ranks = ['1', '2', '3', '4', '5'];

    for (var mySuit in suits) {
      for (var myRank in ranks) {
        var card = new Card(
          rank: myRank,
          suit: mySuit,
        );
        cards.add(card);
      }
    }
  }

  toString() {
    return cards.toString();
  }

  shuffle() {
    cards.shuffle();
  }

  cardsWidthSuit(String suit) {
    return cards.where((card) => card.suit == suit);
  }

  deal(int handSize) {
    var hand = cards.sublist(0, handSize);
    cards = cards.sublist(handSize);
    return hand;
  }

  removeCard(String suit, String rank) {
    cards.removeWhere((card) => (card.suit == suit) && (card.rank == rank));
  }
}

class Card {
  String suit;
  String rank;

  Card({this.suit, this.rank});

  toString() {
    return '$rank of $suit';
  }
}
