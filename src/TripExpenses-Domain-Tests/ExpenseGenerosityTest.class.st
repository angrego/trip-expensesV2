Class {
	#name : 'ExpenseGenerosityTest',
	#superclass : 'TestCase',
	#instVars : [
		'splitRule',
		'alice',
		'bob',
		'charlie'
	],
	#category : 'TripExpenses-Domain-Tests',
	#package : 'TripExpenses-Domain-Tests'
}

{ #category : 'running' }
ExpenseGenerosityTest >> setUp [
	super setUp.
	alice := Participant name: 'Alice'.
	bob := Participant name: 'Bob'.
	charlie := Participant name: 'Charlie'.
	splitRule := EqualSplitRule among: {
			             (ParticipantWeight participant: alice).
			             (ParticipantWeight participant: bob).
			             (ParticipantWeight participant: charlie) }
]

{ #category : 'running' }
ExpenseGenerosityTest >> testGenerosityRecordFields [

	| exp record generosityRecords payments |
	exp := Expense
		       description: 'Test'
		       totalAmount: (Money amount: 90 currency: 'EUR')
		       payments: { (Payment
				        participant: alice
				        amount: (Money amount: 90 currency: 'EUR')) }
		       splitRule: splitRule
		       gifts:
		       { (Gift
			        from: alice
			        to: bob
			        amount: (Money amount: 30 currency: 'EUR')) }
		       date: Date today.
	payments := exp payments.
	generosityRecords := exp generosityRecords.
	record := generosityRecords detect: [ :r | r participant = alice ].
	self assert: record theoreticalShare amount equals: 30.
	self assert: record paymentMade amount equals: 90.
	self assert: record generosity amount equals: 30.
	self assert: record finalBalance amount equals: 30.
	self assert: record isGenerous
]

{ #category : 'running' }
ExpenseGenerosityTest >> testGenerosityRecordForDebtor [
    | exp record |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today.
    record := exp generosityRecords detect: [ :r | r participant = bob ].
    self assert: record theoreticalShare amount equals:  30.
    self assert: record paymentMade      amount equals:   0.
    self assert: record generosity       amount equals:   0.
    self assert: record finalBalance     amount equals: -30.
    self assert: record isDebtor
]

{ #category : 'running' }
ExpenseGenerosityTest >> testGenerosityRecordsSize [
    | exp |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today.
    self assert: exp generosityRecords size equals: 3
]

{ #category : 'running' }
ExpenseGenerosityTest >> testGiftCreatesGenerosity [
    | exp |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
        splitRule: splitRule
        gifts: { Gift from: alice to: bob amount: (Money amount: 30 currency: 'EUR') }
        date: Date today.
    self assert: (exp generosityFor: alice) amount equals: 30.
    self assert: (exp generosityFor: bob)   amount equals:  0.
    self assert: (exp generosityFor: charlie) amount equals: 0
]

{ #category : 'running' }
ExpenseGenerosityTest >> testMultipleGiftsAccumulate [
    | exp |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
        splitRule: splitRule
        gifts: {
            Gift from: alice to: bob     amount: (Money amount: 20 currency: 'EUR').
            Gift from: alice to: charlie amount: (Money amount: 10 currency: 'EUR') }
        date: Date today.
    self assert: (exp generosityFor: alice) amount equals: 30
]

{ #category : 'running' }
ExpenseGenerosityTest >> testNoGiftNoGenerosity [ 
    | exp |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today.
    self assert: (exp generosityFor: alice)   amount equals: 0.
    self assert: (exp generosityFor: bob)     amount equals: 0.
    self assert: (exp generosityFor: charlie) amount equals: 0
]
