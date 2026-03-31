Class {
	#name : 'ExpenseBalanceTest',
	#superclass : 'TestCase',
	#instVars : [
		'greg',
		'malvina',
		'antoine'
	],
	#category : 'TripExpenses-Domain-Tests',
	#package : 'TripExpenses-Domain-Tests'
}

{ #category : 'running' }
ExpenseBalanceTest >> setUp [

	antoine := Participant name: 'Antoine'.
	greg := Participant name: 'Greg'.
	malvina := Participant name: 'Malvina'
]

{ #category : 'running' }
ExpenseBalanceTest >> splitRule [
    ^ EqualSplitRule among: {
        ParticipantWeight participant: antoine .
        ParticipantWeight participant: greg.
        ParticipantWeight participant: malvina }
]

{ #category : 'running' }
ExpenseBalanceTest >> testBalancesSumToZeroMultiplePayers [
    | exp sum |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: {
            Payment participant: antoine amount: (Money amount: 60 currency: 'EUR').
            Payment participant: greg   amount: (Money amount: 30 currency: 'EUR') }
        splitRule: self splitRule
        gifts: {}
        date: Date today.
    sum := (exp balanceFor: antoine ) amount
         + (exp balanceFor: greg)   amount
         + (exp balanceFor: malvina ) amount.
    self assert: sum equals: 0
]

{ #category : 'running' }
ExpenseBalanceTest >> testBalancesSumToZeroSinglePayer [
    | exp sum |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 90 currency: 'EUR') }
        splitRule: self splitRule
        gifts: {}
        date: Date today.
    sum := (exp balanceFor: antoine ) amount
         + (exp balanceFor: greg)   amount
         + (exp balanceFor: malvina ) amount.
    self assert: sum equals: 0
]

{ #category : 'running' }
ExpenseBalanceTest >> testBalancesSumToZeroWithGifts [
    | exp sum |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 90 currency: 'EUR') }
        splitRule: self splitRule
        gifts: { Gift from: antoine to: greg amount: (Money amount: 30 currency: 'EUR') }
        date: Date today.
    sum := (exp balanceFor: antoine ) amount
         + (exp balanceFor: greg)   amount
         + (exp balanceFor: malvina ) amount.
    self assert: sum equals: 0
]

{ #category : 'running' }
ExpenseBalanceTest >> testCasRestaurantAvance [
    "Georges paie 90 pour 3 (poids 2,1,1), sans cadeau → Martine doit 30"
    | martine arthur georges rule exp |
    martine := Participant name: 'Martine'.
    arthur  := Participant name: 'Arthur'.
    georges := Participant name: 'Georges'.
    rule := EqualSplitRule among: {
        ParticipantWeight participant: georges weight: 2.
        ParticipantWeight participant: martine weight: 1.
        ParticipantWeight participant: arthur  weight: 1 }.
    exp := Expense
        description: 'Restaurant'
        totalAmount: (Money amount: 120 currency: 'EUR')
        payments: {
            Payment participant: georges amount: (Money amount: 90 currency: 'EUR').
            Payment participant: arthur  amount: (Money amount: 30 currency: 'EUR') }
        splitRule: rule
        gifts: {}
        date: Date today.
    self assert: (exp balanceFor: georges) amount equals:  30.
    self assert: (exp balanceFor: martine) amount equals: -30.
    self assert: (exp balanceFor: arthur)  amount equals:   0
]

{ #category : 'running' }
ExpenseBalanceTest >> testCasRestaurantCadeau [
    "Georges paie 90, offre 30 à Martine → tout le monde quitte"
    | martine arthur georges rule exp |
    martine := Participant name: 'Martine'.
    arthur  := Participant name: 'Arthur'.
    georges := Participant name: 'Georges'.
    rule := EqualSplitRule among: {
        ParticipantWeight participant: georges weight: 2.
        ParticipantWeight participant: martine weight: 1.
        ParticipantWeight participant: arthur  weight: 1 }.
    exp := Expense
        description: 'Restaurant'
        totalAmount: (Money amount: 120 currency: 'EUR')
        payments: {
            Payment participant: georges amount: (Money amount: 90 currency: 'EUR').
            Payment participant: arthur  amount: (Money amount: 30 currency: 'EUR') }
        splitRule: rule
        gifts: { Gift from: georges to: martine
                      amount: (Money amount: 30 currency: 'EUR') }
        date: Date today.
    self assert: (exp balanceFor: georges) amount equals: 0.
    self assert: (exp balanceFor: martine) amount equals: 0.
    self assert: (exp balanceFor: arthur)  amount equals: 0
]

{ #category : 'running' }
ExpenseBalanceTest >> testFinalBalanceWithGift [
    | exp |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 90 currency: 'EUR') }
        splitRule: self splitRule
        gifts: { Gift from: antoine to: greg amount: (Money amount: 30 currency: 'EUR') }
        date: Date today.
    self assert: (exp balanceFor: antoine )   amount equals:  30.
    self assert: (exp balanceFor: greg)     amount equals:   0.
    self assert: (exp balanceFor: malvina ) amount equals: -30
]

{ #category : 'running' }
ExpenseBalanceTest >> testGiftEffectForRecipient [ 
    | exp |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 90 currency: 'EUR') }
        splitRule: self splitRule
        gifts: { Gift from: antoine to: greg amount: (Money amount: 30 currency: 'EUR') }
        date: Date today.
    self assert: (exp giftEffectFor: greg )     amount equals:  30.
    self assert: (exp giftEffectFor: antoine )   amount equals: -30.
    self assert: (exp giftEffectFor: malvina ) amount equals:   0
]

{ #category : 'running' }
ExpenseBalanceTest >> testGiftMakesEverybodyQuits [
    | exp |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 90 currency: 'EUR') }
        splitRule: self splitRule
        gifts: {
            Gift from: antoine to: greg     amount: (Money amount: 30 currency: 'EUR').
            Gift from: antoine to: malvina amount: (Money amount: 30 currency: 'EUR') }
        date: Date today.
    self assert: (exp balanceFor: antoine )   amount equals: 0.
    self assert: (exp balanceFor: greg )     amount equals: 0.
    self assert: (exp balanceFor: malvina ) amount equals: 0
]

{ #category : 'running' }
ExpenseBalanceTest >> testMultiplePayersRawBalance [ 
    | exp |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: {
            Payment participant: antoine amount: (Money amount: 60 currency: 'EUR').
            Payment participant: greg   amount: (Money amount: 30 currency: 'EUR') }
        splitRule: self splitRule
        gifts: {}
        date: Date today.
    self assert: (exp rawBalanceFor: antoine )   amount equals:  30.
    self assert: (exp rawBalanceFor: greg)     amount equals:   0.
    self assert: (exp rawBalanceFor: malvina ) amount equals: -30
]

{ #category : 'running' }
ExpenseBalanceTest >> testPaidBy [

	| martine arthur georges rule exp |
	martine := Participant name: 'Martine'.
	arthur := Participant name: 'Arthur'.
	georges := Participant name: 'Georges'.
	rule := EqualSplitRule among: {
			        (ParticipantWeight participant: georges weight: 2).
			        (ParticipantWeight participant: martine weight: 1).
			        (ParticipantWeight participant: arthur weight: 1) }.
	exp := Expense
		       description: 'Restaurant'
		       totalAmount: (Money amount: 120 currency: 'EUR')
		       payments: {
				       (Payment
					        participant: georges
					        amount: (Money amount: 90 currency: 'EUR')).
				       (Payment
					        participant: arthur
					        amount: (Money amount: 30 currency: 'EUR')) }
		       splitRule: rule
		       gifts: {  }
		       date: Date today.

	self
		assert: (exp paidBy: georges)
		equals: (Money amount: 90 currency: 'EUR').
			self
		assert: (exp paidBy: arthur)
		equals: (Money amount: 30 currency: 'EUR').
			self
		assert: (exp paidBy: martine )
		equals: (Money amount: 0 currency: 'EUR')
		
]

{ #category : 'running' }
ExpenseBalanceTest >> testParticipantNotInSplitHasZeroRawBalance [ 
    | rule exp outsider |
    outsider := Participant name: 'Outsider'.
    rule := EqualSplitRule among: {
        ParticipantWeight participant: antoine .
        ParticipantWeight participant: greg }.
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 100 currency: 'EUR') }
        splitRule: rule
        gifts: {}
        date: Date today.
    self assert: (exp rawBalanceFor: outsider) amount equals: 0
]

{ #category : 'running' }
ExpenseBalanceTest >> testRawBalanceFor [

	| martine arthur georges rule exp |
	martine := Participant name: 'Martine'.
	arthur := Participant name: 'Arthur'.
	georges := Participant name: 'Georges'.
	rule := EqualSplitRule among: {
			        (ParticipantWeight participant: georges weight: 2).
			        (ParticipantWeight participant: martine).
			        (ParticipantWeight participant: arthur) }.
	exp := Expense
		       description: 'Restaurant'
		       totalAmount: (Money amount: 120 currency: 'EUR')
		       payments: {
				       (Payment
					        participant: georges
					        amount: (Money amount: 90 currency: 'EUR')).
				       (Payment
					        participant: arthur
					        amount: (Money amount: 30 currency: 'EUR')) }
		       splitRule: rule
		       gifts: {  }
		       date: Date today.

	self
		assert: (exp rawBalanceFor: arthur)
		equals: (Money amount: 0 currency: 'EUR').

	self
		assert: (exp rawBalanceFor: martine)
		equals: (Money amount: -30 currency: 'EUR').

	self
		assert: (exp rawBalanceFor: georges)
		equals: (Money amount: 30 currency: 'EUR')
]

{ #category : 'running' }
ExpenseBalanceTest >> testSinglePayerRawBalance [
    | exp |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 90 currency: 'EUR') }
        splitRule: self splitRule
        gifts: {}
        date: Date today.
    self assert: (exp rawBalanceFor: antoine )   amount equals:  60.
    self assert: (exp rawBalanceFor: greg)     amount equals: -30.
    self assert: (exp rawBalanceFor: malvina ) amount equals: -30
]

{ #category : 'running' }
ExpenseBalanceTest >> testTheoreticalShares [

	| martine arthur georges rule exp |
	martine := Participant name: 'Martine'.
	arthur := Participant name: 'Arthur'.
	georges := Participant name: 'Georges'.
	rule := EqualSplitRule among: {
			        (ParticipantWeight participant: georges weight: 2).
			        (ParticipantWeight participant: martine).
			        (ParticipantWeight participant: arthur) }.
	exp := Expense
		       description: 'Restaurant'
		       totalAmount: (Money amount: 120 currency: 'EUR')
		       payments: { (Payment
				        participant: georges
				        amount: (Money amount: 120 currency: 'EUR')) }
		       splitRule: rule
		       gifts: {  }
		       date: Date today.

	self assert: ((rule computeShares: (Money amount: 120 currency: 'EUR')) at:georges ) equals:(Money amount: 60 currency: 'EUR').

	self
		assert: (exp theoreticalShares at: arthur)
		equals: (Money amount: 30 currency: 'EUR').

	self
		assert: (exp theoreticalShares at: martine)
		equals: (Money amount: 30 currency: 'EUR').

	self
		assert: (exp theoreticalShares at: georges)
		equals: (Money amount: 60 currency: 'EUR')
]

{ #category : 'running' }
ExpenseBalanceTest >> testTotalAmount [

	| martine arthur georges rule exp |
	martine := Participant name: 'Martine'.
	arthur := Participant name: 'Arthur'.
	georges := Participant name: 'Georges'.
	rule := EqualSplitRule among: {
			        (ParticipantWeight participant: georges weight: 2).
			        (ParticipantWeight participant: martine weight: 1).
			        (ParticipantWeight participant: arthur weight: 1) }.
	exp := Expense
		       description: 'Restaurant'
		       totalAmount: (Money amount: 120 currency: 'EUR')
		       payments: {
				       (Payment
					        participant: georges
					        amount: (Money amount: 90 currency: 'EUR')).
				       (Payment
					        participant: arthur
					        amount: (Money amount: 30 currency: 'EUR')) }
		       splitRule: rule
		       gifts: {  }
		       date: Date today.

	self
		assert: (exp totalAmount )
		equals: (Money amount: 120 currency: 'EUR')
]

{ #category : 'running' }
ExpenseBalanceTest >> testWeightedSplit [
    | rule exp |
    rule := EqualSplitRule among: {
        ParticipantWeight participant: antoine weight: 2.
        ParticipantWeight participant: greg   weight: 1 }.
    exp := Expense
        description: 'Hôtel'
        totalAmount: (Money amount: 120 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 120 currency: 'EUR') }
        splitRule: rule
        gifts: {}
        date: Date today.
    self assert: (exp balanceFor: antoine ) amount equals:  40.
    self assert: (exp balanceFor: greg)   amount equals: -40
]
