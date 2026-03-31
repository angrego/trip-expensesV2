Class {
	#name : 'ExpensePayersTest',
	#superclass : 'TestCase',
	#instVars : [
		'greg',
		'malvina',
		'antoine',
		'splitRule'
	],
	#category : 'TripExpenses-Domain-Tests',
	#package : 'TripExpenses-Domain-Tests'
}

{ #category : 'running' }
ExpensePayersTest >> setUp [

	antoine := Participant name: 'Antoine'.
	greg := Participant name: 'Greg'.
	malvina := Participant name: 'Malvina'.
	splitRule := EqualSplitRule among: {
			             (ParticipantWeight participant: greg).
			             (ParticipantWeight participant: antoine) }
]

{ #category : 'running' }
ExpensePayersTest >> testPaidByKnownParticipant [
    | exp |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 100 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today.
    self assert: (exp paidBy: antoine ) equals: (Money amount: 100 currency: 'EUR')
]

{ #category : 'running' }
ExpensePayersTest >> testPaidByUnknownParticipantIsZero [
    | exp charlie |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 100 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today.
    self assert: (exp paidBy: malvina ) amount equals: 0
]

{ #category : 'running' }
ExpensePayersTest >> testSinglePayer [
    | exp |
    exp := Expense
        description: 'Test'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 100 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today.
    self assert: exp payers size equals: 1.
    self assert: (exp payers includes: antoine )
]
