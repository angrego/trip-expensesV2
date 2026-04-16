Class {
	#name : 'TripExpenseFormModelWeightTest',
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
TripExpenseFormModelWeightTest >> setUp [

	| trip alice bob charlie |
	super setUp.
	service := TripApplicationService withRepository:
		           InMemoryTripRepository new.
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	alice := service addParticipantByName: 'Alice' toTrip: trip id.
	bob := service addParticipantByName: 'Bob' toTrip: trip id.
	charlie := service addParticipantByName: 'Charlie' toTrip: trip id.
	tripId := trip id.
	aliceId := alice id value.
	bobId := bob id value.
	charlieId := charlie id value.
	model := TripExpenseFormModel onService: service tripId: tripId.
	model show
]

{ #category : 'running' }
TripExpenseFormModelWeightTest >> testAddExpenseExcludedParticipantHasWeightZero [
    | trip bob expense |
    model participantEntries
        detect: [ :e | e participantId = bobId ]
        ifFound: [ :e | e included: false ].
    model addExpense: 'Resto' amount: 90 payerId: aliceId.
    trip    := service findTrip: tripId.
    bob     := trip participants detect: [ :p | p id value = bobId ].
    expense := trip expenses first.
    self assert: (expense balanceFor: bob) amount equals: 0
]

{ #category : 'running' }
TripExpenseFormModelWeightTest >> testAllParticipantsIncludedByDefault [
    model participantEntries do: [ :entry |
        self assert: entry included ]
]

{ #category : 'running' }
TripExpenseFormModelWeightTest >> testCurrentParticipantWeightsIncludedUsesWeight [
    | weights aliceWeight |
    model participantEntries
        detect: [ :e | e participantId = aliceId ]
        ifFound: [ :e | e weight: 3 ].
    weights     := model currentParticipantWeights.
    aliceWeight := (weights detect: [ :pair | pair key = aliceId ]) value.
    self assert: aliceWeight equals: 3
]

{ #category : 'running' }
TripExpenseFormModelWeightTest >> testDefaultWeightIsOne [
    model participantEntries do: [ :entry |
        self assert: entry weight equals: 1 ]
]

{ #category : 'running' }
TripExpenseFormModelWeightTest >> testExcludeParticipantSetsIncludedFalse [
    | entry |
    model participantEntries
        detect: [ :e | e participantId = bobId ]
        ifFound: [ :e | e included: false ].
    entry := model participantEntries detect: [ :e | e participantId = bobId ].
    self deny: entry included
]

{ #category : 'running' }
TripExpenseFormModelWeightTest >> testParticipantFormEntriesExposeName [
    | names |
    names := model participantEntries collect: [ :e | e name ].
    self assert: (names includes: 'Alice').
    self assert: (names includes: 'Bob').
    self assert: (names includes: 'Charlie')
]

{ #category : 'running' }
TripExpenseFormModelWeightTest >> testParticipantFormEntriesExposeParticipantId [
    model participantEntries do: [ :entry |
        self assert: entry participantId isNotNil.
        self deny: entry participantId isEmpty ]
]

{ #category : 'running' }
TripExpenseFormModelWeightTest >> testParticipantFormEntriesHasOneEntryPerParticipant [
    self assert: model participantEntries size equals: 3
]

{ #category : 'running' }
TripExpenseFormModelWeightTest >> testReincludeParticipantSetsIncludedTrue [
    | entry |
    model participantEntries
        detect: [ :e | e participantId = bobId ]
        ifFound: [ :e | e included: false ].
    model participantEntries
        detect: [ :e | e participantId = bobId ]
        ifFound: [ :e | e included: true ].
    entry := model participantEntries detect: [ :e | e participantId = bobId ].
    self assert: entry included
]

{ #category : 'running' }
TripExpenseFormModelWeightTest >> testSetWeightUpdatesEntry [
    | entry |
    model participantEntries
        detect: [ :e | e participantId = aliceId ]
        ifFound: [ :e | e weight: 3 ].
    entry := model participantEntries detect: [ :e | e participantId = aliceId ].
    self assert: entry weight equals: 3
]

{ #category : 'running' }
TripExpenseFormModelWeightTest >> testShowExpenseFormResetsEntries [
    model participantEntries
        detect: [ :e | e participantId = bobId ]
        ifFound: [ :e | e included: false ].
    model participantEntries
        detect: [ :e | e participantId = aliceId ]
        ifFound: [ :e | e weight: 5 ].
    model show.
    model participantEntries do: [ :entry |
        self assert: entry included.
        self assert: entry weight equals: 1 ]
]
