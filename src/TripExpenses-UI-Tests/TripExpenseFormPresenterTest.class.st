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
    model addExpense: 'Resto' amount: 90 payerId: aliceId.
    self assert: (service findTrip: tripId) expenses size equals: 1
]

{ #category : 'running' }
TripExpenseFormPresenterTest >> testAddExpenseHidesForm [
    model show.
    model addExpense: 'Resto' amount: 90 payerId: aliceId.
    self deny: model isShowing
]

{ #category : 'running' }
TripExpenseFormPresenterTest >> testAddExpenseUsesCurrentParticipantWeights [
    "Les poids sont dans participantEntries — pas besoin de les passer explicitement."
    | trip |
    model show.
    model setCurrentPayerId: aliceId.
    model setCurrentAmount: 90.
    "Bob exclu"
    (model participantEntries detect: [ :e | e participantId = bobId ])
        included: false.
    model addExpense: 'Resto' amount: 90 payerId: aliceId.
    trip := service findTrip: tripId.
    "Seule Alice est dans la split rule"
    self assert: trip expenses first splitRule participantWeights size equals: 1
]

{ #category : 'running' }
TripExpenseFormPresenterTest >> testAddExpenseWithModifiedWeightUsesNewWeight [
    | trip expense alice |
    model show.
    (model participantEntries detect: [ :e | e participantId = aliceId ])
        weight: 2.
    model addExpense: 'Resto' amount: 90 payerId: aliceId.
    trip    := service findTrip: tripId.
    expense := trip expenses first.
    alice   := trip participants detect: [ :p | p id value = aliceId ].
    self assert: (expense balanceFor: alice) amount equals: 30
]

{ #category : 'running' }
TripExpenseFormPresenterTest >> testHideFormClearsError [
    model show.
    model addExpense: '' amount: 90 payerId: aliceId.
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
