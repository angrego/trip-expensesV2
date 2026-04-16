Class {
	#name : 'ExpenseCreationTest',
	#superclass : 'TestCase',
	#instVars : [
		'greg',
		'malvina',
		'antoine',
		'splitRule'
	],
	#category : 'TripExpenses-Domain-Tests-TripExpenses-Domain-Tests-Model',
	#package : 'TripExpenses-Domain-Tests',
	#tag : 'TripExpenses-Domain-Tests-Model'
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
ExpenseCreationTest >> testAddGiftAfterCreation [
    | expense |
    expense := self makeExpense.
    expense addGift: (Gift from: antoine to: greg amount: (Money amount: 30 currency: 'EUR')).
    self assert: expense gifts size equals: 1
]

{ #category : 'running' }
ExpenseCreationTest >> testAddGiftExceedingSurplusRaisesError [
    | expense |
    expense := self makeExpense.
    self should: [
        expense addGift: (Gift from: antoine to: greg amount: (Money amount: 100 currency: 'EUR')) ]
    raise: Error
]

{ #category : 'running' }
ExpenseCreationTest >> testAddPayment [
    | expense |
    expense := Expense
        description: 'Resto'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 60 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today.
    expense addPayment: (Payment participant: greg amount: (Money amount: 40 currency: 'EUR')).
    self assert: expense isPaid
]

{ #category : 'running' }
ExpenseCreationTest >> testAddPaymentExceedingTotalRaisesError [
    | expense |
    expense := Expense
        description: 'Resto'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 60 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today.
    self should: [
        expense addPayment: (Payment participant: greg amount: (Money amount: 50 currency: 'EUR')) ]
    raise: Error
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
ExpenseCreationTest >> testIsNotPaidWhenPartiallyPaid [
    | expense |
    expense := Expense
        description: 'Resto'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 60 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today.
    self deny: expense isPaid
]

{ #category : 'running' }
ExpenseCreationTest >> testIsPaidWhenFullyPaid [
    | expense |
    expense := Expense
        description: 'Resto'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 100 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today.
    self assert: expense isPaid
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
ExpenseCreationTest >> testOverpaymentStillRaisesError [
    "Payer plus que le total → erreur"
    self should: [
        Expense
            description: 'Resto'
            totalAmount: (Money amount: 100 currency: 'EUR')
            payments: { Payment participant: antoine amount: (Money amount: 150 currency: 'EUR') }
            splitRule: splitRule
            gifts: {}
            date: Date today
    ] raise: Error
]

{ #category : 'running' }
ExpenseCreationTest >> testPartialPaymentIsAccepted [
	"Bob paie 60 sur 100 — pas d'erreur"

	Expense
		description: 'Resto'
		totalAmount: (Money amount: 100 currency: 'EUR')
		payments: { (Payment
				 participant: antoine
				 amount: (Money amount: 60 currency: 'EUR')) }
		splitRule: splitRule
		gifts: {  }
		date: Date today
]

{ #category : 'running' }
ExpenseCreationTest >> testRemainingAmount [
    | expense |
    expense := Expense
        description: 'Resto'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 60 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today.
    self assert: expense remainingAmount equals: (Money amount: 40 currency: 'EUR')
]

{ #category : 'running' }
ExpenseCreationTest >> testRemovePayment [
    | expense |
    expense := Expense
        description: 'Resto'
        totalAmount: (Money amount: 100 currency: 'EUR')
        payments: { Payment participant: antoine amount: (Money amount: 100 currency: 'EUR') }
        splitRule: splitRule
        gifts: {}
        date: Date today.
    expense removePaymentFor: antoine.
    self assert: expense payments isEmpty
]

{ #category : 'running' }
ExpenseCreationTest >> testTwoExpensesHaveDifferentIds [
    self deny: self makeExpense id equals: self makeExpense id
]
