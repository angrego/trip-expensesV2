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
		'participantListModel',
		'expenseListModel',
		'balanceModel',
		'errorMessage',
		'addParticipantModel',
		'expenseFormModel'
	],
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
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

{ #category : 'accessing' }
TripDetailModel >> addExpenseDescription: aDescription amount: anAmount payerId: aPayerId participantWeights: aPairCollection [

	expenseFormModel
		addExpense: aDescription
		amount: anAmount
		payerId: aPayerId
		weights: aPairCollection.
	errorMessage := expenseFormModel errorMessage.
	errorMessage ifNotNil: [
			self valueChanged.
			^ self ].
	self loadTrip
]

{ #category : 'accessing' }
TripDetailModel >> addGiftEntry [

	expenseFormModel addGiftEntry.
	self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> addParticipantModel [
	^ addParticipantModel
]

{ #category : 'accessing' }
TripDetailModel >> balances [

	^  balanceModel balances
]

{ #category : 'accessing' }
TripDetailModel >> currency [
	^ currency
]

{ #category : 'accessing' }
TripDetailModel >> currentParticipantWeights [
    ^ expenseFormModel currentParticipantWeights
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
TripDetailModel >> excludeParticipantId: aParticipantId [
    expenseFormModel participantEntries
        detect: [ :e | e participantId = aParticipantId ]
        ifFound: [ :e | e included: false ].
    self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> expenseFormModel [
    ^ expenseFormModel
]

{ #category : 'accessing' }
TripDetailModel >> expenses [

	^ expenseListModel expenses
]

{ #category : 'accessing' }
TripDetailModel >> giftEntries [

	expenseFormModel ifNil: [ ^ OrderedCollection new ].
	^ expenseFormModel giftEntries
]

{ #category : 'operations' }
TripDetailModel >> hideExpenseForm [

expenseFormModel hide.
    errorMessage := nil.
    self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> includeParticipantId: aParticipantId [
    expenseFormModel participantEntries
        detect: [ :e | e participantId = aParticipantId ]
        ifFound: [ :e | e included: true ].
    self valueChanged
]

{ #category : 'initialization' }
TripDetailModel >> initialize [

	super initialize.
	errorMessage := nil.
	addParticipantModel := nil.
	expenseFormModel := nil.
	balanceModel := nil.
	expenseListModel := nil.
	 participantListModel := nil
]

{ #category : 'operations' }
TripDetailModel >> loadTrip [

	| trip |
	trip := service findTrip: tripId.
	tripName := trip name.
	currency := trip currency.
	totalExpenses := trip totalExpenses amount printString.
	participantListModel load.
	expenseListModel load.
	balanceModel load.
	errorMessage := nil.
	self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> participantFormEntries [

	expenseFormModel ifNil: [ ^ OrderedCollection new ].
	^ expenseFormModel participantEntries
]

{ #category : 'accessing' }
TripDetailModel >> participants [

	^ participantListModel participants
]

{ #category : 'testing' }
TripDetailModel >> preferredPresenterClass [
	^ TripDetailPresenter
]

{ #category : 'accessing' }
TripDetailModel >> removeExpenseId: anExpenseId [
    [ expenseListModel removeExpenseId: anExpenseId ]
        on: Error
        do: [ :e |
            errorMessage := e messageText.
            self valueChanged.
            ^ self ].
    self loadTrip
]

{ #category : 'accessing' }
TripDetailModel >> removeGiftEntryId: anId [

	expenseFormModel removeGiftEntryId: anId.
	self valueChanged
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
TripDetailModel >> setGiftEntry: anEntry amount: aNumber [
    expenseFormModel setGiftEntry: anEntry amount: aNumber
]

{ #category : 'accessing' }
TripDetailModel >> setGiftEntry: anEntry fromId: aString [
    expenseFormModel setGiftEntry: anEntry fromId: aString
]

{ #category : 'accessing' }
TripDetailModel >> setGiftEntry: anEntry mode: aSymbol [
    anEntry mode: aSymbol.
    self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> setGiftEntry: anEntry toId: aString [
    expenseFormModel setGiftEntry: anEntry toId: aString
]

{ #category : 'accessing' }
TripDetailModel >> setGiftEntryId: anId mode: aSymbol [
    expenseFormModel setGiftEntry: 
        (expenseFormModel giftEntries detect: [ :e | e entryId = anId ])
        mode: aSymbol
]

{ #category : 'accessing' }
TripDetailModel >> setWeight: anInteger forParticipantId: aParticipantId [
    expenseFormModel participantEntries
        detect: [ :e | e participantId = aParticipantId ]
        ifFound: [ :e | e weight: anInteger ].
    self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> settlements [

	^ balanceModel settlements 
]

{ #category : 'accessing' }
TripDetailModel >> showExpenseForm [

expenseFormModel show.
    errorMessage := nil.
    self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> showingExpenseForm [

  expenseFormModel show.
    errorMessage := nil.
    self valueChanged
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

	tripId := anId.
	addParticipantModel := TripAddParticipantModel
		                       onService: service
		                       tripId: anId.
	expenseFormModel := TripExpenseFormModel
		                    onService: service
		                    tripId: anId.
	balanceModel := TripBalanceModel onService: service tripId: anId.
	expenseListModel := TripExpenseListModel
		                    onService: service
		                    tripId: anId.
		participantListModel := TripParticipantListModel
        onService: service
        tripId: anId
]

{ #category : 'accessing' }
TripDetailModel >> tripName [
	^ tripName
]
