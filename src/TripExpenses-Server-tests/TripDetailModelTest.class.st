Class {
	#name : 'TripDetailModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'app',
		'model',
		'tripId',
		'aliceId',
		'bobId'
	],
	#category : 'TripExpenses-Server-tests-TripExpenses-Server-Tests',
	#package : 'TripExpenses-Server-tests',
	#tag : 'TripExpenses-Server-Tests'
}

{ #category : 'running' }
TripDetailModelTest >> addExpenseAmount: anAmount [
	"Dépense simple payée par Alice, répartie entre Alice et Bob"
	model
		addExpenseDescription: 'Resto'
		amount:                anAmount
		payerId:               aliceId
		participantIds:        { aliceId. bobId }
]

{ #category : 'running' }
TripDetailModelTest >> setUp [
		| r |
	app := TripExpensesServerApp withRepository: InMemoryTripRepository new.
	"Crée un voyage avec deux participants"

	r       := app handleMessage: (Dictionary new at: 'type' put: 'createTrip'; at: 'name' put: 'Vacances'; at: 'currency' put: 'EUR'; yourself).
	tripId  := r at: 'tripId'.
	aliceId := (app handleMessage: (Dictionary new at: 'type' put: 'addParticipant'; at: 'tripId' put: tripId; at: 'name' put: 'Alice'; yourself)) at: 'participantId'.
	bobId   := (app handleMessage: (Dictionary new at: 'type' put: 'addParticipant'; at: 'tripId' put: tripId; at: 'name' put: 'Bob';   yourself)) at: 'participantId'.
	model := TripDetailModel onService: app tripId: tripId
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	self addExpenseAmount: 60.
	self assert: announced
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseAppearsInExpenses [
	self addExpenseAmount: 60.
	self assert: model expenses size equals: 1
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseCreatesSettlement [
	self addExpenseAmount: 60.
	self assert: model settlements size equals: 1
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseHidesForm [
	model showExpenseForm.
	self addExpenseAmount: 60.
	self deny: model showingExpenseForm
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseIsATripExpenseItemModel [
	self addExpenseAmount: 60.
	self assert: (model expenses first isKindOf: TripExpenseExpenseItemModel)
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseUpdatesBalances [
	| aliceBalance |
	self addExpenseAmount: 60.
	aliceBalance := model balances detect: [ :b | b participantName = 'Alice' ].
	self assert: aliceBalance amount equals: '30'
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseWithBlankDescriptionDoesNotAddExpense [
	model addExpenseDescription: '' amount: 60 payerId: aliceId participantIds: { aliceId. bobId }.
	self assert: model expenses isEmpty
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseWithBlankDescriptionSetsError [
	model addExpenseDescription: '' amount: 60 payerId: aliceId participantIds: { aliceId. bobId }.
	self assert: model errorMessage isNotNil
]

{ #category : 'running' }
TripDetailModelTest >> testAddExpenseWithZeroAmountSetsError [
	model addExpenseDescription: 'Resto' amount: 0 payerId: aliceId participantIds: { aliceId. bobId }.
	self assert: model errorMessage isNotNil
]

{ #category : 'running' }
TripDetailModelTest >> testAddTwoExpensesUpdatesTotalExpenses [
	self addExpenseAmount: 60.
	self addExpenseAmount: 40.
	self assert: model expenses size equals: 2
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
TripDetailModelTest >> testInitialBalancesHasOneEntryPerParticipant [
	self assert: model balances size equals: 2
]

{ #category : 'running' }
TripDetailModelTest >> testInitialErrorIsNil [
	self assert: model errorMessage isNil 
]

{ #category : 'running' }
TripDetailModelTest >> testInitialExpensesIsEmpty [
	self assert: model expenses isEmpty
]

{ #category : 'running' }
TripDetailModelTest >> testInitialSettlementsIsEmpty [
	self assert: model settlements isEmpty
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
TripDetailModelTest >> testLoadTripHasTwoParticipants [
	self assert: model participants size equals: 2
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
TripDetailModelTest >> testParticipantsAreTripParticipantModels [
	self assert: (model participants first isKindOf: TripParticipantModel)
]

{ #category : 'running' }
TripDetailModelTest >> testParticipantsHaveNames [
	| names |
	names := model participants collect: [ :p | p name ].
	self assert: (names includes: 'Alice').
	self assert: (names includes: 'Bob')
]

{ #category : 'running' }
TripDetailModelTest >> testShowExpenseFormAnnouncesValueChanged [
	| announced |
	announced := false.
	model when: ValueChanged do: [ announced := true ].
	model showExpenseForm.
	self assert: announced
]

{ #category : 'running' }
TripDetailModelTest >> testShowExpenseFormClearsError [
	model errorMessage: 'une erreur'.
	model showExpenseForm.
	self assert: model errorMessage isNil
]

{ #category : 'running' }
TripDetailModelTest >> testShowExpenseFormSetsFlag [
	model showExpenseForm.
	self assert: model showingExpenseForm
]
