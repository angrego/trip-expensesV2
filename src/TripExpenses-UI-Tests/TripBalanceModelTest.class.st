Class {
	#name : 'TripBalanceModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'model',
		'tripId',
		'aliceId',
		'bobId',
		'charlieId'
	],
	#category : 'TripExpenses-UI-Tests-Balance',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'Balance'
}

{ #category : 'adding' }
TripBalanceModelTest >> addExpensePaidBy: aPayerId amount: anAmount [
    | trip payer rule expense |
    trip  := service findTrip: tripId.
    payer := trip participants detect: [ :p | p id value = aPayerId ].
    rule  := EqualSplitRule among: (trip participants 
        collect: [ :p | ParticipantWeight participant: p ]).
    expense := Expense
        description: 'Test'
        totalAmount: (Money amount: anAmount currency: 'EUR')
        payments: { Payment participant: payer amount: (Money amount: anAmount currency: 'EUR') }
        splitRule: rule
        gifts: {}
        date: Date today.
    service addExpense: expense toTrip: tripId
]

{ #category : 'running' }
TripBalanceModelTest >> setUp [
    | trip alice bob charlie |
    service := TripApplicationService withRepository: InMemoryTripRepository new.
    trip    := service createTrip: 'Vacances' currency: 'EUR'.
    alice   := service addParticipantByName: 'Alice'   toTrip: trip id.
    bob     := service addParticipantByName: 'Bob'     toTrip: trip id.
    charlie := service addParticipantByName: 'Charlie' toTrip: trip id.
    tripId    := trip id.
    aliceId   := alice id value.
    bobId     := bob id value.
    charlieId := charlie id value.
    model := TripBalanceModel onService: service tripId: tripId
]

{ #category : 'adding' }
TripBalanceModelTest >> testBalancedExpenseHasNoSettlements [
    self addExpensePaidBy: aliceId amount: 30.
    self addExpensePaidBy: bobId amount: 30.
    self addExpensePaidBy: charlieId amount: 30.
    model load.
    self assert: model settlements isEmpty
]

{ #category : 'adding' }
TripBalanceModelTest >> testBalancesAreBalanceItemModels [
    self addExpensePaidBy: aliceId amount: 90.
    model load.
    model balances do: [ :b |
        self assert: (b isKindOf: TripBalanceItemModel) ]
]

{ #category : 'adding' }
TripBalanceModelTest >> testBalancesInitiallyEmpty [
    self assert: model balances isEmpty
]

{ #category : 'adding' }
TripBalanceModelTest >> testLoadUpdatesBalances [
    self addExpensePaidBy: aliceId amount: 90.
    model load.
    self assert: model balances size equals: 3
]

{ #category : 'adding' }
TripBalanceModelTest >> testLoadUpdatesSettlements [
    self addExpensePaidBy: aliceId amount: 90.
    model load.
    self deny: model settlements isEmpty
]

{ #category : 'adding' }
TripBalanceModelTest >> testSettlementsAreSettlementItemModels [
    self addExpensePaidBy: aliceId amount: 90.
    model load.
    model settlements do: [ :s |
        self assert: (s isKindOf: TripSettlementItemModel) ]
]

{ #category : 'adding' }
TripBalanceModelTest >> testSettlementsInitiallyEmpty [
    self assert: model settlements isEmpty
]
