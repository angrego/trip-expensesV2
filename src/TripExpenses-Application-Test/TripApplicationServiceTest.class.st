Class {
	#name : 'TripApplicationServiceTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'repository'
	],
	#category : 'TripExpenses-Application-Test',
	#package : 'TripExpenses-Application-Test'
}

{ #category : 'helpers' }
TripApplicationServiceTest >> makeExpensePaidBy: aPayer onTrip: aTrip [
	"Crée une dépense minimale dont le seul payeur est aPayer,
	 répartie équitablement entre tous les participants du voyage."
	| rule |
	rule := EqualSplitRule among:
		(aTrip participants collect: [ :p | ParticipantWeight participant: p ]).
	^ Expense
		description: 'Test expense'
		totalAmount: (Money amount: 90 currency: 'EUR')
		payments: { Payment participant: aPayer
		                   amount: (Money amount: 90 currency: 'EUR') }
		splitRule: rule
		gifts: {}
		date: Date today
]

{ #category : 'running' }
TripApplicationServiceTest >> setUp [
	repository := InMemoryTripRepository new.
	service    := TripApplicationService withRepository: repository
]

{ #category : 'tests - addParticipant' }
TripApplicationServiceTest >> testAddDuplicateParticipantNameRaisesError [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	service addParticipant: 'Alice' toTrip: trip id.
	self should: [ service addParticipant: 'Alice' toTrip: trip id ] raise: Error
]

{ #category : 'tests - addExpense' }
TripApplicationServiceTest >> testAddExpenseAppearsInTrip [
	| ctx expense reloaded |
	ctx     := self tripWithAliceAndBob.
	expense := self makeExpensePaidBy: ctx second onTrip: (service findTrip: ctx first id).
	service addExpense: expense toTrip: ctx first id.
	reloaded := service findTrip: ctx first id.
	self assert: (reloaded expenses includes: expense)
]

{ #category : 'tests - addExpense' }
TripApplicationServiceTest >> testAddExpenseDoesNotAlterOtherTrips [
	"L'ajout d'une dépense dans trip1 ne doit pas modifier trip2."
	| ctx1 ctx2 expense |
	ctx1    := self tripWithAliceAndBob.
	ctx2    := self tripWithAliceAndBob.
	expense := self makeExpensePaidBy: ctx1 second onTrip: (service findTrip: ctx1 first id).
	service addExpense: expense toTrip: ctx1 first id.
	self assert: (service findTrip: ctx2 first id) expenses isEmpty
]

{ #category : 'tests - addExpense' }
TripApplicationServiceTest >> testAddExpenseIsPersisted [
	| ctx expense reloaded |
	ctx     := self tripWithAliceAndBob.
	expense := self makeExpensePaidBy: ctx second onTrip: (service findTrip: ctx first id).
	service addExpense: expense toTrip: ctx first id.
	reloaded := service findTrip: ctx first id.
	self assert: reloaded expenses size equals: 1
]

{ #category : 'tests - addExpense' }
TripApplicationServiceTest >> testAddExpenseReturnsExpense [
	| ctx expense result |
	ctx     := self tripWithAliceAndBob.
	expense := self makeExpensePaidBy: ctx second onTrip: (service findTrip: ctx first id).
	result  := service addExpense: expense toTrip: ctx first id.
	self assert: result equals: expense
]

{ #category : 'tests - addExpense' }
TripApplicationServiceTest >> testAddExpenseToUnknownTripRaisesError [
	| ctx expense |
	ctx     := self tripWithAliceAndBob.
	expense := self makeExpensePaidBy: ctx second onTrip: (service findTrip: ctx first id).
	self should: [ service addExpense: expense toTrip: 'ghost-id' ] raise: Error
]

{ #category : 'tests - addExpense' }
TripApplicationServiceTest >> testAddExpenseWithNonParticipantPayerRaisesError [
	| ctx outsider rule expense |
	ctx      := self tripWithAliceAndBob.
	outsider := Participant name: 'Outsider'.
	rule     := EqualSplitRule among: {
		ParticipantWeight participant: ctx second.
		ParticipantWeight participant: ctx third }.
	expense  := Expense
		description: 'Test'
		totalAmount: (Money amount: 50 currency: 'EUR')
		payments: { Payment participant: outsider
		                   amount: (Money amount: 50 currency: 'EUR') }
		splitRule: rule
		gifts: {}
		date: Date today.
	self should: [ service addExpense: expense toTrip: ctx first id ] raise: Error
]

{ #category : 'tests - addParticipant' }
TripApplicationServiceTest >> testAddParticipantAppearsInTrip [
	| trip participant reloaded |
	trip        := service createTrip: 'Vacances' currency: 'EUR'.
	participant := service addParticipant: 'Alice' toTrip: trip id.
	reloaded    := service findTrip: trip id.
	self assert: (reloaded participants includes: participant)
]

{ #category : 'tests - addParticipant' }
TripApplicationServiceTest >> testAddParticipantAssignsId [
	| trip participant |
	trip        := service createTrip: 'Vacances' currency: 'EUR'.
	participant := service addParticipant: 'Alice' toTrip: trip id.
	self assert: participant id isNotNil
]

{ #category : 'tests - addParticipant' }
TripApplicationServiceTest >> testAddParticipantIsPersisted [
	"Le participant doit survivre à un findTrip: (test de la persistence)."
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	service addParticipant: 'Alice' toTrip: trip id.
	self assert: (service findTrip: trip id) participants size equals: 1
]

{ #category : 'tests - addParticipant' }
TripApplicationServiceTest >> testAddParticipantReturnsParticipant [
	| trip participant |
	trip        := service createTrip: 'Vacances' currency: 'EUR'.
	participant := service addParticipant: 'Alice' toTrip: trip id.
	self assert: (participant isKindOf: Participant)
]

{ #category : 'tests - addParticipant' }
TripApplicationServiceTest >> testAddParticipantStoresName [
	| trip participant |
	trip        := service createTrip: 'Vacances' currency: 'EUR'.
	participant := service addParticipant: 'Alice' toTrip: trip id.
	self assert: participant name equals: 'Alice'
]

{ #category : 'tests - addParticipant' }
TripApplicationServiceTest >> testAddParticipantToUnknownTripRaisesError [
	self should: [ service addParticipant: 'Alice' toTrip: 'ghost-id' ] raise: Error
]

{ #category : 'tests - addParticipant' }
TripApplicationServiceTest >> testAddParticipantTwoTripsAreIndependent [
	"Un participant ajouté au voyage 1 n'apparaît pas dans le voyage 2."
	| t1 t2 |
	t1 := service createTrip: 'Vacances'  currency: 'EUR'.
	t2 := service createTrip: 'Road trip' currency: 'EUR'.
	service addParticipant: 'Alice' toTrip: t1 id.
	self assert: (service findTrip: t2 id) participants isEmpty
]

{ #category : 'tests - addExpense' }
TripApplicationServiceTest >> testAddSeveralExpenses [
	| ctx trip expense1 expense2 reloaded |
	ctx     := self tripWithAliceAndBob.
	trip    := service findTrip: ctx first id.
	expense1 := self makeExpensePaidBy: ctx second onTrip: trip.
	expense2 := self makeExpensePaidBy: ctx third  onTrip: trip.
	service addExpense: expense1 toTrip: ctx first id.
	service addExpense: expense2 toTrip: ctx first id.
	reloaded := service findTrip: ctx first id.
	self assert: reloaded expenses size equals: 2
]

{ #category : 'tests - addParticipant' }
TripApplicationServiceTest >> testAddSeveralParticipants [
	| trip reloaded |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	service addParticipant: 'Alice'   toTrip: trip id.
	service addParticipant: 'Bob'     toTrip: trip id.
	service addParticipant: 'Charlie' toTrip: trip id.
	reloaded := service findTrip: trip id.
	self assert: reloaded participants size equals: 3
]

{ #category : 'tests - allTrips' }
TripApplicationServiceTest >> testAllTripsContainsCreatedTrip [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	self assert: (service allTrips anySatisfy: [ :t | t id = trip id ])
]

{ #category : 'tests - allTrips' }
TripApplicationServiceTest >> testAllTripsEmptyInitially [
	self assert: service allTrips isEmpty
]

{ #category : 'tests - allTrips' }
TripApplicationServiceTest >> testAllTripsReturnsOneTrip [
	service createTrip: 'Vacances' currency: 'EUR'.
	self assert: service allTrips size equals: 1
]

{ #category : 'tests - allTrips' }
TripApplicationServiceTest >> testAllTripsReturnsSeveralTrips [
	service createTrip: 'Vacances'  currency: 'EUR'.
	service createTrip: 'Road trip' currency: 'USD'.
	service createTrip: 'Week-end'  currency: 'EUR'.
	self assert: service allTrips size equals: 3
]

{ #category : 'tests - createTrip' }
TripApplicationServiceTest >> testCreateTripAssignsId [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	self assert: trip id isNotNil.
	self assert: trip id isNotEmpty
]

{ #category : 'tests - createTrip' }
TripApplicationServiceTest >> testCreateTripHasNoExpenses [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	self assert: trip expenses isEmpty
]

{ #category : 'tests - createTrip' }
TripApplicationServiceTest >> testCreateTripHasNoParticipants [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	self assert: trip participants isEmpty
]

{ #category : 'tests - createTrip' }
TripApplicationServiceTest >> testCreateTripIsPersisted [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	self assert: repository size equals: 1
]

{ #category : 'tests - createTrip' }
TripApplicationServiceTest >> testCreateTripReturnsATrip [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	self assert: (trip isKindOf: Trip)
]

{ #category : 'tests - createTrip' }
TripApplicationServiceTest >> testCreateTripStoresCurrency [
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	self assert: trip currency equals: 'EUR'
]

{ #category : 'tests - createTrip' }
TripApplicationServiceTest >> testCreateTripStoresName [ 
	| trip |
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	self assert: trip name equals: 'Vacances'
]

{ #category : 'tests - findTrip' }
TripApplicationServiceTest >> testFindTripAmongSeveralTrips [
	| t1 t2 found |
	t1    := service createTrip: 'Vacances' currency: 'EUR'.
	t2    := service createTrip: 'Road trip' currency: 'USD'.
	found := service findTrip: t2 id.
	self assert: found name equals: 'Road trip'
]

{ #category : 'tests - findTrip' }
TripApplicationServiceTest >> testFindTripReturnsCorrectNameAndCurrency [
	| trip found |
	trip  := service createTrip: 'Vacances' currency: 'EUR'.
	found := service findTrip: trip id.
	self assert: found name     equals: 'Vacances'.
	self assert: found currency equals: 'EUR'
]

{ #category : 'tests - findTrip' }
TripApplicationServiceTest >> testFindTripReturnsCorrectTrip [
	| trip found |
	trip  := service createTrip: 'Vacances' currency: 'EUR'.
	found := service findTrip: trip id.
	self assert: found id equals: trip id
]

{ #category : 'tests - findTrip' }
TripApplicationServiceTest >> testFindTripUnknownIdRaisesError [
	self should: [ service findTrip: 'unknown-id' ] raise: Error
]

{ #category : 'tests - createTrip' }
TripApplicationServiceTest >> testTwoTripsHaveDifferentIds [
	| t1 t2 |
	t1 := service createTrip: 'Vacances' currency: 'EUR'.
	t2 := service createTrip: 'Road trip' currency: 'USD'.
	self deny: t1 id equals: t2 id
]

{ #category : 'helpers' }
TripApplicationServiceTest >> tripWithAliceAndBob [
	"Crée un voyage sauvegardé avec deux participants, retourne un tableau
	 ordonnancé #(trip alice bob)."
	| trip alice bob |
	trip  := service createTrip: 'Vacances' currency: 'EUR'.
	alice := service addParticipant: 'Alice' toTrip: trip id.
	bob   := service addParticipant: 'Bob'   toTrip: trip id.
	^ Array with: trip with: alice with: bob
]
