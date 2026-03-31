Class {
	#name : 'TripSettlementServiceTest',
	#superclass : 'TestCase',
	#instVars : [
		'alice',
		'bob',
		'charlie'
	],
	#category : 'TripExpenses-Domain-Tests',
	#package : 'TripExpenses-Domain-Tests'
}

{ #category : 'running' }
TripSettlementServiceTest >> balances: aDict [
    "Helper : convertit Participant->Number en Participant->Money"
    | result |
    result := Dictionary new.
    aDict keysAndValuesDo: [ :p :n |
        result at: p put: (Money amount: n currency: 'EUR') ].
    ^ result
]

{ #category : 'running' }
TripSettlementServiceTest >> setUp [
    alice   := Participant name: 'Alice'.
    bob     := Participant name: 'Bob'.
    charlie := Participant name: 'Charlie'
]

{ #category : 'running' }
TripSettlementServiceTest >> testAllSettlementAmountsArePositive [
    | settlements |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 40. bob -> 20. charlie -> -30. (Participant name: 'Dave') -> -30 } asDictionary).
    settlements do: [ :s |
        self assert: s amount amount > 0 ]
]

{ #category : 'running' }
TripSettlementServiceTest >> testAllZeroBalancesProducesNoSettlements [
    | settlements |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 0. bob -> 0. charlie -> 0 } asDictionary).
    self assert: settlements isEmpty
]

{ #category : 'running' }
TripSettlementServiceTest >> testDebtorPaysCreditor [
    | settlements s |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 100. bob -> -100 } asDictionary).
    s := settlements first.
    self assert: s from equals: bob.
    self assert: s to   equals: alice
]

{ #category : 'running' }
TripSettlementServiceTest >> testEmptyBalancesProducesNoSettlements [ 
    self assert: (TripSettlementService settleFor: Dictionary new) isEmpty
]

{ #category : 'running' }
TripSettlementServiceTest >> testGreedyMinimizesTransactions [
    "3 participants : 1 créditeur, 2 débiteurs → 2 transactions max"
    | settlements |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 60. bob -> -30. charlie -> -30 } asDictionary).
    self assert: settlements size equals: 2
]

{ #category : 'running' }
TripSettlementServiceTest >> testGreedyOneTransactionWhenPossible [
    "Soldes parfaitement symétriques → 1 seule transaction"
    | settlements |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 50. bob -> -50 } asDictionary).
    self assert: settlements size equals: 1
]

{ #category : 'running' }
TripSettlementServiceTest >> testGreedyPartialPayment [
    "Créditeur plus grand que débiteur → transaction partielle"
    | settlements |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 100. bob -> -30. charlie -> -70 } asDictionary).
    self assert: settlements size equals: 2.
    self assert: (settlements sumNumbers: [ :s | s amount amount ]) equals: 100
]

{ #category : 'running' }
TripSettlementServiceTest >> testNoSettlementFromCreditorToCreditor [
    | settlements |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 30. bob -> 30. charlie -> -60 } asDictionary).
    settlements do: [ :s |
        self deny: s from equals: alice.
        self deny: s from equals: bob ]
]

{ #category : 'running' }
TripSettlementServiceTest >> testNoSettlementToDebtorFromDebtor [
    | settlements |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 60. bob -> -20. charlie -> -40 } asDictionary).
    settlements do: [ :s |
        self deny: s to equals: bob.
        self deny: s to equals: charlie ]
]

{ #category : 'running' }
TripSettlementServiceTest >> testOneCreditorOneDebtor [
    | settlements s |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 30. bob -> -30 } asDictionary).
    self assert: settlements size equals: 1.
    s := settlements first.
    self assert: s from   equals: bob.
    self assert: s to     equals: alice.
    self assert: s amount equals: (Money amount: 30 currency: 'EUR')
]

{ #category : 'running' }
TripSettlementServiceTest >> testOneCreditorTwoDebtors [
    | settlements |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 60. bob -> -30. charlie -> -30 } asDictionary).
    self assert: settlements size equals: 2.
    settlements do: [ :s |
        self assert: s to     equals: alice.
        self assert: s amount equals: (Money amount: 30 currency: 'EUR') ]
]

{ #category : 'running' }
TripSettlementServiceTest >> testSettlementFields [
    | settlements s |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 30. bob -> -30 } asDictionary).
    s := settlements first.
    self assert: (s isKindOf: Settlement).
    self assert: s from   isNotNil.
    self assert: s to     isNotNil.
    self assert: s amount isNotNil
]

{ #category : 'running' }
TripSettlementServiceTest >> testSettlementPrintString [
    | settlements s |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 30. bob -> -30 } asDictionary).
    s := settlements first.
    self assert: (s printString includesSubstring: 'Bob').
    self assert: (s printString includesSubstring: 'Alice').
    self assert: (s printString includesSubstring: '30')
]

{ #category : 'running' }
TripSettlementServiceTest >> testSettlementsSumEqualsTotalDebts [
    | settlements totalDebts |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 50. bob -> 10. charlie -> -60 } asDictionary).
    totalDebts := settlements sumNumbers: [ :s | s amount amount ].
    self assert: totalDebts equals: 60
]

{ #category : 'running' }
TripSettlementServiceTest >> testSingleParticipantZeroProducesNoSettlements [
    | settlements |
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 0 } asDictionary).
    self assert: settlements isEmpty
]

{ #category : 'running' }
TripSettlementServiceTest >> testTwoCreditorsTwoDebtors [
    | dave settlements |
    dave := Participant name: 'Dave'.
    settlements := TripSettlementService settleFor: (self balances: {
        alice -> 40. bob -> 20. charlie -> -30. dave -> -30 } asDictionary).
    self assert: settlements size equals: 3.
    self assert: (settlements sumNumbers: [ :s | s amount amount ]) equals: 60
]
