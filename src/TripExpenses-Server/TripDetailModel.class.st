"
I hold all data for a single trip detail view.
I orchestrate participants, expenses, balances and settlements as child CpModels.
"
Class {
	#name : 'TripDetailModel',
	#superclass : 'CpModel',
	#instVars : [
		'service',
		'tripId',
		'tripName',
		'currency',
		'totalExpenses',
		'participants',
		'expenses',
		'balances',
		'settlements',
		'showingExpenseForm',
		'errorMessage'
	],
	#category : 'TripExpenses-Server-TripDetail',
	#package : 'TripExpenses-Server',
	#tag : 'TripDetail'
}

{ #category : 'as yet unclassified' }
TripDetailModel class >> onService: aService tripId: anId [
	^ self new
		service: aService;
		tripId:  anId;
		loadTrip;
		yourself
]

{ #category : 'accessing' }
TripDetailModel >> addExpenseDescription: aDescription amount: anAmount payerId: aPayerId participantIds: aCollection [
		| response |
	(aDescription isNil or: [ aDescription trim isEmpty ]) ifTrue: [
		errorMessage := 'La description ne peut pas être vide'.
		self valueChanged. ^ self ].
	(anAmount isNil or: [ anAmount <= 0 ]) ifTrue: [
		errorMessage := 'Le montant doit être positif'.
		self valueChanged. ^ self ].

	response := service handleMessage: (Dictionary new
		at: 'type'        put: 'addExpense';
		at: 'tripId'      put: tripId;
		at: 'description' put: aDescription trim;
		at: 'amount'      put: anAmount;
		at: 'currency'    put: currency;
		at: 'payments'    put: { Dictionary new
			at: 'participantId' put: aPayerId;
			at: 'amount'        put: anAmount;
			yourself };
		at: 'splitRule'   put: (aCollection collect: [ :id |
			Dictionary new
				at: 'participantId' put: id;
				at: 'weight'        put: 1;
				yourself ]);
		at: 'gifts'       put: #();
		yourself).
	(response at: 'type') = 'error' ifTrue: [
		errorMessage := response at: 'message'.
		self valueChanged. ^ self ].
	showingExpenseForm := false.
	self loadTrip
]

{ #category : 'accessing' }
TripDetailModel >> balances [

	^ balances
]

{ #category : 'accessing' }
TripDetailModel >> currency [

	^ currency
]

{ #category : 'accessing' }
TripDetailModel >> errorMessage [

	^ errorMessage
]

{ #category : 'accessing' }
TripDetailModel >> errorMessage: aStringOrNil [ 
errorMessage := aStringOrNil
]

{ #category : 'accessing' }
TripDetailModel >> expenses [

	^ expenses
]

{ #category : 'accessing' }
TripDetailModel >> hideExpenseForm [
	showingExpenseForm := false.
	errorMessage       := nil.
	self valueChanged
]

{ #category : 'initialization' }
TripDetailModel >> initialize [
	super initialize.
	participants      := OrderedCollection new.
	expenses          := OrderedCollection new.
	balances          := OrderedCollection new.
	settlements       := OrderedCollection new.
	showingExpenseForm := false.
	errorMessage      := nil
]

{ #category : 'accessing' }
TripDetailModel >> loadTrip [
	| response trip |
	response := service handleMessage: (Dictionary new
		at: 'type'   put: 'findTrip';
		at: 'tripId' put: tripId;
		yourself).
	(response at: 'type') = 'error' ifTrue: [
		errorMessage := response at: 'message'.
		self valueChanged.
		^ self ].
	trip         := response at: 'trip'.
	tripName     := trip at: 'name'.
	currency     := trip at: 'currency'.
	totalExpenses := (trip at: 'totalExpenses') printString.
	participants := (trip at: 'participants') collect: [ :d |
		TripParticipantModel fromDict: d ].
	expenses := trip at: 'expenses' ifAbsent: [ #() ].
	expenses := expenses collect: [ :d |
		TripExpenseExpenseItemModel fromDict: d currency: currency ].
	balances := (trip at: 'balances') collect: [ :d |
		TripBalanceItemModel fromDict: d ].
	settlements := (trip at: 'settlements') collect: [ :d |
		TripSettlementItemModel fromDict: d ].
	errorMessage := nil.
	self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> participants [

	^ participants
]

{ #category : 'accessing' }
TripDetailModel >> service [

	^ service
]

{ #category : 'accessing' }
TripDetailModel >> service: aTripExpensesServerApp [
 service := aTripExpensesServerApp
]

{ #category : 'accessing' }
TripDetailModel >> settlements [

	^ settlements
]

{ #category : 'accessing' }
TripDetailModel >> showExpenseForm [
	showingExpenseForm := true.
	errorMessage       := nil.
	self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> showingExpenseForm [

	^ showingExpenseForm
]

{ #category : 'accessing' }
TripDetailModel >> totalExpenses [

	^ totalExpenses
]

{ #category : 'initialization' }
TripDetailModel >> tripId [
 ^ tripId
]

{ #category : 'accessing' }
TripDetailModel >> tripId: anId [ 
tripId := anId
]

{ #category : 'accessing' }
TripDetailModel >> tripName [

	^ tripName
]
