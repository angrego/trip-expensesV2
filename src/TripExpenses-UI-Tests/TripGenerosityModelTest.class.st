Class {
	#name : 'TripGenerosityModelTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'model',
		'tripId',
		'aliceId',
		'bobId'
	],
	#category : 'TripExpenses-UI-Tests-Balance',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'Balance'
}

{ #category : 'running' }
TripGenerosityModelTest >> setUp [

	| trip alice bob |
	super setUp.
	service := TripApplicationService withRepository:
		           InMemoryTripRepository new.
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	alice := service addParticipantByName: 'Alice' toTrip: trip id.
	bob := service addParticipantByName: 'Bob' toTrip: trip id.
	tripId := trip id.
	aliceId := alice id value.
	bobId := bob id value.
	model := TripGenerosityModel onService: service tripId: tripId
]

{ #category : 'running' }
TripGenerosityModelTest >> testInitialItemsIsEmpty [
    self assert: model items isEmpty
]

{ #category : 'running' }
TripGenerosityModelTest >> testItemsAreTripGenerosityItemModels [
    model load.
    self assert: (model items allSatisfy: [ :i |
        i isKindOf: TripGenerosityItemModel ])
]

{ #category : 'running' }
TripGenerosityModelTest >> testItemsSortedByGenerosityDescending [
    "Alice offre 30 à Bob — Alice est plus généreuse."
    | trip alice bob splitRule |
    trip  := service findTrip: tripId.
    alice := trip participants detect: [ :p | p id value = aliceId ].
    bob   := trip participants detect: [ :p | p id value = bobId ].
    splitRule := EqualSplitRule among: {
        ParticipantWeight participant: alice.
        ParticipantWeight participant: bob }.
    service addExpense: (Expense
        description: 'Resto'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
        splitRule: splitRule
        gifts: { Gift from: alice to: bob amount: (Money amount: 30 currency: 'EUR') }
        date: Date today) toTrip: tripId.
    model load.
    self assert: model items first participantName equals: 'Alice'
]

{ #category : 'running' }
TripGenerosityModelTest >> testLoadAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model load.
    self assert: announced
]

{ #category : 'running' }
TripGenerosityModelTest >> testLoadCreatesOneItemPerParticipant [
    model load.
    self assert: model items size equals: 2
]

{ #category : 'running' }
TripGenerosityModelTest >> testPreferredPresenterClass [
    self
        assert: model preferredPresenterClass
        equals: TripGenerosityPresenter
]
