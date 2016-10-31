//: Poker - noun: a card game played by two or more people who bet on the value of the hands dealt to them.

import UIKit

// ♥️♣️♦️♠️ //

/*
 
 ♠ ♥ ♦ ♣
 
 The first challenge for any novice poker player is figuring out how to evaluate any given hand, and understanding how strong it is within the spectrum of all possible hands.

 Your task: write a method that accepts as input an array of 7 arbitrary cards (from a standard 52-card deck) and returns the best 5-card poker hand, as well as the name of that hand


 For example, an input of [8♦ 3♠ 5♦ 8♣ J♦ 3♦ 2♦] should return the output [J♦ 8♦ 5♦ 3♦ 2♦] and "Flush"
 See https://en.wikipedia.org/wiki/List_of_poker_hand_categories for a list and ranking of poker hands
 
 */


// Custom types for representing Suit, Rank, Hand and Card

enum Suit: Character {
    case Spade = "\u{2660}"
    case Club = "\u{2663}"
    case Heart = "\u{2665}"
    case Diamond = "\u{2666}"
}

enum Rank: Int, Comparable {
    
    public static func <(lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    public static func <=(lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    public static func >(lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
    
    public static func >=(lhs: Rank, rhs: Rank) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
    
    case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten, J, Q, K, A
}

enum Hand: String {
    case RoyalFlush = "Royal Flush"
    case StraightFlush = "Straight Flush"
    case FourOfAKind = "Four Of A Kind"
    case FullHouse = "Full House"
    case Flush
    case Straight
    case ThreeOfAKind = "Three Of A Kind"
    case TwoPair = "Two Pair"
    case OnePair = "One Pair"
    case HighCard = "High Card"
}

struct Card: Equatable, Comparable {
    
    public static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.rank == rhs.rank && lhs.suit == rhs.suit
    }
    
    public static func <(lhs: Card, rhs: Card) -> Bool {
        return lhs.rank < rhs.rank
    }
    
    public static func <=(lhs: Card, rhs: Card) -> Bool {
        return lhs.rank <= rhs.rank
    }
    
    public static func >=(lhs: Card, rhs: Card) -> Bool {
        return lhs.rank >= rhs.rank
    }
    
    public static func >(lhs: Card, rhs: Card) -> Bool {
        return lhs.rank > rhs.rank
    }
    
    let rank: Rank
    let suit: Suit
    
    init(rank: Int, suit: Character) {
        self.rank = Rank(rawValue: rank)!
        self.suit = Suit(rawValue: suit)!
    }
    
    
}


// Main function

public func findTheBestPokerHand(input: [String]) {
    
    // Converting input of strings into array of Cards
    
    var inputCards: [Card] = []
    
    for card in input {
        guard let suit = card.characters.last else {
            print("Invalid suit")
            break
        }
        
        let rank = card.characters.dropLast()
        if let intRank = Int(String(rank)) {
            inputCards.append(Card(rank: intRank, suit: suit))
        } else {
            switch String(rank) {
            case "A":
                inputCards.append(Card(rank: 14, suit: suit))
            case "K":
                inputCards.append(Card(rank: 13, suit: suit))
            case "Q":
                inputCards.append(Card(rank: 12, suit: suit))
            case "J":
                inputCards.append(Card(rank: 11, suit: suit))
            default:
                print("Could not recognize the rank")
            }
        }
    }
    
    
    // Computing number of cards for a suit and count of ranks
    
    var spadeCards: [Int] = []
    var clubCards: [Int] = []
    var diamondCards: [Int] = []
    var heartCards: [Int] = []
    
    var suitCount: [Suit : Int] = [:]
    
    var rCount: [Int] = Array(repeating: 0, count: 15)
    
    
    // Probably use filter
    for card in inputCards {
        switch card.suit {
        case .Spade:
            spadeCards.append(card.rank.rawValue)
            spadeCards.sort()
        case .Club:
            clubCards.append(card.rank.rawValue)
            clubCards.sort()
        case .Diamond:
            diamondCards.append(card.rank.rawValue)
            diamondCards.sort()
        case .Heart:
            heartCards.append(card.rank.rawValue)
            heartCards.sort()
        }
    }
    
    for card in inputCards {
        switch card.rank {
        case .Two:
            rCount[Rank.Two.rawValue] += 1
        case .Three:
            rCount[Rank.Three.rawValue] += 1
        case .Four:
            rCount[Rank.Four.rawValue] += 1
        case .Five:
            rCount[Rank.Five.rawValue] += 1
        case .Six:
            rCount[Rank.Six.rawValue] += 1
        case .Seven:
            rCount[Rank.Seven.rawValue] += 1
        case .Eight:
            rCount[Rank.Eight.rawValue] += 1
        case .Nine:
            rCount[Rank.Nine.rawValue] += 1
        case .Ten:
            rCount[Rank.Ten.rawValue] += 1
        case .J:
            rCount[Rank.J.rawValue] += 1
        case .Q:
            rCount[Rank.Q.rawValue] += 1
        case .K:
            rCount[Rank.K.rawValue] += 1
        case .A:
            rCount[Rank.A.rawValue] += 1
        }
    }
    
    suitCount[.Spade] = spadeCards.count
    suitCount[.Club] = clubCards.count
    suitCount[.Diamond] = diamondCards.count
    suitCount[.Heart] = heartCards.count
    
    
    // Helper functions
    
    func getCardWithRank(rank: Int, suit: Suit? = nil) -> Card? {
        
        for x in inputCards {
            if (suit != nil) {
                if x.rank.rawValue == rank && x.suit == suit {
                    return x
                }
            } else if x.rank.rawValue == rank {
                return x
            }
        }
        
        return nil
    }
    
    
    func getSuitWithHighestCount() -> (suit: Suit?, count: Int) {
        var highestCount: (Suit?, Int) = (nil, 0)
        
        for (k, v) in suitCount {
            if v >= highestCount.1 {
                highestCount = (k, v)
            }
        }
        
        return highestCount
    }
    
    
    func getAllCardsForASuit(suit: Suit) -> [Card] {
        let allCards: [Card] = inputCards.filter{ $0.suit == suit }
        
        /*
        switch suit {
        case .Club:
            for x in clubCards {
                allCards.append(getCardWithRank(rank: x, suit: .Club)!)
            }
        case .Diamond:
            for x in diamondCards {
                allCards.append(getCardWithRank(rank: x, suit: .Diamond)!)
            }
        case .Heart:
            for x in heartCards {
                allCards.append(getCardWithRank(rank: x, suit: .Heart)!)
            }
        case .Spade:
            for x in spadeCards {
                allCards.append(getCardWithRank(rank: x, suit: .Spade)!)
            }
        }
        */
        
        return allCards
    }
    
    
    func getRankWithHighestCount() -> (rank: Rank?, count: Int) {
        var highestCount = 0
        var highestRankCount: (Rank?, Int) = (nil, 0)
        
        for (rank, count) in rCount.enumerated() {
            if count >= highestCount {
                highestCount = count
                highestRankCount = (Rank(rawValue: rank), count)
            }
        }
        
        return highestRankCount
    }
    
    
    func getAllCardsForARank(rank: Rank) -> [Card] {
        var allCards: [Card] = []
        
        switch rank {
        case .Two:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        case .Three:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        case .Four:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        case .Five:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        case .Six:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        case .Seven:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        case .Eight:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        case .Nine:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        case .Ten:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        case .J:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        case .Q:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        case .K:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        case .A:
            for x in inputCards {
                if x.rank == rank {
                    allCards.append(x)
                }
            }
        }
        
        return allCards
    }
    
    
    func fillInKickers(setOfCards: [Card]) -> [Card] {
        var kickers: [Card] = []
        var fullHand = setOfCards
        
        for x in inputCards {
            if !(fullHand.contains(x)){
                kickers.append(x)
            }
        }
        
        let sortedKickers = kickers.sorted().reversed()
        
        for x in sortedKickers {
            if fullHand.count < 5 {
                fullHand.append(x)
            }
        }
        
        return fullHand
    }
    
    
    // Functions for checking hand types
    
    func fourOfAKind() -> (fourOfAKind: Bool, winningHand: [Card], handType: Hand?) {
        let highest = getRankWithHighestCount()
        let highestRank = highest.rank!
        let highestCount = highest.count
        var fourOfAKindHand: [Card] = []
        
        if highestCount == 4 {
            fourOfAKindHand = getAllCardsForARank(rank: highestRank)
            fourOfAKindHand = fillInKickers(setOfCards: fourOfAKindHand)
        } else {
            return (false, fourOfAKindHand, nil)
        }
        
        return (true, fourOfAKindHand, Hand.FourOfAKind)
    }
    
    func threeOfAKind() -> (threeOfAKind: Bool, winningHand: [Card], handType: Hand?) {
        var isThreeOfAKind = false
        var largestThreeCount = 0
        var threeCards: [Card] = []
        var threeOfAKindHand: [Card] = []
        
        for (rank, count) in rCount.enumerated() {
            if count == 3 {
                largestThreeCount = rank
            }
        }
        
        if (largestThreeCount != 0) {
            threeCards = getAllCardsForARank(rank: Rank(rawValue: largestThreeCount)!)
            threeOfAKindHand = fillInKickers(setOfCards: threeCards)
            isThreeOfAKind = true
        } else {
            return (isThreeOfAKind, threeOfAKindHand, nil)
        }
        
        return (isThreeOfAKind, threeOfAKindHand, Hand.ThreeOfAKind)
    }
    
    func onePair() -> (onePair: Bool, winningHand: [Card], handType: Hand?) {
        var isOnePair = false
        var largestTwoCount = 0
        var twoCards: [Card] = []
        var onePairHand: [Card] = []
        
        for (rank, count) in rCount.enumerated() {
            if count == 2 {
                largestTwoCount = rank
            }
        }
        
        if (largestTwoCount != 0) {
            twoCards = getAllCardsForARank(rank: Rank(rawValue: largestTwoCount)!)
            onePairHand = fillInKickers(setOfCards: twoCards)
            isOnePair = true
        } else {
            return (isOnePair, onePairHand, nil)
        }
        
        return (isOnePair, onePairHand, Hand.OnePair)
        
    }
    
    func fullHouse() -> (fullHouse: Bool, winningHand: [Card], handType: Hand?) {
        var isFullHouse: Bool = false
        var largestThreeCount = 0
        var largestTwoCount = 0
        var threeCards: [Card] = []
        var twoCards: [Card] = []
        var fullHouseHand: [Card] = []
        
        for (rank, count) in rCount.enumerated() {
            if count == 3 {
                largestThreeCount = rank
            } else if count == 2 {
                largestTwoCount = rank
            }
        }
        
        if (largestThreeCount != 0) && (largestTwoCount != 0) {
            threeCards = getAllCardsForARank(rank: Rank(rawValue: largestThreeCount)!)
            twoCards = getAllCardsForARank(rank: Rank(rawValue: largestTwoCount)!)
            
            fullHouseHand = threeCards + twoCards
            isFullHouse = true
        } else {
            return (isFullHouse, fullHouseHand, nil)
        }
        
        return (isFullHouse, fullHouseHand, Hand.FullHouse)
    }
    
    func flush() -> (flush: Bool, winningHand: [Card], handType: Hand?) {
        var isFlush = false
        let highestSuitCount = getSuitWithHighestCount()
        var flushHand: [Card] = []
        
        if highestSuitCount.count >= 5 {
            isFlush = true
            if let suit = highestSuitCount.suit {
                var flushCards = getAllCardsForASuit(suit: suit)
                flushCards = flushCards.sorted().reversed()
                
                for x in flushCards {
                    if flushHand.count < 5 {
                        flushHand.append(x)
                    }
                }
            }
        } else {
            return (isFlush, flushHand, nil)
        }
        
        return (isFlush, flushHand, Hand.Flush)
    }
    
    func straight() -> (straight: Bool, winningHand: [Card], handType: Hand?) {
        var isStraight = false
        var sequenceCount = 0
        var count = 0
        var sequenceEndsAt = 0
        let highestSuitCount = getSuitWithHighestCount()
        var straightHand: [Card] = []
        
        for x in 2..<rCount.endIndex {
            if rCount[x] >= 1 {
                count += 1
                if count >= sequenceCount {
                    sequenceCount = count
                    sequenceEndsAt = x
                }
            } else if rCount[x] == 0 {
                count = 0
            }
        }
        
        if sequenceCount >= 5 {
            isStraight = true
            
            let start = (sequenceEndsAt - 5) + 1
            
            for x in start...sequenceEndsAt {
                
                if rCount[x] > 1 {
                    if let splSuit = highestSuitCount.suit {
                        if let card = getCardWithRank(rank: x, suit: splSuit) {
                            straightHand.append(card)
                        }
                    }
                } else if let card = getCardWithRank(rank: x) {
                    straightHand.append(card)
                }
                
            }
        } else {
            return (isStraight, straightHand, nil)
        }
        
        return (isStraight, straightHand.sorted().reversed(), Hand.Straight)
    }
    
    
    func straightFlush() -> (straight: Bool, winningHand: [Card], handType: Hand?) {
        var isStraightFlush = false
        let isFlush = flush()
        var straightFlushHand: [Card] = []
        
        if isFlush.flush {
            let hand = isFlush.winningHand
            let high = (hand.first?.rank.rawValue)!
            let low = (hand.last?.rank.rawValue)!
            let diff = (high - low)
            
            if diff == 4 {
                straightFlushHand = hand
                isStraightFlush = true
                
                if low == 10 {
                    return (isStraightFlush, straightFlushHand, Hand.RoyalFlush)
                }
            }
        } else {
            return (isStraightFlush, straightFlushHand, nil)
        }
        
        return (isStraightFlush, straightFlushHand, Hand.StraightFlush)
    }
    
    
    func twoPair() -> (isTwoPair: Bool, winningHand: [Card], handType: Hand?) {
        var isTwoPair: Bool = false
        var twoPairHand: [Card] = []
        var pairOne: [Card] = []
        var pairTwo: [Card] = []
        var twoPairCount = 0
        var firstPair = 0
        var secondPair = 0
        
        for x in rCount {
            if x == 2 {
                twoPairCount += 1
            }
        }
        
        if twoPairCount >= 2 {
            for (rank, count) in rCount.enumerated() {
                if count == 2 {
                    firstPair = secondPair
                    secondPair = rank
                }
            }
        }
        
        if (firstPair != 0) && (secondPair != 0) {
            pairOne = getAllCardsForARank(rank: Rank(rawValue: firstPair)!)
            pairTwo = getAllCardsForARank(rank: Rank(rawValue: secondPair)!)
            
            twoPairHand = pairOne + pairTwo
            twoPairHand = fillInKickers(setOfCards: twoPairHand)
            
            isTwoPair = true
        } else {
            return (isTwoPair, twoPairHand, nil)
        }
        
        
        return (isTwoPair, twoPairHand, Hand.TwoPair)
    }
    
    
    func highCard() -> (isHighCard: Bool, winningHand: [Card], handType: Hand) {
        let sorted: [Card] = inputCards.sorted().reversed()
        var highCard: [Card] = []
        
        for x in sorted {
            if highCard.count < 5 {
                highCard.append(x)
            }
        }
        
        return (true, highCard, Hand.HighCard)
    }
    
    
    // Determining the best hand
    
    func bestHand() -> (hand: [Card], handType: Hand?) {
        
        let checkStraightFlush = straightFlush()
        let checkFourOfAKind = fourOfAKind()
        let checkFullHouse = fullHouse()
        let checkFlush = flush()
        let checkStraight = straight()
        let checkThreeOfAKind = threeOfAKind()
        let checkTwoPair = twoPair()
        let checkOnePair = onePair()
        let checkHighCard = highCard()
        
        if checkStraightFlush.straight {
            return (checkStraightFlush.winningHand, checkStraightFlush.handType)
        } else if checkFourOfAKind.fourOfAKind {
            return (checkFourOfAKind.winningHand, checkFourOfAKind.handType)
        } else if checkFullHouse.fullHouse {
            return (checkFullHouse.winningHand, checkFullHouse.handType)
        } else if checkFlush.flush {
            return (checkFlush.winningHand, checkFlush.handType)
        } else if checkStraight.straight {
            return (checkStraight.winningHand, checkStraight.handType)
        } else if checkThreeOfAKind.threeOfAKind {
            return (checkThreeOfAKind.winningHand, checkThreeOfAKind.handType)
        } else if checkTwoPair.isTwoPair {
            return (checkTwoPair.winningHand, checkTwoPair.handType)
        } else if checkOnePair.onePair {
            return (checkOnePair.winningHand, checkOnePair.handType)
        }
        
        return (checkHighCard.winningHand, Hand.HighCard)
    }
    
    
    // Formatting the best hand to match the required output
    
    func printBestHand() {
        let theBestHand = bestHand()
        var outputRank = ""
        var output: [String] = []
        var outputType = ""
        
        if let bestType = theBestHand.handType {
            outputType = bestType.rawValue
            for x in theBestHand.hand {
                if x.rank.rawValue > 10 {
                    outputRank = "\(x.rank)"
                } else {
                    outputRank = "\(x.rank.rawValue)"
                }
                let suit = x.suit.rawValue
                
                let finalCard = "\(outputRank)\(suit)"
                
                output.append(finalCard)
            }
        }
        
        print(output)
        print(outputType)
    }


    printBestHand()
}

//let A = ["8♦", "3♠", "5♦", "8♣", "J♦", "3♦", "2♦"] // Flush
//let A = ["3♦", "7♣", "6♣", "4♣", "A♠", "7♦", "4♠"] // Two pair
//let A = ["10♦", "9♠", "8♥", "7♦", "6♣", "2♦", "J♠"] // Straight
//let A = ["10♣", "9♣", "8♣", "7♣", "4♥", "2♦", "J♣"] // Straight flush clubs
//let A = ["10♥", "Q♥", "A♥", "2♠", "4♦", "K♥", "J♥"] // Royal flush hearts
//let A = ["5♣", "5♠", "5♦", "8♣", "J♦", "3♦", "5♥"] // Four of a kind
//let A = ["5♣", "5♠", "5♦", "8♣", "J♦", "3♦", "8♥"] // Full house
//let A = ["8♦", "6♦", "4♦", "10♥", "Q♣", "3♦", "7♠"] // High card
//let A = ["A♦", "6♣", "4♦", "4♥", "Q♦", "3♦", "2♠"] // One pair
//let A = ["5♣", "5♠", "5♦", "8♣", "J♦", "3♦", "4♥"] // Three of a kind

let A = ["8♦", "3♠", "5♦", "8♣", "J♦", "3♦", "2♦"]

findTheBestPokerHand(input: A)
