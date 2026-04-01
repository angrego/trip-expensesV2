Class {
	#name : 'TripExpensesServerAppTest',
	#superclass : 'TestCase',
	#instVars : [
		'app',
		'repository'
	],
	#category : 'TripExpenses-Server-tests',
	#package : 'TripExpenses-Server-tests'
}

{ #category : 'helpers' }
TripExpensesServerAppTest >> addParticipantMessage: aName toTrip: aTripId [
	^ Dictionary new
		at: 'type'   put: 'addParticipant';
		at: 'tripId' put: aTripId;
		at: 'name'   put: aName;
		yourself
]

{ #category : 'helpers' }
TripExpensesServerAppTest >> createTripAndTwoParticipants [
	"Retourne { tripId. aliceId. bobId }"
	| tripId aliceId bobId |
	tripId := (app handleMessage: self createTripMessage) at: 'tripId'.
	aliceId := (app handleMessage: (self addParticipantMessage: 'Alice' toTrip: tripId)) at: 'participantId'.
	bobId   := (app handleMessage: (self addParticipantMessage: 'Bob'   toTrip: tripId)) at: 'participantId'.
	^ Array with: tripId with: aliceId with: bobId
]

{ #category : 'helpers' }
TripExpensesServerAppTest >> createTripMessage [
	^ Dictionary new
		at: 'type'     put: 'createTrip';
		at: 'name'     put: 'Vacances';
		at: 'currency' put: 'EUR';
		yourself
]

{ #category : 'helpers' }
TripExpensesServerAppTest >> expenseMessage: description amount: amount tripId: tripId payerId: payerId participantIds: pIds [
	^ Dictionary new
		at: 'type'        put: 'addExpense';
		at: 'tripId'      put: tripId;
		at: 'description' put: description;
		at: 'amount'      put: amount;
		at: 'currency'    put: 'EUR';
		at: 'payments'    put: {
			Dictionary new
				at: 'participantId' put: payerId;
				at: 'amount'        put: amount;
				yourself };
		at: 'splitRule'   put: (pIds collect: [ :id |
			Dictionary new
				at: 'participantId' put: id;
				at: 'weight'        put: 1;
				yourself ]);
		at: 'gifts'       put: #();
		yourself
]

{ #category : 'running' }
TripExpensesServerAppTest >> setUp [

	repository := InMemoryTripRepository new.
	app := TripExpensesServerApp withRepository: repository
]

{ #category : 'test - addParticipant' }
TripExpensesServerAppTest >> testAddDuplicateParticipantReturnsError [
	| tripId response|
	tripId := (app handleMessage: self createTripMessage) at: 'tripId'.
	app handleMessage: (self addParticipantMessage: 'Alice' toTrip: tripId).

	response := app handleMessage: (self addParticipantMessage: 'Alice' toTrip: tripId).
	self assert: (response at: 'type') equals: 'error'
]

{ #category : 'test - addExpense' }
TripExpensesServerAppTest >> testAddExpenseAmountMatchesPayments [
    "Le total doit correspondre à la somme des paiements"
    | ctx response |
    ctx := self createTripAndTwoParticipants.
    response := app handleMessage: (Dictionary new
        at: 'type'        put: 'addExpense';
        at: 'tripId'      put: ctx first;
        at: 'description' put: 'Test';
        at: 'amount'      put: 100;
        at: 'currency'    put: 'EUR';
        at: 'payments'    put: { Dictionary new
            at: 'participantId' put: ctx second;
            at: 'amount'        put: 60;  "← ne correspond pas à 100"
            yourself };
        at: 'splitRule'   put: { Dictionary new
            at: 'participantId' put: ctx second;
            at: 'weight'        put: 1;
            yourself };
        at: 'gifts'       put: #();
        yourself).
    self assert: (response at: 'type') equals: 'error'
]

{ #category : 'test - addExpense' }
TripExpensesServerAppTest >> testAddExpenseReturnsCorrectType [
	| ctx response |
	ctx := self createTripAndTwoParticipants.
	response := app handleMessage:
		(self expenseMessage: 'Resto' amount: 60 tripId: ctx first payerId: ctx second participantIds: { ctx second. ctx third }).
	self assert: (response at: 'type') equals: 'expenseAdded'
]

{ #category : 'test - addExpense' }
TripExpensesServerAppTest >> testAddExpenseReturnsExpenseId [
	| ctx response |
	ctx := self createTripAndTwoParticipants.
	response := app handleMessage:
		(self expenseMessage: 'Resto' amount: 60 tripId: ctx first payerId: ctx second participantIds: { ctx second. ctx third }).
	self assert: (response includesKey: 'expenseId')
]

{ #category : 'test - addExpense' }
TripExpensesServerAppTest >> testAddExpenseReturnsTripId [
	| ctx response |
	ctx := self createTripAndTwoParticipants.
	response := app handleMessage:
		(self expenseMessage: 'Resto' amount: 60 tripId: ctx first payerId: ctx second participantIds: { ctx second. ctx third }).
	self assert: (response at: 'tripId') equals: ctx first
]

{ #category : 'test - addExpense' }
TripExpensesServerAppTest >> testAddExpenseToUnknownTripReturnsError [
	| response |
	response := app handleMessage:
		(self expenseMessage: 'Resto' amount: 60 tripId: 'id-fantome' payerId: 'p1' participantIds: { 'p1' }).
	self assert: (response at: 'type') equals: 'error'
]

{ #category : 'test - addExpense' }
TripExpensesServerAppTest >> testAddExpenseWithEmptyDescriptionReturnsError [
    | ctx response |
    ctx := self createTripAndTwoParticipants.
    response := app handleMessage:
        (self expenseMessage: '' amount: 60 tripId: ctx first
            payerId: ctx second participantIds: { ctx second. ctx third }).
    self assert: (response at: 'type') equals: 'error'
]

{ #category : 'test - addExpense' }
TripExpensesServerAppTest >> testAddExpenseWithGift [
    | ctx giftDict response |
    ctx := self createTripAndTwoParticipants.
    giftDict := Dictionary new
        at: 'fromId'  put: ctx second;
        at: 'toId'    put: ctx third;
        at: 'amount'  put: 10;
        yourself.
    response := app handleMessage: (Dictionary new
        at: 'type'        put: 'addExpense';
        at: 'tripId'      put: ctx first;
        at: 'description' put: 'Resto avec cadeau';
        at: 'amount'      put: 60;
        at: 'currency'    put: 'EUR';
        at: 'payments'    put: { Dictionary new
            at: 'participantId' put: ctx second;
            at: 'amount'        put: 60;
            yourself };
        at: 'splitRule'   put: { 
            Dictionary new at: 'participantId' put: ctx second; at: 'weight' put: 1; yourself.
            Dictionary new at: 'participantId' put: ctx third;  at: 'weight' put: 1; yourself };
        at: 'gifts'       put: { giftDict };
        yourself).
    self assert: (response at: 'type') equals: 'expenseAdded'
]

{ #category : 'test - addExpense' }
TripExpensesServerAppTest >> testAddExpenseWithUnknownParticipantReturnsError [
	| tripId aliceId response |
	tripId  := (app handleMessage: self createTripMessage) at: 'tripId'.
	aliceId := (app handleMessage: (self addParticipantMessage: 'Alice' toTrip: tripId)) at: 'participantId'.
	response := app handleMessage:
		(self expenseMessage: 'Resto' amount: 60 tripId: tripId payerId: aliceId participantIds: { aliceId. 'id-fantome' }).
	self assert: (response at: 'type') equals: 'error'
]

{ #category : 'test - addExpense' }
TripExpensesServerAppTest >> testAddExpenseWithZeroAmountReturnsError [
    | ctx response |
    ctx := self createTripAndTwoParticipants.
    response := app handleMessage:
        (self expenseMessage: 'Test' amount: 0 tripId: ctx first
            payerId: ctx second participantIds: { ctx second. ctx third }).
    self assert: (response at: 'type') equals: 'error'
]

{ #category : 'test - addParticipant' }
TripExpensesServerAppTest >> testAddParticipantReturnsCorrectType [
	| tripId response |
	tripId := (app handleMessage: self createTripMessage) at: 'tripId'.
	response := app handleMessage: (self addParticipantMessage: 'Alice' toTrip: tripId).
	self assert: (response at: 'type') equals: 'participantAdded'
]

{ #category : 'test - addParticipant' }
TripExpensesServerAppTest >> testAddParticipantReturnsName [
	| tripId response |
	tripId := (app handleMessage: self createTripMessage) at: 'tripId'.
	response := app handleMessage: (self addParticipantMessage: 'Alice' toTrip: tripId).
	self assert: (response at: 'name') equals: 'Alice'
]

{ #category : 'test - addParticipant' }
TripExpensesServerAppTest >> testAddParticipantReturnsParticipantId [
	| tripId response |
	tripId := (app handleMessage: self createTripMessage) at: 'tripId'.
	response := app handleMessage: (self addParticipantMessage: 'Alice' toTrip: tripId).
	self assert: (response includesKey: 'participantId').
	self assert: (response at: 'participantId') isNotEmpty
]

{ #category : 'test - addParticipant' }
TripExpensesServerAppTest >> testAddParticipantReturnsTripId [
	| tripId response |
	tripId := (app handleMessage: self createTripMessage) at: 'tripId'.
	response := app handleMessage: (self addParticipantMessage: 'Alice' toTrip: tripId).
	self assert: (response at: 'tripId') equals: tripId
]

{ #category : 'test - addParticipant' }
TripExpensesServerAppTest >> testAddParticipantToUnknownTripReturnsError [
	| response |
	response := app handleMessage: (self addParticipantMessage: 'Alice' toTrip: 'id-fantome').
	self assert: (response at: 'type') equals: 'error'
]

{ #category : 'tests - creation' }
TripExpensesServerAppTest >> testAllTripsAfterOneCreate [
	| response |
	app handleMessage: self createTripMessage.
	response := app handleMessage: (Dictionary new at: 'type' put: 'allTrips'; yourself).
	self assert: (response at: 'trips') size equals: 1
]

{ #category : 'tests - creation' }
TripExpensesServerAppTest >> testAllTripsEmptyInitially [
	| response |
	response := app handleMessage: (Dictionary new at: 'type' put: 'allTrips'; yourself).
	self assert: (response at: 'trips') isEmpty
]

{ #category : 'tests - creation' }
TripExpensesServerAppTest >> testAllTripsEntryHasIdAndName [
	| trips first |
	app handleMessage: self createTripMessage.
	trips := (app handleMessage: (Dictionary new at: 'type' put: 'allTrips'; yourself)) at: 'trips'.
	first := trips first.
	self assert: (first includesKey: 'id').
	self assert: (first at: 'name') equals: 'Vacances'
]

{ #category : 'tests - creation' }
TripExpensesServerAppTest >> testAllTripsReturnsCorrectType [
	| response |
	response := app handleMessage: (Dictionary new at: 'type' put: 'allTrips'; yourself).
	self assert: (response at: 'type') equals: 'trips'
]

{ #category : 'tests - creation' }
TripExpensesServerAppTest >> testCreateTripPersistsInRepository [
	app handleMessage: self createTripMessage.
	self assert: repository size equals: 1
]

{ #category : 'tests - creation' }
TripExpensesServerAppTest >> testCreateTripResponseHasCurrency [
	| response |
	response := app handleMessage: self createTripMessage.
	self assert: (response at: 'currency') equals: 'EUR'
]

{ #category : 'tests - creation' }
TripExpensesServerAppTest >> testCreateTripResponseHasName [
	| response |
	response := app handleMessage: self createTripMessage.
	self assert: (response at: 'name') equals: 'Vacances'
]

{ #category : 'tests - creation' }
TripExpensesServerAppTest >> testCreateTripResponseHasTripId [
	| response |
	response := app handleMessage: self createTripMessage.
	self assert: (response includesKey: 'tripId').
	self assert: (response at: 'tripId') isNotEmpty
]

{ #category : 'tests - creation' }
TripExpensesServerAppTest >> testCreateTripReturnsTypeTripCreated [
	| response |
	response := app handleMessage: self createTripMessage.
	self assert: (response at: 'type') equals: 'tripCreated'
]

{ #category : 'test - ErrorHandling' }
TripExpensesServerAppTest >> testDomainExceptionsDoNotPropagate [
	"Une erreur domain doit retourner une réponse error, pas lever une exception"
	self shouldnt: [
		app handleMessage: (Dictionary new
			at: 'type'   put: 'findTrip';
			at: 'tripId' put: 'id-fantome';
			yourself)
	] raise: Error
]

{ #category : 'test - ErrorHandling' }
TripExpensesServerAppTest >> testErrorResponseHasMessageKey [
	| response |
	response := app handleMessage: (Dictionary new at: 'type' put: 'typeInconnu'; yourself).
	self assert: (response includesKey: 'message')
]

{ #category : 'test - findTrip' }
TripExpensesServerAppTest >> testFindTripResponseContainsBalances [
    | ctx tripId response trip |
    ctx    := self createTripAndTwoParticipants.
    tripId := ctx first.
    app handleMessage:
        (self expenseMessage: 'Resto' amount: 60 tripId: tripId
            payerId: ctx second participantIds: { ctx second. ctx third }).
    response := app handleMessage: (Dictionary new
        at: 'type'   put: 'findTrip';
        at: 'tripId' put: tripId;
        yourself).
    trip := response at: 'trip'.
    self assert: (trip includesKey: 'balances').
    self assert: (trip at: 'balances') isNotEmpty
]

{ #category : 'test - findTrip' }
TripExpensesServerAppTest >> testFindTripResponseContainsSettlements [
    | ctx tripId response trip |
    ctx    := self createTripAndTwoParticipants.
    tripId := ctx first.
    app handleMessage:
        (self expenseMessage: 'Resto' amount: 60 tripId: tripId
            payerId: ctx second participantIds: { ctx second. ctx third }).
    response := app handleMessage: (Dictionary new
        at: 'type'   put: 'findTrip';
        at: 'tripId' put: tripId;
        yourself).
    trip := response at: 'trip'.
    self assert: (trip includesKey: 'settlements')
]

{ #category : 'test - findTrip' }
TripExpensesServerAppTest >> testFindTripReturnsCorrectName [
	| tripId response |
	tripId := (app handleMessage: self createTripMessage) at: 'tripId'.
	response := app handleMessage: (Dictionary new
		at: 'type'   put: 'findTrip';
		at: 'tripId' put: tripId;
		yourself).
	self assert: ((response at: 'trip') at: 'name') equals: 'Vacances'
]

{ #category : 'test - findTrip' }
TripExpensesServerAppTest >> testFindTripReturnsCorrectType [
	| tripId response |
	tripId := (app handleMessage: self createTripMessage) at: 'tripId'.
	response := app handleMessage: (Dictionary new
		at: 'type'   put: 'findTrip';
		at: 'tripId' put: tripId;
		yourself).
	self assert: (response at: 'type') equals: 'trip'
]

{ #category : 'test - findTrip' }
TripExpensesServerAppTest >> testFindUnknownTripReturnsError [
	| response |
	response := app handleMessage: (Dictionary new
		at: 'type'   put: 'findTrip';
		at: 'tripId' put: 'id-qui-nexiste-pas';
		yourself).
	self assert: (response at: 'type') equals: 'error'
]

{ #category : 'test - ErrorHandling' }
TripExpensesServerAppTest >> testMissingTypeKeyReturnsError [
	| response |
	response := app handleMessage: Dictionary new.
	self assert: (response at: 'type') equals: 'error'
]

{ #category : 'test - addParticipant' }
TripExpensesServerAppTest >> testTripParticipantCountIncreasesAfterAdd [
	| tripId response |
	tripId := (app handleMessage: self createTripMessage) at: 'tripId'.
	app handleMessage: (self addParticipantMessage: 'Alice' toTrip: tripId).
	response := app handleMessage: (Dictionary new
		at: 'type'   put: 'findTrip';
		at: 'tripId' put: tripId;
		yourself).
	self assert: ((response at: 'trip') at: 'participantCount') equals: 1
]

{ #category : 'tests - creation' }
TripExpensesServerAppTest >> testTwoCreatedTripsHaveDifferentIds [
	| id1 id2 |
	id1 := (app handleMessage: self createTripMessage) at: 'tripId'.
	id2 := (app handleMessage: self createTripMessage) at: 'tripId'.
	self deny: id1 equals: id2
]

{ #category : 'test - ErrorHandling' }
TripExpensesServerAppTest >> testUnknownMessageTypeReturnsError [
	| response |
	response := app handleMessage: (Dictionary new at: 'type' put: 'typeInconnu'; yourself).
	self assert: (response at: 'type') equals: 'error'
]
