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
super setUp .
    service := TripApplicationService withRepository: InMemoryTripRepository new.
    trip := service createTrip: 'Vacances' currency: 'EUR'.
    alice   := service addParticipant: (Participant name: 'Alice')   toTrip: trip id.
    bob     := service addParticipant: (Participant name: 'Bob')     toTrip: trip id.
    charlie := service addParticipant: (Participant name: 'Charlie') toTrip: trip id.
    tripId    := trip id.
    aliceId   := alice id value.
    bobId     := bob id value.
    charlieId := charlie id value.
    model := TripDetailModel onService: service tripId: tripId.
    model showExpenseForm.
    model expenseFormModel setCurrentPayerId: aliceId.
    model expenseFormModel setCurrentAmount: 90
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
TripDetailModelGiftFormTest >> testShowExpenseFormResetsGiftEntries [
    model addGiftEntry.
    model addGiftEntry.
    model hideExpenseForm.
    model showExpenseForm.
    self assert: model giftEntries isEmpty
]
