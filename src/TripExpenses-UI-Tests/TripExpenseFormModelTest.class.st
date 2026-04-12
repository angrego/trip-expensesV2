Class {
	#name : 'TripExpenseFormModelTest',
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
TripExpenseFormModelTest >> setUp [

	| trip alice bob charlie |
	super setUp.
	service := TripApplicationService withRepository:
		           InMemoryTripRepository new.
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	alice := service addParticipantByName: 'Alice' toTrip: trip id.
	bob := service addParticipantByName: 'Bob' toTrip: trip id.
	charlie := service addParticipantByName: 'charlie' toTrip: trip id.
	tripId := trip id.
	aliceId := alice id value.
	bobId := bob id value.
	charlieId := charlie id value.
	model := TripExpenseFormModel onService: service tripId: tripId
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddExpenseCreatesExpenseOnTrip [
    | trip |
    model show.
    model addExpense: 'Resto' amount: 90 payerId: aliceId.
    trip := service findTrip: tripId.
    self assert: trip expenses size equals: 1
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddExpenseHidesForm [
    model show.
    model addExpense: 'Resto' amount: 90 payerId: aliceId.
    self deny: model isShowing
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddExpenseWithEmptyDescriptionKeepsFormShowing [
    model show.
    model addExpense: '' amount: 90 payerId: aliceId.
    self assert: model isShowing
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddExpenseWithZeroAmountKeepsFormShowing [
    model show.
    model addExpense: 'Resto' amount: 0 payerId: aliceId.
    self assert: model isShowing
]

{ #category : 'running' }
TripExpenseFormModelTest >> testHideFormClearsIsShowing [
    model show.
    model hide.
    self deny: model isShowing
]

{ #category : 'running' }
TripExpenseFormModelTest >> testInitiallyNotShowing [
    self deny: model isShowing
]

{ #category : 'running' }
TripExpenseFormModelTest >> testShowFormAllParticipantsIncludedByDefault [
    model show.
    model participantEntries do: [ :e |
        self assert: e included ]
]

{ #category : 'running' }
TripExpenseFormModelTest >> testShowFormDefaultWeightIsOne [
    model show.
    model participantEntries do: [ :e |
        self assert: e weight equals: 1 ]
]

{ #category : 'running' }
TripExpenseFormModelTest >> testShowFormLoadsParticipants [

	model show.
	self assert: model participantEntries size equals: 3
]

{ #category : 'running' }
TripExpenseFormModelTest >> testShowFormSetsIsShowing [
    model show.
    self assert: model isShowing
]
