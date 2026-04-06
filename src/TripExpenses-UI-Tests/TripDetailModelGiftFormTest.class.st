Class {
	#name : 'TripDetailModelGiftFormTest',
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
TripDetailModelGiftFormTest >> setUp [

	| trip alice bob charlie |
	service := TripApplicationService withRepository:
		           InMemoryTripRepository new.
	trip := service createTrip: 'Vacances' currency: 'EUR'.
	alice := service addParticipant: (Participant name:'Alice') toTrip: trip id.
	bob := service addParticipant: (Participant name:'Bob') toTrip: trip id.
	charlie := service addParticipant: (Participant name:'Charlie') toTrip: trip id.
	tripId := trip id.
	aliceId := alice id value.
	bobId := bob id value.
	charlieId := charlie id value.
	model := TripDetailModel onService: service tripId: tripId.
	model showExpenseForm
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testAddExpenseWithFixedGiftCreatesGift [
    "Alice paie 90, offre 30 fixes à Bob."
    | trip expense |
    model addGiftEntry.
    model setGiftEntry: model giftEntries first fromId: aliceId.
    model setGiftEntry: model giftEntries first toId: bobId.
    model setGiftEntry: model giftEntries first amount: 30.
    model setGiftEntry: model giftEntries first mode: #fixed.
    model
        addExpenseDescription: 'Resto'
        amount: 90
        payerId: aliceId
        participantWeights: model currentParticipantWeights.
    trip    := service findTrip: tripId.
    expense := trip expenses first.
    self assert: expense gifts size equals: 1.
    self assert: expense gifts first from name equals: 'Alice'.
    self assert: expense gifts first to   name equals: 'Bob'.
    self assert: expense gifts first amount equals: (Money amount: 30 currency: 'EUR')
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testAddExpenseWithIncompleteGiftEntryIsIgnored [
    "Une entry sans fromId ni toId est ignorée — pas d'erreur."
    model addGiftEntry.
    self shouldnt: [
        model
            addExpenseDescription: 'Resto'
            amount: 90
            payerId: aliceId
            participantWeights: model currentParticipantWeights ]
    raise: Error
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testAddExpenseWithNoGiftEntriesCreatesNoGifts [
    | trip expense |
    model
        addExpenseDescription: 'Resto'
        amount: 90
        payerId: aliceId
        participantWeights: model currentParticipantWeights.

    trip    := service findTrip: tripId.
    expense := trip expenses first.
    self assert: expense gifts isEmpty
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testAddExpenseWithShareGiftCalculatesAmount [
    "Alice paie 90, offre la part de Bob (poids égaux → 30)."
    | trip expense |
    model addGiftEntry.
    model setGiftEntry: model giftEntries first fromId: aliceId.
    model setGiftEntry: model giftEntries first toId: bobId.
    model setGiftEntry: model giftEntries first mode: #share.
    model
        addExpenseDescription: 'Resto'
        amount: 90
        payerId: aliceId
        participantWeights: model currentParticipantWeights.
    trip    := service findTrip: tripId.
    expense := trip expenses first.
    self assert: expense gifts size equals: 1.
    self assert: expense gifts first amount equals: (Money amount: 30 currency: 'EUR')
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testAddGiftEntryAnnouncesValueChanged [
    | announced |
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model addGiftEntry.
    self assert: announced
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testAddGiftEntryDefaultAmountIsNil [
    model addGiftEntry.
    self assert: model giftEntries first amount isNil
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testAddGiftEntryDefaultFromIsNil [
    model addGiftEntry.
    self assert: model giftEntries first fromId isNil
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testAddGiftEntryDefaultModeIsFixed [
    model addGiftEntry.
    self assert: model giftEntries first mode equals: #fixed
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testAddGiftEntryDefaultToIsNil [
    model addGiftEntry.
    self assert: model giftEntries first toId isNil
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testAddGiftEntryIncreasesCount [
    model addGiftEntry.
    self assert: model giftEntries size equals: 1
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testAddMultipleGiftEntries [
    model addGiftEntry.
    model addGiftEntry.
    self assert: model giftEntries size equals: 2
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testGiftEntriesInitiallyEmpty [
    self assert: model giftEntries isEmpty
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testGiftEntriesIsEmptyCollectionNotNil [
    self assert: model giftEntries isNil not
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testGiftEntryHasUniqueId [
    | ids |
    model addGiftEntry.
    model addGiftEntry.

    ids := model giftEntries collect: [ :e | e entryId ].
    self assert: ids asSet size equals: 2
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testGiftEntryIdIsNotNil [
    model addGiftEntry.
    self assert: model giftEntries first entryId isNotNil
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testRemoveGiftEntryAnnouncesValueChanged [
    | announced entryId |
    model addGiftEntry.
    entryId := model giftEntries first entryId.
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model removeGiftEntryId: entryId.
    self assert: announced
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testRemoveGiftEntryDecreasesCount [

    | entryId |
    model addGiftEntry.
    model addGiftEntry.
    entryId := model giftEntries first entryId.
    model removeGiftEntryId: entryId.
    self assert: model giftEntries size equals: 1
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testSetGiftAmount [
    model addGiftEntry.
    model setGiftEntry: model giftEntries first amount: 30.
    self assert: model giftEntries first amount equals: 30
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testSetGiftFromId [
    model addGiftEntry.
    model setGiftEntry: model giftEntries first fromId: aliceId.
    self assert: model giftEntries first fromId equals: aliceId
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testSetGiftModeAnnouncesValueChanged [
    | announced |
    model addGiftEntry.
    announced := false.
    model when: ValueChanged do: [ announced := true ].
    model setGiftEntry: model giftEntries first mode: #share.
    self assert: announced
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testSetGiftModeToShare [
    model addGiftEntry.
    model setGiftEntry: model giftEntries first mode: #share.
    self assert: model giftEntries first mode equals: #share
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testSetGiftToId [
    model addGiftEntry.
    model setGiftEntry: model giftEntries first toId: bobId.
    self assert: model giftEntries first toId equals: bobId
]

{ #category : 'running' }
TripDetailModelGiftFormTest >> testShowExpenseFormResetsGiftEntries [
    model addGiftEntry.
    model addGiftEntry.
    model hideExpenseForm.
    model showExpenseForm.
    self assert: model giftEntries isEmpty
]
