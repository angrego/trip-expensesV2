Class {
	#name : 'TripExpenseFormPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'service',
		'tripId',
		'aliceId',
		'bobId',
		'model',
		'presenter'
	],
	#category : 'TripExpenses-UI-Tests-App',
	#package : 'TripExpenses-UI-Tests',
	#tag : 'App'
}

{ #category : 'running' }
TripExpenseFormPresenterTest >> setUp [
    | trip alice bob |
    service := TripApplicationService withRepository: InMemoryTripRepository new.
    trip  := service createTrip: 'Vacances' currency: 'EUR'.
    alice := service addParticipantByName: 'Alice' toTrip: trip id.
    bob   := service addParticipantByName: 'Bob'   toTrip: trip id.
    tripId  := trip id.
    aliceId := alice id value.
    bobId   := bob id value.
    model := TripExpenseFormModel onService: service tripId: tripId
]

{ #category : 'running' }
TripExpenseFormPresenterTest >> testAddExpenseCreatesExpense [
    model show.
    model addExpense: 'Resto' amount: 90 payerId: aliceId
        weights: { aliceId -> 1. bobId -> 1 }.
    self assert: (service findTrip: tripId) expenses size equals: 1
]

{ #category : 'running' }
TripExpenseFormPresenterTest >> testAddExpenseHidesForm [
    model show.
    model addExpense: 'Resto' amount: 90 payerId: aliceId
        weights: { aliceId -> 1. bobId -> 1 }.
    self deny: model isShowing
]

{ #category : 'running' }
TripExpenseFormPresenterTest >> testAddGiftEntryIncreasesCount [
    model show.
    model addGiftEntry.
    self assert: model giftEntries size equals: 1
]

{ #category : 'running' }
TripExpenseFormPresenterTest >> testHideFormClearsError [
    model show.
    model addExpense: '' amount: 90 payerId: aliceId
        weights: { aliceId -> 1. bobId -> 1 }.
    model hide.
    self assert: model errorMessage isNil
]

{ #category : 'running' }
TripExpenseFormPresenterTest >> testModelIsShownWhenShowCalled [
    model show.
    self assert: model isShowing
]

{ #category : 'running' }
TripExpenseFormPresenterTest >> testModelParticipantEntriesLoadedOnShow [
    model show.
    self assert: model participantEntries size equals: 2
]

{ #category : 'running' }
TripExpenseFormPresenterTest >> testPreferredPresenterClassExists [
    self assert: TripExpenseFormPresenter notNil
]

{ #category : 'running' }
TripExpenseFormPresenterTest >> testPreferredPresenterClassIsTripExpenseFormPresenter [
    self
        assert: model preferredPresenterClass
        equals: TripExpenseFormPresenter
]
