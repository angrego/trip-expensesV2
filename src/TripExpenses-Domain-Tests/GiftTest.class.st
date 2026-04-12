Class {
	#name : 'GiftTest',
	#superclass : 'TestCase',
	#instVars : [
		'alice',
		'bob',
		'splitRule'
	],
	#category : 'TripExpenses-Domain-Tests-TripExpenses-Domain-Tests-Rule',
	#package : 'TripExpenses-Domain-Tests',
	#tag : 'TripExpenses-Domain-Tests-Rule'
}

{ #category : 'running' }
GiftTest >> expensePayedByAlice [
    ^ Expense
        description: 'Test'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: { Payment participant: alice amount: (Money amount: 100 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today
]

{ #category : 'running' }
GiftTest >> setUp [ 
    alice := Participant name: 'Alice'.
    bob   := Participant name: 'Bob'.
    splitRule := EqualSplitRule among: {
        ParticipantWeight participant: alice.
        ParticipantWeight participant: bob }
]

{ #category : 'running' }
GiftTest >> testCreation [
    | g |
    g := Gift from: alice to: bob amount: (Money amount: 20 currency: 'EUR').
    self assert: g from   equals: alice.
    self assert: g to     equals: bob.
    self assert: g amount equals: (Money amount: 20 currency: 'EUR')
]

{ #category : 'running' }
GiftTest >> testCreationWithReason [
    | g |
    g := Gift
        from: alice
        to: bob
        amount: (Money amount: 20 currency: 'EUR')
        reason: 'Cadeau anniversaire'.
    self assert: g reason equals: 'Cadeau anniversaire'
]

{ #category : 'running' }
GiftTest >> testDefaultReasonIsEmpty [
    | g |
    g := Gift from: alice to: bob amount: (Money amount: 20 currency: 'EUR').
    self assert: g reason isEmpty
]

{ #category : 'running' }
GiftTest >> testGiftExactlySurplusIsValid [
    "Alice paie 100, part 50, surplus exactement 50 → valide"
    self shouldnt: [
        Expense
            description: 'Test'
            totalAmount: (Money amount: 100 currency: 'EUR')
            payments: { Payment participant: alice amount: (Money amount: 100 currency: 'EUR') }
            splitRule: splitRule
            gifts: { Gift from: alice to: bob amount: (Money amount: 50 currency: 'EUR') }
            date: Date today
    ] raise: Error
]

{ #category : 'running' }
GiftTest >> testGiftExceedingSurplusRaisesError [
    "Alice paie 100, part 50, surplus 50 → ne peut pas offrir 60"
    self should: [
        Expense
            description: 'Test'
            totalAmount: (Money amount: 100 currency: 'EUR')
            payments: { Payment participant: alice amount: (Money amount: 100 currency: 'EUR') }
            splitRule: splitRule
            gifts: { Gift from: alice to: bob amount: (Money amount: 60 currency: 'EUR') }
            date: Date today
    ] raise: Error
]

{ #category : 'running' }
GiftTest >> testNegativeAmountRaisesError [
    self should: [
        Expense
            description: 'Test'
            totalAmount: (Money amount: 100 currency: 'EUR')
            payments: { Payment participant: alice amount: (Money amount: 100 currency: 'EUR') }
            splitRule: splitRule
            gifts: { Gift from: alice to: bob amount: (Money amount: -10 currency: 'EUR') }
            date: Date today
    ] raise: Error
]

{ #category : 'running' }
GiftTest >> testNonPayerCanGift [
	"Bob ne paie rien mais peut offrir un cadeau à Alice"

	Expense
		description: 'Test'
		totalAmount: (Money amount: 100 currency: 'EUR')
		payments: { (Payment
				 participant: alice
				 amount: (Money amount: 100 currency: 'EUR')) }
		splitRule: splitRule
		gifts:
		{ (Gift
			 from: bob
			 to: alice
			 amount: (Money amount: 10 currency: 'EUR')) }
		date: Date today
]

{ #category : 'running' }
GiftTest >> testPrintStringContainsAmount [
    | g |
    g := Gift from: alice to: bob amount: (Money amount: 20 currency: 'EUR').
    self assert: (g printString includesSubstring: '20')
]

{ #category : 'running' }
GiftTest >> testPrintStringContainsFromName [
    | g |
    g := Gift from: alice to: bob amount: (Money amount: 20 currency: 'EUR').
    self assert: (g printString includesSubstring: 'Alice')
]

{ #category : 'running' }
GiftTest >> testRecipientMustBeInSplit [
    | charlie |
    charlie := Participant name: 'Charlie'.
    self should: [
        Expense
            description: 'Test'
            totalAmount: (Money amount: 100 currency: 'EUR')
            payments: { Payment participant: alice amount: (Money amount: 100 currency: 'EUR') }
            splitRule: splitRule
            gifts: { Gift from: alice to: charlie amount: (Money amount: 10 currency: 'EUR') }
            date: Date today
    ] raise: Error
]

{ #category : 'running' }
GiftTest >> testTwoGiftsExceedingCumulativeSurplusRaisesError [
    "Alice paie 100, part 50, surplus 50.
     Deux cadeaux de 40 EUR chacun : le second doit échouer."
    self should: [
        Expense
            description: 'Test'
            totalAmount: (Money amount: 100 currency: 'EUR')
            payments: { Payment participant: alice amount: (Money amount: 100 currency: 'EUR') }
            splitRule: splitRule
            gifts: {
                Gift from: alice to: bob amount: (Money amount: 40 currency: 'EUR').
                Gift from: alice to: bob amount: (Money amount: 40 currency: 'EUR') }
            date: Date today
    ] raise: Error
]

{ #category : 'running' }
GiftTest >> testValidGiftPassesValidation [
    "Alice paie 100, part 50, surplus 50 → peut offrir 50"
    self shouldnt: [
        Expense
            description: 'Test'
            totalAmount: (Money amount: 100 currency: 'EUR')
            payments: { Payment participant: alice amount: (Money amount: 100 currency: 'EUR') }
            splitRule: splitRule
            gifts: { Gift from: alice to: bob amount: (Money amount: 50 currency: 'EUR') }
            date: Date today
    ] raise: Error
]

{ #category : 'running' }
GiftTest >> testZeroAmountRaisesError [
    self should: [
        Expense
            description: 'Test'
            totalAmount: (Money amount: 100 currency: 'EUR')
            payments: { Payment participant: alice amount: (Money amount: 100 currency: 'EUR') }
            splitRule: splitRule
            gifts: { Gift from: alice to: bob amount: (Money amount: 0 currency: 'EUR') }
            date: Date today
    ] raise: Error
]
