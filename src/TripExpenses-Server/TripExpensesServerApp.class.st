Class {
	#name : 'TripExpensesServerApp',
	#superclass : 'CpWebApplication',
	#instVars : [
		'service'
	],
	#category : 'TripExpenses-Server',
	#package : 'TripExpenses-Server'
}

{ #category : 'instance creation' }
TripExpensesServerApp class >> default [
	^ self withRepository: STONTripRepository default
]

{ #category : 'instance creation' }
TripExpensesServerApp class >> withRepository: aRepository [ 
	^ self new
		service: (TripApplicationService withRepository: aRepository);
		yourself
]

{ #category : 'instance creation' }
TripExpensesServerApp class >> withSampleData [
    | repo service trip alice bob charlie rule |
    repo    := InMemoryTripRepository new.
    service := TripApplicationService withRepository: repo.
    trip    := service createTrip: 'Vacances été 2026' currency: 'EUR'.
    alice   := service addParticipant: 'Alice'   toTrip: trip id.
    bob     := service addParticipant: 'Bob'     toTrip: trip id.
    charlie := service addParticipant: 'Charlie' toTrip: trip id.
    trip    := service findTrip: trip id.
    rule := EqualSplitRule among: {
        ParticipantWeight participant: alice.
        ParticipantWeight participant: bob.
        ParticipantWeight participant: charlie }.
    service addExpense: (Expense
        description: 'Restaurant'
        totalAmount: (Money amount: 90 currency: 'EUR')
        payments: { Payment participant: alice amount: (Money amount: 90 currency: 'EUR') }
        splitRule: rule gifts: {} date: Date today) toTrip: trip id.
    ^ self withRepository: repo
]

{ #category : 'private - serialization' }
TripExpensesServerApp >> andleAddExpense: aDict [
	| tripId trip expense |
	tripId  := aDict at: 'tripId'.
	trip    := service findTrip: tripId.
	expense := self buildExpenseFrom: aDict forTrip: trip.
	service addExpense: expense toTrip: tripId.
	^ Dictionary new
		at: 'type'      put: 'expenseAdded';
		at: 'expenseId' put: expense id;
		at: 'tripId'    put: tripId;
		yourself
]

{ #category : 'private - building' }
TripExpensesServerApp >> buildExpenseFrom: aDict forTrip: aTrip [
	| currency totalAmount payments splitRule gifts |
	currency    := aDict at: 'currency'.
	totalAmount := Money amount: (aDict at: 'amount') currency: currency.
	payments    := self buildPaymentsFrom:   (aDict at: 'payments')               currency: currency inTrip: aTrip.
	splitRule   := self buildSplitRuleFrom:  (aDict at: 'splitRule')              currency: currency inTrip: aTrip.
	gifts       := self buildGiftsFrom:      (aDict at: 'gifts' ifAbsent: [ #() ]) currency: currency inTrip: aTrip.
	^ Expense
		description: (aDict at: 'description')
		totalAmount:  totalAmount
		payments:     payments
		splitRule:    splitRule
		gifts:        gifts
		date:         Date today
]

{ #category : 'private - building' }
TripExpensesServerApp >> buildGiftsFrom: giftDicts currency: currency inTrip: aTrip [
	^ giftDicts collect: [ :gd |
		Gift
			from:   (self participantWithId: (gd at: 'fromId') inTrip: aTrip)
			to:     (self participantWithId: (gd at: 'toId')   inTrip: aTrip)
			amount: (Money amount: (gd at: 'amount') currency: currency) ]
]

{ #category : 'private - building' }
TripExpensesServerApp >> buildPaymentsFrom: paymentDicts currency: currency inTrip: aTrip [
	^ paymentDicts collect: [ :pd |
		| participant |
		participant := self participantWithId: (pd at: 'participantId') inTrip: aTrip.
		Payment
			participant: participant
			amount:      (Money amount: (pd at: 'amount') currency: currency) ]
]

{ #category : 'private - building' }
TripExpensesServerApp >> buildSplitRuleFrom: splitDicts currency: currency inTrip: aTrip [
	^ EqualSplitRule among:
		(splitDicts collect: [ :sd |
			| participant weight |
			participant := self participantWithId: (sd at: 'participantId') inTrip: aTrip.
			weight      := sd at: 'weight' ifAbsent: [ 1 ].
			ParticipantWeight participant: participant weight: weight ])
]

{ #category : 'message handling' }
TripExpensesServerApp >> dispatchType: type message: aDict [
	type = 'createTrip'     ifTrue: [ ^ self handleCreateTrip:     aDict ].
	type = 'allTrips'       ifTrue: [ ^ self handleAllTrips              ].
	type = 'findTrip'       ifTrue: [ ^ self handleFindTrip:        aDict ].
	type = 'addParticipant' ifTrue: [ ^ self handleAddParticipant:  aDict ].
	type = 'addExpense'     ifTrue: [ ^ self handleAddExpense:      aDict ].
	^ self errorResponse: 'Unknown message type: ' , type
]

{ #category : 'message handling' }
TripExpensesServerApp >> handleAddExpense: aDict [
	| tripId trip expense |
	tripId  := aDict at: 'tripId'.
	trip    := service findTrip: tripId.
	expense := self buildExpenseFrom: aDict forTrip: trip.
	service addExpense: expense toTrip: tripId.
	^ Dictionary new
		at: 'type'      put: 'expenseAdded';
		at: 'expenseId' put: expense id;
		at: 'tripId'    put: tripId;
		yourself
]

{ #category : 'message handling' }
TripExpensesServerApp >> handleAddParticipant: aDict [

| participant tripId |
	tripId      := aDict at: 'tripId'.
	participant := service
		addParticipant: (aDict at: 'name')
		toTrip:         tripId.
	^ Dictionary new
		at: 'type'          put: 'participantAdded';
		at: 'participantId' put: participant id value;
		at: 'name'          put: participant name;
		at: 'tripId'        put: tripId;
		yourself
]

{ #category : 'message handling' }
TripExpensesServerApp >> handleAllTrips [
	^ Dictionary new
		at: 'type'  put: 'trips';
		at: 'trips' put: (service allTrips collect: [ :t | self serializeTrip: t ]);
		yourself
]

{ #category : 'message handling' }
TripExpensesServerApp >> handleCreateTrip: aDict [
	| trip |
	trip := service
		createTrip:    (aDict at: 'name')
		currency: (aDict at: 'currency').
	^ Dictionary new
		at: 'type'     put: 'tripCreated';
		at: 'tripId'   put: trip id;
		at: 'name'     put: trip name;
		at: 'currency' put: trip currency;
		yourself
]

{ #category : 'message handling' }
TripExpensesServerApp >> handleFindTrip: aDict [
	| trip |
	trip := service findTrip: (aDict at: 'tripId').
	^ Dictionary new
		at: 'type' put: 'trip';
		at: 'trip' put: (self serializeTripFull: trip);
		yourself
]

{ #category : 'message handling' }
TripExpensesServerApp >> handleMessage: aDict [
	| type |
	type := aDict at: 'type' ifAbsent: [ ^ self errorResponse: 'Missing message type' ].
	^ [ self dispatchType: type message: aDict ]
		on: Error
		do: [ :e | self errorResponse: e messageText ]
]

{ #category : 'private - building' }
TripExpensesServerApp >> participantWithId: anIdString inTrip: aTrip [
	^ aTrip participants
		detect: [ :p | p id value = anIdString ]
		ifNone:  [ Error signal: 'Participant introuvable : ' , anIdString ]
]

{ #category : 'private - serialization' }
TripExpensesServerApp >> serializeBalances: balancesDict [
	"Convertit { Participant -> Money } en liste de dicts"
	^ balancesDict associations collect: [ :assoc |
		Dictionary new
			at: 'participantId'   put: assoc key id value;
			at: 'participantName' put: assoc key name;
			at: 'amount'          put: assoc value amount;
			at: 'currency'        put: assoc value currency;
			yourself]
]

{ #category : 'private - serialization' }
TripExpensesServerApp >> serializeExpense: anExpense [
	^ Dictionary new
		at: 'id'          put: anExpense id;
		at: 'description' put: anExpense description;
		at: 'amount'      put: anExpense totalAmount amount;
		at: 'currency'    put: anExpense totalAmount currency;
		at: 'date'        put: anExpense date printString;
		yourself
]

{ #category : 'private - serialization' }
TripExpensesServerApp >> serializeParticipant: aParticipant [
	^ Dictionary new
		at: 'id'   put: aParticipant id value;
		at: 'name' put: aParticipant name;
		yourself
]

{ #category : 'private - serialization' }
TripExpensesServerApp >> serializeSettlement: aSettlement [
	^ Dictionary new
		at: 'from'     put: aSettlement from name;
		at: 'fromId'   put: aSettlement from id value;
		at: 'to'       put: aSettlement to name;
		at: 'toId'     put: aSettlement to id value;
		at: 'amount'   put: aSettlement amount amount;
		at: 'currency' put: aSettlement amount currency;
		yourself
]

{ #category : 'private - serialization' }
TripExpensesServerApp >> serializeTrip: aTrip [
	"Sérialisation légère pour les listes (allTrips)"
	^ Dictionary new
		at: 'id'             put: aTrip id;
		at: 'name'           put: aTrip name;
		at: 'currency'       put: aTrip currency;
		at: 'participantCount' put: aTrip participants size;
		at: 'totalExpenses'  put: aTrip totalExpenses amount;
		yourself
]

{ #category : 'private - serialization' }
TripExpensesServerApp >> serializeTripFull: aTrip [
	^ Dictionary new
		at: 'id'               put: aTrip id;
		at: 'name'             put: aTrip name;
		at: 'currency'         put: aTrip currency;
		at: 'participants'     put: (aTrip participants collect: [ :p | self serializeParticipant: p ]);
		at: 'participantCount' put: aTrip participants size;
		at: 'totalExpenses'    put: aTrip totalExpenses amount;
		at: 'expenses'         put: (aTrip expenses collect: [ :e | self serializeExpense: e ]);
		at: 'balances'         put: (self serializeBalances: aTrip balances);
		at: 'settlements'      put: (aTrip settlements collect: [ :s | self serializeSettlement: s ]);
		yourself
]
