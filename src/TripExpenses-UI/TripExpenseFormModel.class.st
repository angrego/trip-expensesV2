Class {
	#name : 'TripExpenseFormModel',
	#superclass : 'CpModel',
	#instVars : [
		'expenseId',
		'description',
		'amount',
		'currency',
		'date',
		'payerName',
		'beneficiaryNames',
		'service',
		'tripId',
		'participantEntries',
		'giftEntries',
		'errorMessage',
		'showing'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'instance creation' }
TripExpenseFormModel class >> onService: aTripApplicationService tripId: anId [
	^ self new
        service: aTripApplicationService;
        tripId: anId;
        yourself
]

{ #category : 'adding' }
TripExpenseFormModel >> addExpense: aDescription amount: anAmount payerId: aPayerId [

	| trip payer payments weightedParticipants splitRule gifts expense |
	(aDescription isNil or: [ aDescription trim isEmpty ]) ifTrue: [
			errorMessage := 'La description ne peut pas être vide'.
			self valueChanged.
			^ self ].
	(anAmount isNil or: [ anAmount <= 0 ]) ifTrue: [
			errorMessage := 'Le montant doit être positif'.
			self valueChanged.
			^ self ].
	trip := service findTrip: tripId.
	payer := trip participants
		         detect: [ :p | p id value = aPayerId ]
		         ifNone: [
				         errorMessage := 'Payeur introuvable'.
				         self valueChanged.
				         ^ self ].
	payments := { (Payment
		             participant: payer
		             amount: (Money amount: anAmount currency: currency)) }.
	weightedParticipants := self currentParticipantWeights select: [
		                        :pair | pair value > 0 ].
	weightedParticipants isEmpty ifTrue: [
			errorMessage := 'Il faut au moins un participant'.
			self valueChanged.
			^ self ].
	splitRule := EqualSplitRule among:
		             (weightedParticipants collect: [ :pair |
				              | p |
				              p := trip participants
					                   detect: [ :p2 | p2 id value = pair key ]
					                   ifNone: [
					                   Error signal:
						                   'Participant introuvable : ' , pair key ].
				              ParticipantWeight participant: p weight: pair value ]).	
[
		gifts := self
			         buildGiftsFromEntries: giftEntries
			         trip: trip
			         splitRule: splitRule
			         totalAmount: anAmount.
		expense := Expense
			           description: aDescription trim
			           totalAmount: (Money amount: anAmount currency: currency)
			           payments: payments
			           splitRule: splitRule
			           gifts: gifts
			           date: Date today.]
		on: Error
		do: [ :e |
				errorMessage := e messageText.
				self valueChanged.
				^ self ].
	service addExpense: expense toTrip: tripId.
	self hide
]

{ #category : 'adding' }
TripExpenseFormModel >> addExpense: aDescription amount: anAmount payerId: aPayerId weights: aPairCollection [
    aPairCollection isEmpty ifTrue: [
        errorMessage := 'Il faut au moins un participant'.
        self valueChanged.
        ^ self ].
    aPairCollection do: [ :pair |
        participantEntries
            detect: [ :e | e participantId = pair key ]
            ifFound: [ :e |
                pair value > 0
                    ifTrue: [
                        e included: true.
                        e weight: pair value ]
                    ifFalse: [
                        e included: false.
                        e weight: 1 ] ] ].
    self addExpense: aDescription amount: anAmount payerId: aPayerId
]

{ #category : 'adding' }
TripExpenseFormModel >> addGiftEntry [
Transcript showCr: 'addGiftEntry - giftEntries avant: ' , giftEntries printString.
	giftEntries add: TripExpenseGiftEntry new.
	
	    Transcript showCr: 'addGiftEntry - giftEntries après: ' , giftEntries printString.

	self valueChanged
]

{ #category : 'accessing' }
TripExpenseFormModel >> buildGiftsFromEntries: someEntries trip: aTrip splitRule: aSplitRule totalAmount: anAmount [
    | totalWeight completeEntries rawGifts |
    totalWeight := aSplitRule participantWeights
        inject: 0
        into: [ :sum :pw | sum + pw weight ].
    completeEntries := someEntries select: [ :e | e isComplete ].
    rawGifts := completeEntries flatCollect: [ :e |
        e mode = #globalShare
            ifTrue: [ self buildGlobalShareGiftsFromEntry: e
                          trip: aTrip
                          splitRule: aSplitRule
                          totalWeight: totalWeight ]
            ifFalse: [ { self buildSingleGiftFromEntry: e
                              trip: aTrip
                              splitRule: aSplitRule
                              totalWeight: totalWeight
                              totalAmount: anAmount } ] ].
    ^ rawGifts select: [ :g | g isNil not ]
]

{ #category : 'accessing' }
TripExpenseFormModel >> buildGlobalShareGiftsFromEntry: anEntry trip: aTrip splitRule: aSplitRule totalWeight: totalWeight [
    "Répartit le montant global entre tous les participants sauf le donateur."
    | from recipients totalRecipientWeight |
    from := aTrip participants
        detect: [ :p | p id value = anEntry fromId ]
        ifNone: [ ^ #() ].
    recipients := aSplitRule participantWeights
        reject: [ :pw | pw participant = from ].
    totalRecipientWeight := recipients
        inject: 0
        into: [ :sum :pw | sum + pw weight ].
    totalRecipientWeight = 0 ifTrue: [ ^ #() ].
    ^ recipients collect: [ :pw |
        | share |
        share := Money
            amount: anEntry amount * pw weight / totalRecipientWeight
            currency: currency.
        Gift from: from to: pw participant amount: share ]
]

{ #category : 'accessing' }
TripExpenseFormModel >> buildSingleGiftFromEntry: anEntry trip: aTrip splitRule: aSplitRule totalWeight: totalWeight totalAmount: anAmount [
    | from to giftAmount |
    from := aTrip participants
        detect: [ :p | p id value = anEntry fromId ]
        ifNone: [ ^ nil ].
    to := aTrip participants
        detect: [ :p | p id value = anEntry toId ]
        ifNone: [ ^ nil ].
    (from isNil or: [ to isNil ]) ifTrue: [ ^ nil ].
    giftAmount := anEntry mode = #share
        ifTrue: [
            | toPw |
            toPw := aSplitRule participantWeights
                detect: [ :pw | pw participant = to ]
                ifNone: [ nil ].
            toPw isNil
                ifTrue:  [ Money amount: 0 currency: currency ]
                ifFalse: [ Money amount: anAmount * toPw weight / totalWeight currency: currency ] ]
        ifFalse: [ Money amount: anEntry amount currency: currency ].
    ^ Gift from: from to: to amount: giftAmount
]

{ #category : 'accessing' }
TripExpenseFormModel >> currentParticipantWeights [
^ participantEntries collect: [ :e |
        e participantId -> (e included ifTrue: [ e weight ] ifFalse: [ 0 ]) ]
]

{ #category : 'accessing' }
TripExpenseFormModel >> errorMessage [
	^ errorMessage
]

{ #category : 'accessing' }
TripExpenseFormModel >> giftEntries [
^ giftEntries ifNil: [ OrderedCollection new ]
]

{ #category : 'actions' }
TripExpenseFormModel >> hide [
showing := false.
    errorMessage := nil.
    self valueChanged
]

{ #category : 'actions' }
TripExpenseFormModel >> initialize [
    super initialize.
    showing := false.
    participantEntries := OrderedCollection new.
    giftEntries := OrderedCollection new.
 
]

{ #category : 'testing' }
TripExpenseFormModel >> isShowing [
	^ showing ifNil: [ false ]
]

{ #category : 'accessing' }
TripExpenseFormModel >> participantEntries [
	^ participantEntries ifNil: [ #() ]
]

{ #category : 'removing' }
TripExpenseFormModel >> preferredPresenterClass [
    ^ TripExpenseFormPresenter
]

{ #category : 'removing' }
TripExpenseFormModel >> removeGiftEntryId: anId [
    giftEntries := giftEntries reject: [ :e | e entryId = anId ].
    self valueChanged
]

{ #category : 'private - setting' }
TripExpenseFormModel >> service: aTripApplicationService [ 
	service:=aTripApplicationService 
]

{ #category : 'accessing' }
TripExpenseFormModel >> setGiftEntry: anEntry amount: aNumber [
    anEntry amount: aNumber
]

{ #category : 'accessing' }
TripExpenseFormModel >> setGiftEntry: anEntry fromId: aString [
    anEntry fromId: aString
]

{ #category : 'accessing' }
TripExpenseFormModel >> setGiftEntry: anEntry mode: aSymbol [
    anEntry mode: aSymbol.
    self valueChanged
]

{ #category : 'initialization' }
TripExpenseFormModel >> setGiftEntry: anEntry toId: aString [
    anEntry toId: aString
]

{ #category : 'testing' }
TripExpenseFormModel >> setGiftEntryId: anId amount: anAmount [
    giftEntries
        detect: [ :e | e entryId = anId ]
        ifFound: [ :e | e amount: anAmount ]
]

{ #category : 'accessing' }
TripExpenseFormModel >> setGiftEntryId: anId mode: aSymbol [
    giftEntries
        detect: [ :e | e entryId = anId ]
        ifFound: [ :e | self setGiftEntry: e mode: aSymbol ]
]

{ #category : 'actions' }
TripExpenseFormModel >> show [
    | trip |
    trip := service findTrip: tripId.
    participantEntries := trip participants collect: [ :p |
        TripExpenseParticipantEntry forParticipant: p ].
    giftEntries := OrderedCollection new.
    errorMessage := nil.
    showing := true.
    self valueChanged
]

{ #category : 'private - setting' }
TripExpenseFormModel >> tripId: anId [

| trip |
    tripId := anId.
    trip := service findTrip: anId.
    currency := trip currency.
    participantEntries := trip participants collect: [ :p |
        TripExpenseParticipantEntry forParticipant: p ]
]
