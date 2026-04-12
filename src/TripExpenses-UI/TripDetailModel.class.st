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
		'expenseFormModel',
		'generosityModel',
		'currentExpenseGiftFormModel'
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
    aPairCollection isEmpty ifTrue: [
        errorMessage := 'Il faut au moins un participant'.
        self valueChanged.
        ^ self ].
    aPairCollection do: [ :pair |
        expenseFormModel participantEntries
            detect: [ :e | e participantId = pair key ]
            ifFound: [ :e |
                pair value > 0
                    ifTrue:  [ e included: true.  e weight: pair value ]
                    ifFalse: [ e included: false. e weight: 1 ] ] ].
    expenseFormModel
        addExpense: aDescription
        amount: anAmount
        payerId: aPayerId.
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
TripDetailModel >> currentExpenseGiftFormModel [
    ^ currentExpenseGiftFormModel
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
TripDetailModel >> generosityModel [
    ^ generosityModel
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
	generosityModel load.
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

{ #category : 'actions' }
TripDetailModel >> showExpenseFormForParticipant: aParticipantName [
    expenseFormModel showForParticipant: aParticipantName.
    errorMessage := nil.
    self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> showGiftFormForExpense: anExpenseId currentParticipantName: aName [
    currentExpenseGiftFormModel := TripExpenseGiftFormModel
        onService: service
        tripId: tripId
        expenseId: anExpenseId
        currentParticipantName: aName.
    currentExpenseGiftFormModel show.
    self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> showingExpenseForm [

 ^ expenseFormModel isShowing
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
		                        tripId: anId.
		generosityModel := TripGenerosityModel onService: service tripId: anId.
]

{ #category : 'accessing' }
TripDetailModel >> tripName [
	^ tripName
]
