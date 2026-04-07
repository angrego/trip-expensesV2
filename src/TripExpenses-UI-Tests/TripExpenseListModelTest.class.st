Class {
	#name : 'TripExpenseListModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'model',
		'tripId',
		'aliceId',
		'bobId',
		'charlieId'
	],
	#category : 'TripExpenses-UI-Tests-TripDetail',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'TripDetail'
}

{ #category : 'running' }
TripExpenseListModelTest >> addExpensePaidBy: aPayerId amount: anAmount [
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
TripExpenseListModelTest >> setUp [
    | trip alice bob |
    service := TripApplicationService withRepository: InMemoryTripRepository new.
    trip  := service createTrip: 'Vacances' currency: 'EUR'.
    alice := service addParticipantByName: 'Alice' toTrip: trip id.
    bob   := service addParticipantByName: 'Bob'   toTrip: trip id.
    tripId  := trip id.
    aliceId := alice id value.
    bobId   := bob id value.
    model := TripExpenseListModel onService: service tripId: tripId
]

{ #category : 'running' }
TripExpenseListModelTest >> testExpensesAreExpenseItemModels [
    self addExpensePaidBy: aliceId amount: 90.
    model load.
    model expenses do: [ :e |
        self assert: (e isKindOf: TripExpenseExpenseItemModel) ]
]

{ #category : 'running' }
TripExpenseListModelTest >> testExpensesInitiallyEmpty [
    self assert: model expenses isEmpty
]

{ #category : 'running' }
TripExpenseListModelTest >> testLoadTwoExpenses [
    self addExpensePaidBy: aliceId amount: 90.
    self addExpensePaidBy: bobId amount: 60.
    model load.
    self assert: model expenses size equals: 2
]

{ #category : 'running' }
TripExpenseListModelTest >> testLoadUpdatesExpenses [
    self addExpensePaidBy: aliceId amount: 90.
    model load.
    self assert: model expenses size equals: 1
]

{ #category : 'running' }
TripExpenseListModelTest >> testRemoveExpenseAnnouncesValueChanged [
    | announced |
    self addExpensePaidBy: aliceId amount: 90.
    model load.
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model removeExpenseId: model expenses first expenseId.
    self assert: announced
]

{ #category : 'running' }
TripExpenseListModelTest >> testRemoveExpenseDecreasesCount [
   
   | expenseId |
 self addExpensePaidBy: aliceId amount: 90.
    model load.
 
    expenseId := model expenses first expenseId.
    model removeExpenseId: expenseId.
    self assert: model expenses size equals: 0
]

{ #category : 'running' }
TripExpenseListModelTest >> testRemoveUnknownExpenseRaisesError [
    self should: [ model removeExpenseId: 'id-fantome' ] raise: Error
]
