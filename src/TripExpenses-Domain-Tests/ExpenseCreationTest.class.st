Class {
	#name : 'ExpenseCreationTest',
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
ExpenseCreationTest >> makeExpense [ 
    ^ Expense
        description: 'Resto'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 100 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today
]

{ #category : 'running' }
ExpenseCreationTest >> setUp [

	antoine := Participant name: 'Antoine'.
	greg := Participant name: 'Greg'.
	malvina := Participant name: 'Malvina'.
	splitRule := EqualSplitRule among: {
			             (ParticipantWeight participant: greg).
			             (ParticipantWeight participant: antoine) }
]

{ #category : 'running' }
ExpenseCreationTest >> testCreationAssignsId [
    self assert: self makeExpense id isNotNil
]

{ #category : 'running' }
ExpenseCreationTest >> testCreationAssignsNonEmptyId [
    self assert: self makeExpense id isNotEmpty
]

{ #category : 'running' }
ExpenseCreationTest >> testCreationStoresDate [
    self assert: self makeExpense date equals: Date today
]

{ #category : 'running' }
ExpenseCreationTest >> testCreationStoresDescription [
    self assert: self makeExpense description equals: 'Resto'
]

{ #category : 'running' }
ExpenseCreationTest >> testCreationStoresEmptyGifts [
    self assert: self makeExpense gifts isEmpty
]

{ #category : 'running' }
ExpenseCreationTest >> testCreationStoresEmptyTags [
    self assert: self makeExpense tags isEmpty
]

{ #category : 'running' }
ExpenseCreationTest >> testCreationStoresPayments [
    self assert: self makeExpense payments size equals: 1
]

{ #category : 'running' }
ExpenseCreationTest >> testCreationStoresTotalAmount [
    self assert: self makeExpense totalAmount
         equals: (Money amount: 100 currency: 'EUR')
]

{ #category : 'running' }
ExpenseCreationTest >> testNoPaymentsRaisesError [ 
    self should: [
        Expense
            description: 'Vide'
            totalAmount: (Money amount: 100 currency: 'EUR')
            payments: {}
            splitRule: splitRule
            gifts: {}
            date: Date today
    ] raise: Error
]

{ #category : 'running' }
ExpenseCreationTest >> testOverpaymentRaisesError [ 
    self should: [
        Expense
            description: 'Trop'
            totalAmount: (Money amount: 100 currency: 'EUR')
            payments: { Payment participant: antoine amount: (Money amount: 150 currency: 'EUR') }
            splitRule: splitRule
            gifts: {}
            date: Date today
    ] raise: Error
]

{ #category : 'running' }
ExpenseCreationTest >> testPaymentsMustMatchTotal [ 
    self should: [
        Expense
            description: 'Erreur'
            totalAmount: (Money amount: 100 currency: 'EUR')
            payments: { Payment participant: antoine amount: (Money amount: 60 currency: 'EUR') }
            splitRule: splitRule
            gifts: {}
            date: Date today
    ] raise: Error
]

{ #category : 'running' }
ExpenseCreationTest >> testTwoExpensesHaveDifferentIds [
    self deny: self makeExpense id equals: self makeExpense id
]
