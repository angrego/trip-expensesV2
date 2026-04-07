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
TripExpenseFormModelTest >> testAddExpenseWithGlobalShareGiftAliceBalanceIsCorrect [
    "Alice paie 400, part 100, offre 200 → solde +100"
    | trip expense aliceParticipant |
    model show.
    model addGiftEntry.
    model setGiftEntry: model giftEntries first fromId: aliceId.
    model setGiftEntry: model giftEntries first mode: #globalShare.
    model setGiftEntry: model giftEntries first amount: 200.
    model
        addExpense: 'Gite'
        amount: 400
        payerId: aliceId
        weights: { aliceId -> 1. bobId -> 1. charlieId -> 2 }.
    trip := service findTrip: tripId.
    expense := trip expenses first.
    aliceParticipant := trip participants detect: [ :p | p id value = aliceId ].
    self assert: (expense balanceFor: aliceParticipant) amount equals: 100
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddExpenseWithGlobalShareGiftDistributesAmount [
    "Alice paie 400, offre 200 globalement.
     Bob poids 1, Charlie poids 2.
     Bob reçoit 200 * 1/3 ≈ 66.67, Charlie reçoit 200 * 2/3 ≈ 133.33"
    | trip expense bobParticipant charlieParticipant |
    model show.
    model addGiftEntry.
    model setGiftEntry: model giftEntries first fromId: aliceId.
    model setGiftEntry: model giftEntries first mode: #globalShare.
    model setGiftEntry: model giftEntries first amount: 200.
    model
        addExpense: 'Gite'
        amount: 400
        payerId: aliceId
        weights: { aliceId -> 1. bobId -> 1. charlieId -> 2 }.
    trip := service findTrip: tripId.
    expense := trip expenses first.
    self assert: expense gifts size equals: 2.
    bobParticipant := trip participants detect: [ :p | p id value = bobId ].
    charlieParticipant := trip participants detect: [ :p | p id value = charlieId ].
    self assert: (expense gifts detect: [ :g | g to = bobParticipant ]) amount
        equals: (Money amount: 200/3 currency: 'EUR').
    self assert: (expense gifts detect: [ :g | g to = charlieParticipant ]) amount
        equals: (Money amount: 400/3 currency: 'EUR')
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddExpenseWithZeroAmountKeepsFormShowing [
    model show.
    model addExpense: 'Resto' amount: 0 payerId: aliceId.
    self assert: model isShowing
]

{ #category : 'running' }
TripExpenseFormModelTest >> testAddGiftEntryIncreasesCount [
    model show.
    model addGiftEntry.
    self assert: model giftEntries size equals: 1
]

{ #category : 'running' }
TripExpenseFormModelTest >> testGiftEntriesInitiallyEmpty [
    model show.
    self assert: model giftEntries isEmpty
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
TripExpenseFormModelTest >> testSetGiftFromIdUpdatesEntry [
    | entry |
model show.
    model addGiftEntry.
    entry := model giftEntries first.
    model setGiftEntry: entry fromId: aliceId.
    self assert: entry fromId equals: aliceId
]

{ #category : 'running' }
TripExpenseFormModelTest >> testSetGiftToIdUpdatesEntry [
    | entry |
    model show.
    model addGiftEntry.
    entry := model giftEntries first.
    model setGiftEntry: entry toId: bobId.
    self assert: entry toId equals: bobId
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
TripExpenseFormModelTest >> testShowFormResetsGiftEntries [
    model show.
    model addGiftEntry.
    model hide.
    model show.
    self assert: model giftEntries isEmpty
]

{ #category : 'running' }
TripExpenseFormModelTest >> testShowFormSetsIsShowing [
    model show.
    self assert: model isShowing
]
