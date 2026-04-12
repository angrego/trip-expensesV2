Class {
	#name : 'TripExpenseGiftFormModel',
	#superclass : 'CpModel',
	#instVars : [
		'service',
		'tripId',
		'expenseId',
		'giftEntryModel',
		'showing',
		'errorMessage',
		'currentParticipantName'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'as yet unclassified' }
TripExpenseGiftFormModel class >> onService: aService tripId: aTripId expenseId: anExpenseId currentParticipantName: aName [
    ^ self new
        service:                aService;
        tripId:                 aTripId;
        expenseId:              anExpenseId;
        currentParticipantName: aName;
        yourself
]

{ #category : 'accessing' }
TripExpenseGiftFormModel >> addGift [
    | gifts |
    gifts := giftEntryModel toGift: (service findTrip: tripId) currency
        payerShare: giftEntryModel payerTheoreticalShare amount.
    (gifts isNil or: [ gifts isEmpty ]) ifTrue: [ ^ self ].
    [
        gifts do: [ :g |
            service addGift: g toExpense: expenseId inTrip: tripId ].
        showing := false ]
    on: Error
    do: [ :e |
        errorMessage := e messageText ].
    self valueChanged
]

{ #category : 'as yet unclassified' }
TripExpenseGiftFormModel >> currentParticipantName [

^	currentParticipantName
]

{ #category : 'as yet unclassified' }
TripExpenseGiftFormModel >> currentParticipantName: aName [

	currentParticipantName:=aName 
]

{ #category : 'private - setting' }
TripExpenseGiftFormModel >> errorMessage [
    ^ errorMessage
]

{ #category : 'accessing' }
TripExpenseGiftFormModel >> expenseId: anId [

	expenseId :=anId 
]

{ #category : 'accessing' }
TripExpenseGiftFormModel >> giftEntryModel [
	^ giftEntryModel
]

{ #category : 'testing' }
TripExpenseGiftFormModel >> hide [
    showing := false.
    self valueChanged
]

{ #category : 'initialization' }
TripExpenseGiftFormModel >> initialize [
    super initialize.
    showing := false
]

{ #category : 'testing' }
TripExpenseGiftFormModel >> isShowing [
	^showing 
]

{ #category : 'private - setting' }
TripExpenseGiftFormModel >> preferredPresenterClass [
    ^ TripExpenseGiftFormPresenter
]

{ #category : 'accessing' }
TripExpenseGiftFormModel >> service: aService [
    service := aService
]

{ #category : 'actions' }
TripExpenseGiftFormModel >> show [

	| trip expense entries shares payer |
	trip := service findTrip: tripId.
	expense := trip expenses detect: [ :e | e id = expenseId ].
	payer := trip participants
		         detect: [ :p | p name = currentParticipantName ]
		         ifNone: [ expense payments first participant ].
	entries := expense splitRule participantWeights collect:[ :p |
		           TripExpenseParticipantEntry forParticipant: p participant ].
	shares := expense splitRule computeShares: expense totalAmount.
	giftEntryModel := TripGiftEntryModel
		                  fromParticipant: payer
		                  maxAmount: expense totalAmount amount
		                  beneficiaries: entries
		                  theoreticalShares: shares.
	showing := true.
	errorMessage := nil.
	self valueChanged
]

{ #category : 'private - setting' }
TripExpenseGiftFormModel >> tripId: anId [

	tripId:=anId
]
