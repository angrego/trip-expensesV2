"
Je tiens toutes les données pour la vue détail d'un seul voyage.
Mon service est un TripApplicationService — je ne connais pas TripExpensesServerApp.
Je ne passe jamais par handleMessage: ni par des Dictionary JSON.
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

{ #category : 'instance creation' }
TripDetailModel class >> onService: aTripApplicationService tripId: anId [
	"aTripApplicationService est un TripApplicationService, jamais un TripExpensesServerApp."
	^ self new
		service: aTripApplicationService;
		tripId:  anId;
		loadTrip;
		yourself
]

{ #category : 'operations' }
TripDetailModel >> addExpenseDescription: aDescription amount: anAmount payerId: aPayerId participantIds: aCollectionOfIds [
	"Valide, construit l'Expense directement depuis les objets domaine,
	 l'enregistre via le service, puis recharge le voyage.
	 Aucun Dictionary JSON — on parle directement au domaine."
	| trip payer payments splitRule expense |

	(aDescription isNil or: [ aDescription trim isEmpty ]) ifTrue: [
		errorMessage := 'La description ne peut pas être vide'.
		self valueChanged. ^ self ].
	(anAmount isNil or: [ anAmount <= 0 ]) ifTrue: [
		errorMessage := 'Le montant doit être positif'.
		self valueChanged. ^ self ].
	(aCollectionOfIds isNil or: [ aCollectionOfIds isEmpty ]) ifTrue: [
		errorMessage := 'Il faut au moins un participant'.
		self valueChanged. ^ self ].

	trip   := service findTrip: tripId.
	payer  := trip participants
		detect: [ :p | p id value = aPayerId ]
		ifNone: [ errorMessage := 'Payeur introuvable'. self valueChanged. ^ self ].

	payments  := { Payment
		participant: payer
		amount:      (Money amount: anAmount currency: currency) }.

	splitRule := EqualSplitRule among:
		(aCollectionOfIds collect: [ :id |
			| p |
			p := trip participants
				detect: [ :p2 | p2 id value = id ]
				ifNone: [ Error signal: 'Participant introuvable : ' , id ].
			ParticipantWeight participant: p ]).

	expense := Expense
		description: aDescription trim
		totalAmount:  (Money amount: anAmount currency: currency)
		payments:     payments
		splitRule:    splitRule
		gifts:        #()
		date:         Date today.

	service addExpense: expense toTrip: tripId.
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

{ #category : 'operations' }
TripDetailModel >> hideExpenseForm [
	showingExpenseForm := false.
	errorMessage := nil.
	self valueChanged
]

{ #category : 'initialization' }
TripDetailModel >> initialize [
	super initialize.
	participants := OrderedCollection new.
	expenses := OrderedCollection new.
	balances := OrderedCollection new.
	settlements := OrderedCollection new.
	showingExpenseForm := false.
	errorMessage := nil
]

{ #category : 'operations' }
TripDetailModel >> loadTrip [
	"Charge le voyage depuis le service domaine	 Chaque objet domaine est converti en sous-CpModel via les factories fromXxx:."
	| trip |
	trip := service findTrip: tripId.
	tripName := trip name.
	currency := trip currency.
	totalExpenses := trip totalExpenses amount printString.
	participants := trip participants collect: [ :p |
		                TripParticipantModel fromParticipant: p ].
	expenses := trip expenses collect: [ :e |
		            TripExpenseExpenseItemModel
			            fromExpense: e
			            currency: currency ].
	balances := trip balances associations collect: [ :assoc |
		            TripBalanceItemModel
			            fromParticipant: assoc key
			            money: assoc value ].
	settlements := trip settlements collect: [ :s |
		               TripSettlementItemModel fromSettlement: s ].
	errorMessage := nil.
	self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> participants [
	^ participants
]

{ #category : 'testing' }
TripDetailModel >> preferredPresenterClass [
	^ TripDetailPresenter
]

{ #category : 'accessing' }
TripDetailModel >> service [

	^ service
]

{ #category : 'private - setting' }
TripDetailModel >> service: aTripApplicationService [
	service := aTripApplicationService
]

{ #category : 'accessing' }
TripDetailModel >> settlements [
	^ settlements
]

{ #category : 'operations' }
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

{ #category : 'accessing' }
TripDetailModel >> tripId [
	^ tripId
]

{ #category : 'private - setting' }
TripDetailModel >> tripId: anId [
	tripId := anId
]

{ #category : 'accessing' }
TripDetailModel >> tripName [
	^ tripName
]
