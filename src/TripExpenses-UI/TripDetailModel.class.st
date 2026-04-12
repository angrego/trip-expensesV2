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
		'addParticipantModel',
		'expenseFormModel',
		'errorMessage'
	],
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'instance creation' }
TripDetailModel class >> onService: aTripApplicationService tripId: anId [
    ^ self new
        service: aTripApplicationService;
        tripId:  anId;
        loadTrip;
        yourself
]

{ #category : 'adding' }
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
TripDetailModel >> addParticipantModel [

	^ addParticipantModel
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
TripDetailModel >> errorMessage: aString [

	errorMessage := aString
]

{ #category : 'accessing' }
TripDetailModel >> expenseFormModel [

	^ expenseFormModel
]

{ #category : 'operations' }
TripDetailModel >> hideExpenseForm [
    expenseFormModel hide.
    errorMessage := nil.
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
    tripName      := trip name.
    currency      := trip currency.
    totalExpenses := trip totalExpenses amount printString.
    errorMessage  := nil.
    self valueChanged
]

{ #category : 'testing' }
TripDetailModel >> preferredPresenterClass [
	^ TripDetailPresenter
]

{ #category : 'removing' }
TripDetailModel >> removeExpenseId: anExpenseId [
    | expenseListModel |
    expenseListModel := TripExpenseListModel onService: service tripId: tripId.
    [ expenseListModel removeExpenseId: anExpenseId ]
        on: Error
        do: [ :e |
            errorMessage := e messageText.
            self valueChanged.
            ^ self ].
    self loadTrip
]

{ #category : 'accessing' }
TripDetailModel >> service [

	^ service
]

{ #category : 'private - setting' }
TripDetailModel >> service: aTripApplicationService [
    service := aTripApplicationService
]

{ #category : 'testing' }
TripDetailModel >> showExpenseForm [
    expenseFormModel show.
    errorMessage := nil.
    self valueChanged
]

{ #category : 'operations' }
TripDetailModel >> showExpenseFormForParticipant: aName [
    expenseFormModel showForParticipant: aName.
    errorMessage := nil.
    self valueChanged
]

{ #category : 'testing' }
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
        onService: service tripId: anId.
    expenseFormModel := TripExpenseFormModel
        onService: service tripId: anId
]

{ #category : 'accessing' }
TripDetailModel >> tripName [

	^ tripName
]
