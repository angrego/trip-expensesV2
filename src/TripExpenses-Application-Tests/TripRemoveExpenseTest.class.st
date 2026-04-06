"
Je teste la suppression de depense au niveau domaine et service.
Ces tests doivent etre ROUGES avant implementation, VERTS apres.
"
Class {
	#name : 'TripRemoveExpenseTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'tripId',
		'aliceId',
		'expense1',
		'expense2'
	],
	#category : 'TripExpenses-Application-Tests',
	#package : 'TripExpenses-Application-Tests'
}

{ #category : 'running' }
TripRemoveExpenseTest >> setUp [

	| trip alice rule |
	service := TripApplicationService withRepository:
		           InMemoryTripRepository new.
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	alice := service addParticipantByName: 'Alice' toTrip: trip id.
	tripId := trip id.
	aliceId := alice id value.
	trip := service findTrip: tripId.
	rule := EqualSplitRule among:
		        { (ParticipantWeight participant: alice) }.
	expense1 := Expense
		            description: 'Restaurant'
		            totalAmount: (Money amount: 60 currency: 'EUR')
		            payments: { (Payment
				             participant: alice
				             amount: (Money amount: 60 currency: 'EUR')) }
		            splitRule: rule
		            gifts: {  }
		            date: Date today.
	expense2 := Expense
		            description: 'Hotel'
		            totalAmount: (Money amount: 120 currency: 'EUR')
		            payments: { (Payment
				             participant: alice
				             amount: (Money amount: 120 currency: 'EUR')) }
		            splitRule: rule
		            gifts: {  }
		            date: Date today.
	service addExpense: expense1 toTrip: tripId.
	service addExpense: expense2 toTrip: tripId
]

{ #category : 'tests - TripApplicationService' }
TripRemoveExpenseTest >> testServiceRemoveAllExpenses [
	service removeExpense: expense1 fromTrip: tripId.
	service removeExpense: expense2 fromTrip: tripId.
	self assert: (service findTrip: tripId) expenses isEmpty
]

{ #category : 'tests - TripApplicationService' }
TripRemoveExpenseTest >> testServiceRemoveExpenseFromUnknownTripRaisesError [
	self should: [ service removeExpense: expense1 fromTrip: 'id-fantome' ] raise: Error
]

{ #category : 'tests - TripApplicationService' }
TripRemoveExpenseTest >> testServiceRemoveExpenseIsPersisted [
	service removeExpense: expense1 fromTrip: tripId.
	self assert: (service findTrip: tripId) expenses size equals: 1
]

{ #category : 'tests - TripApplicationService' }
TripRemoveExpenseTest >> testServiceRemoveExpenseRemovesCorrectOne [
	service removeExpense: expense1 fromTrip: tripId.
	self deny: ((service findTrip: tripId) expenses includes: expense1).
	self assert: ((service findTrip: tripId) expenses includes: expense2)
]

{ #category : 'tests - Trip domain' }
TripRemoveExpenseTest >> testTripRemoveExpenseReducesCount [
	| trip |
	trip := service findTrip: tripId.
	trip removeExpense: expense1 id.
	self assert: trip expenses size equals: 1
]

{ #category : 'tests - Trip domain' }
TripRemoveExpenseTest >> testTripRemoveExpenseRemovesCorrectOne [
	| trip |
	trip := service findTrip: tripId.
	trip removeExpense: expense1 id.
	self assert: (trip expenses includes: expense1) not.
	self assert: (trip expenses includes: expense2)
]

{ #category : 'tests - Trip domain' }
TripRemoveExpenseTest >> testTripRemoveUnknownExpenseRaisesError [

	| trip |
    trip := service findTrip: tripId.
    self should: [ trip removeExpense: 'id-fantome' ] raise: Error
]
