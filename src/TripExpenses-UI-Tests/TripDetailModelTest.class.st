Class {
	#name : 'TripDetailModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'model',
		'tripId',
		'aliceId',
		'bobId'
	],
	#category : 'TripExpenses-UI-Tests-TripDetail',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'TripDetail'
}

{ #category : 'running' }
TripDetailModelTest >> addExpenseAmount: anAmount [
	"Dépense simple payée par Alice, répartie entre Alice et Bob."

	model
		addExpenseDescription: 'Resto'
		amount: anAmount
		payerId: aliceId
		participantWeights: {
				(aliceId -> 1).
				(bobId -> 1) }
]

{ #category : 'running' }
TripDetailModelTest >> setUp [
    | trip alice bob |
super setUp .
    service := TripApplicationService withRepository: InMemoryTripRepository new.
    trip    := service createTrip: 'Vacances' currency: 'EUR'.
    alice   := service addParticipantByName: 'Alice' toTrip: trip id.
    bob     := service addParticipantByName: 'Bob'   toTrip: trip id.
    tripId  := trip id.
    aliceId := alice id value.
    bobId   := bob id value.
    model := TripDetailModel onService: service tripId: tripId
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model addExpenseDescription: 'Resto' amount: 90 payerId: aliceId participantWeights: { aliceId -> 1. bobId -> 1 }.
    self assert: announced
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseAppearsInExpenses [
    self addExpenseAmount: 60.
    self assert: (service findTrip: tripId) expenses size equals: 1
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseCreatesSettlement [
    self addExpenseAmount: 60.
    self assert: (TripSettlementService settleFor: (service findTrip: tripId) balances) size equals: 1
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseHidesForm [
    model showExpenseForm.
    self addExpenseAmount: 60.
    self deny: model showingExpenseForm
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseUpdatesBalances [
    | aliceBalance |
    self addExpenseAmount: 60.
    aliceBalance := (service findTrip: tripId) balances
        associationsDo: [ :a | a key name = 'Alice' ifTrue: [ ^ a value ] ].
    self assert: aliceBalance amount equals: 30
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseWithBlankDescriptionDoesNotAddExpense [
    model addExpenseDescription: '' amount: 60 payerId: aliceId
        participantWeights: { aliceId -> 1. bobId -> 1 }.
    self assert: (service findTrip: tripId) expenses isEmpty
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseWithBlankDescriptionSetsError [
    model addExpenseDescription: '' amount: 60 payerId: aliceId
        participantWeights: { aliceId -> 1. bobId -> 1 }.
    self assert: model errorMessage isNotNil
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseWithEmptyParticipantsSetsError [
    model addExpenseDescription: 'Resto' amount: 60 payerId: aliceId
        participantWeights: #().
    self assert: model errorMessage isNotNil
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseWithNegativeAmountSetsError [
    model addExpenseDescription: 'Resto' amount: -10 payerId: aliceId
        participantWeights: { aliceId -> 1. bobId -> 1 }.
    self assert: model errorMessage isNotNil
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseWithZeroAmountSetsError [
    model addExpenseDescription: 'Resto' amount: 0 payerId: aliceId
        participantWeights: { aliceId -> 1. bobId -> 1 }.
    self assert: model errorMessage isNotNil
]

{ #category : 'running' }
TripDetailModelTest >> testAddValidExpenseClearsError [
    model addExpenseDescription: '' amount: 60 payerId: aliceId
        participantWeights: { aliceId -> 1. bobId -> 1 }.
    self addExpenseAmount: 30.
    self assert: model errorMessage isNil
]

{ #category : 'running' }
TripDetailModelTest >> testHideExpenseFormClearsError [
    model errorMessage: 'une erreur'.
    model hideExpenseForm.
    self assert: model errorMessage isNil
]

{ #category : 'running' }
TripDetailModelTest >> testHideExpenseFormClearsFlag [
    model showExpenseForm.
    model hideExpenseForm.
    self deny: model showingExpenseForm
]

{ #category : 'running' }
TripDetailModelTest >> testInitialErrorIsNil [
    self assert: model errorMessage isNil
]

{ #category : 'running' }
TripDetailModelTest >> testInitialShowingExpenseFormIsFalse [
    self deny: model showingExpenseForm
]

{ #category : 'running' }
TripDetailModelTest >> testLoadTripAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model loadTrip.
    self assert: announced
]

{ #category : 'running' }
TripDetailModelTest >> testLoadTripStoresCurrency [
    self assert: model currency equals: 'EUR'
]

{ #category : 'running' }
TripDetailModelTest >> testLoadTripStoresName [
    self assert: model tripName equals: 'Vacances'
]

{ #category : 'running' }
TripDetailModelTest >> testShowExpenseFormClearsError [
    model errorMessage: 'une erreur'.
    model showExpenseForm.
    self assert: model errorMessage isNil
]

{ #category : 'running' }
TripDetailModelTest >> testShowExpenseFormForParticipantPreselectsPayer [
    model showExpenseFormForParticipant: 'Alice'.
    self assert: model expenseFormModel currentPayerId equals: aliceId
]

{ #category : 'running' }
TripDetailModelTest >> testShowExpenseFormForUnknownParticipantUsesFirst [
    model showExpenseFormForParticipant: 'Inconnu'.
    self assert: model expenseFormModel currentPayerId equals: aliceId
]

{ #category : 'running' }
TripDetailModelTest >> testShowExpenseFormSetsFlag [
    model showExpenseForm.
    self assert: model showingExpenseForm
]
