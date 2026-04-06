Class {
	#name : 'TripExpensesTest',
	#superclass : 'TestCase',
	#instVars : [
		'trip',
		'alice',
		'bob',
		'charlie'
	],
	#category : 'TripExpenses-Domain-Tests-TripExpenses-Domain-Tests-Model',
	#package : 'TripExpenses-Domain-Tests',
	#tag : 'TripExpenses-Domain-Tests-Model'
}

{ #category : 'running' }
TripExpensesTest >> makeExpense: aDescription paidBy: aPayer amount: aNumber [
    ^ Expense
        description: aDescription
        totalAmount: (Money amount: aNumber currency: 'EUR')
        payments: { Payment participant: aPayer amount: (Money amount: aNumber currency: 'EUR') }
        splitRule: self makeSplitRule
        gifts: {}
        date: Date today
]

{ #category : 'running' }
TripExpensesTest >> makeSplitRule [
    ^ EqualSplitRule among: (trip participants
        collect: [ :p | ParticipantWeight participant: p ])
]

{ #category : 'running' }
TripExpensesTest >> setUp [
    trip    := Trip name: 'Vacances' currency: 'EUR'.
    alice   := Participant name: 'Alice'.
    bob     := Participant name: 'Bob'.
    charlie := Participant name: 'Charlie'.
    trip addParticipant: alice.
    trip addParticipant: bob.
    trip addParticipant: charlie
]

{ #category : 'running' }
TripExpensesTest >> testAddExpense [
    trip addExpense: (self makeExpense: 'Resto' paidBy: alice amount: 90).
    self assert: trip expenses size equals: 1
]

{ #category : 'running' }
TripExpensesTest >> testAddMultipleExpenses [
    trip addExpense: (self makeExpense: 'Resto'   paidBy: alice amount: 90).
    trip addExpense: (self makeExpense: 'Essence' paidBy: bob   amount: 60).
    self assert: trip expenses size equals: 2
]

{ #category : 'running' }
TripExpensesTest >> testAddParticipant [
    | dave |
    dave := Participant name: 'Dave'.
    trip addParticipant: dave.
    self assert: (trip participants includes: dave).
    self assert: trip participants size equals: 4
]

{ #category : 'running' }
TripExpensesTest >> testAllPayersMustBeParticipants [
    | outsider |
    outsider := Participant name: 'Outsider'.
    self should: [
        trip addExpense: (Expense
            description: 'Test'
            totalAmount: (Money amount: 90 currency: 'EUR')
            payments: {
                Payment participant: alice    amount: (Money amount: 60 currency: 'EUR').
                Payment participant: outsider amount: (Money amount: 30 currency: 'EUR') }
            splitRule: self makeSplitRule
            gifts: {}
            date: Date today)
    ] raise: Error
]

{ #category : 'running' }
TripExpensesTest >> testBalancesHasOneEntryPerParticipant [
    trip addExpense: (self makeExpense: 'Resto' paidBy: alice amount: 90).
    self assert: trip balances size equals: 3
]

{ #category : 'running' }
TripExpensesTest >> testBalancesKeysAreParticipants [
    | balances |
    trip addExpense: (self makeExpense: 'Resto' paidBy: alice amount: 90).
    balances := trip balances.
    self assert: (balances includesKey: alice).
    self assert: (balances includesKey: bob).
    self assert: (balances includesKey: charlie)
]

{ #category : 'running' }
TripExpensesTest >> testBalancesSumToZero [
    | sum |
    trip addExpense: (self makeExpense: 'Resto'   paidBy: alice amount: 90).
    trip addExpense: (self makeExpense: 'Essence' paidBy: bob   amount: 60).
    sum := trip balances values sumNumbers: [ :m | m amount ].
    self assert: sum equals: 0
]

{ #category : 'running' }
TripExpensesTest >> testBalancesWithNoExpenses [
    trip balances keysAndValuesDo: [ :p :b |
        self assert: b amount equals: 0 ]
]

{ #category : 'running' }
TripExpensesTest >> testCreationAssignsId [
    self assert: trip id isNotNil
]

{ #category : 'running' }
TripExpensesTest >> testCreationCurrency [
    self assert: trip currency equals: 'EUR'
]

{ #category : 'running' }
TripExpensesTest >> testCreationExpensesEmpty [
    self assert: trip expenses isEmpty
]

{ #category : 'running' }
TripExpensesTest >> testCreationIdIsNotEmpty [
    self assert: trip id isNotEmpty
]

{ #category : 'running' }
TripExpensesTest >> testCreationName [
    self assert: trip name equals: 'Vacances'
]

{ #category : 'running' }
TripExpensesTest >> testCreationParticipants [
    self assert: trip participants size equals: 3
]

{ #category : 'running' }
TripExpensesTest >> testDuplicateParticipantInstanceRaisesError [
    self should: [
        trip addParticipant: alice
    ] raise: Error
]

{ #category : 'running' }
TripExpensesTest >> testDuplicateParticipantNameRaisesError [ 
    self should: [
        trip addParticipant: (Participant name: 'Alice')
    ] raise: Error
]

{ #category : 'running' }
TripExpensesTest >> testGenerosityAccumulatesAcrossExpenses [
  | report |
    trip addExpense: (Expense
        description: 'Resto'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
        splitRule: self makeSplitRule
        gifts: { Gift from: alice to: bob amount: (Money amount: 30 currency: 'EUR') }
        date: Date today).
    trip addExpense: (Expense
        description: 'Courses'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
        splitRule: self makeSplitRule
        gifts: { Gift from: alice to: charlie amount: (Money amount: 30 currency: 'EUR') }
        date: Date today).
  
    report := trip generosityReport.
    self assert: (report at: alice) amount equals: 60
]

{ #category : 'running' }
TripExpensesTest >> testGenerosityReportHasOneEntryPerParticipant [
    trip addExpense: (self makeExpense: 'Resto' paidBy: alice amount: 90).
    self assert: trip generosityReport size equals: 3
]

{ #category : 'running' }
TripExpensesTest >> testGenerosityReportNoExpenses [
    trip generosityReport keysAndValuesDo: [ :p :g |
        self assert: g amount equals: 0 ]
]

{ #category : 'running' }
TripExpensesTest >> testGenerosityReportNoGifts [
    trip addExpense: (self makeExpense: 'Resto' paidBy: alice amount: 90).
    trip generosityReport keysAndValuesDo: [ :p :g |
        self assert: g amount equals: 0 ]
]

{ #category : 'running' }
TripExpensesTest >> testGenerosityReportWithGift [
    | exp report |
    exp := Expense
        description: 'Resto'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
        splitRule: self makeSplitRule
        gifts: { Gift from: alice to: bob amount: (Money amount: 30 currency: 'EUR') }
        date: Date today.
    trip addExpense: exp.
    report := trip generosityReport.
    self assert: (report at: alice)   amount equals: 30.
    self assert: (report at: bob)     amount equals:  0.
    self assert: (report at: charlie) amount equals:  0
]

{ #category : 'running' }
TripExpensesTest >> testParticipantNameIsCaseSensitive [
    "alice et ALICE sont deux personnes différentes"
    self shouldnt: [
        trip addParticipant: (Participant name: 'ALICE')
    ] raise: Error
]

{ #category : 'running' }
TripExpensesTest >> testPayerMustBeParticipant [
    | outsider |
    outsider := Participant name: 'Outsider'.
    self should: [
        trip addExpense: (Expense
            description: 'Test'
            totalAmount: (Money amount: 90 currency: 'EUR')
            payments: { Payment participant: outsider amount: (Money amount: 90 currency: 'EUR') }
            splitRule: self makeSplitRule
            gifts: {}
            date: Date today)
    ] raise: Error
]

{ #category : 'running' }
TripExpensesTest >> testSplitRuleWithNonParticipantRaisesError [
    | outsider rule |
    outsider := Participant name: 'Outsider'.
    rule := EqualSplitRule among: {
        ParticipantWeight participant: alice.
        ParticipantWeight participant: outsider }.
    self should: [
        trip addExpense: (Expense
            description: 'Test'
            totalAmount: (Money amount: 90 currency: 'EUR')
            payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
            splitRule: rule
            gifts: {}
            date: Date today)
    ] raise: Error
]

{ #category : 'running' }
TripExpensesTest >> testTotalExpensesCurrency [
    trip addExpense: (self makeExpense: 'Resto' paidBy: alice amount: 90).
    self assert: trip totalExpenses currency equals: 'EUR'
]

{ #category : 'running' }
TripExpensesTest >> testTotalExpensesEmpty [
    self assert: trip totalExpenses amount equals: 0
]

{ #category : 'running' }
TripExpensesTest >> testTotalExpensesMultiple [
    trip addExpense: (self makeExpense: 'Resto'   paidBy: alice amount: 90).
    trip addExpense: (self makeExpense: 'Essence' paidBy: bob   amount: 60).
    self assert: trip totalExpenses amount equals: 150
]

{ #category : 'running' }
TripExpensesTest >> testTotalExpensesOneExpense [
    trip addExpense: (self makeExpense: 'Resto' paidBy: alice amount: 90).
    self assert: trip totalExpenses amount equals: 90
]

{ #category : 'running' }
TripExpensesTest >> testTwoTripsHaveDifferentIds [
    self deny: trip id equals: (Trip name: 'Autre' currency: 'EUR') id
]
