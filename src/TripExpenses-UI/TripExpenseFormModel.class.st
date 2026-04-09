Class {
	#name : 'TripExpenseFormModel',
	#superclass : 'CpModel',
	#instVars : [
		'justOpened',
		'currency',
		'service',
		'tripId',
		'participantEntries',
		'giftEntries',
		'errorMessage',
		'showing',
		'currentPayerId',
		'currentAmount',
		'participantWeightModels'
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
    | trip payer splitRule gifts expense |
    (self validateDescription: aDescription) ifFalse: [ ^ self ].
    (self validateAmount: anAmount) ifFalse: [ ^ self ].
    trip  := service findTrip: tripId.
    payer := self findPayer: aPayerId inTrip: trip.
    payer ifNil: [ ^ self ].
    splitRule := self buildSplitRuleFor: trip.
    splitRule ifNil: [ ^ self ].
    [ 
        gifts   := self buildGiftsFromEntries: giftEntries splitRule: splitRule totalAmount: anAmount.
        expense := self buildExpense: aDescription amount: anAmount payer: payer splitRule: splitRule gifts: gifts.
        service addExpense: expense toTrip: tripId.
        self hide ]
    on: Error
    do: [ :e | errorMessage := e messageText. self valueChanged ]
]

{ #category : 'adding' }
TripExpenseFormModel >> addGiftEntry [

	| payer entry |
	(currentPayerId isNil or: [ currentPayerId isEmpty ]) ifTrue: [
		^ self ].
	(currentAmount isNil or: [ currentAmount <= 0 ]) ifTrue: [ ^ self ].
	payer := participantEntries
		         detect: [ :e | e participantId = currentPayerId ]
		         ifNone: [ ^ self ].
	entry := TripGiftEntryModel
		         fromParticipant: payer participant
		         maxAmount: currentAmount
		         beneficiaries: participantEntries.
	giftEntries add: entry.
]

{ #category : 'accessing' }
TripExpenseFormModel >> buildExpense: aDescription amount: anAmount payer: aPayer splitRule: aSplitRule gifts: someGifts [
    ^ Expense
        description: aDescription trim
        totalAmount: (Money amount: anAmount currency: currency)
        payments: { Payment participant: aPayer amount: (Money amount: anAmount currency: currency) }
        splitRule: aSplitRule
        gifts: someGifts
        date: Date today
]

{ #category : 'accessing' }
TripExpenseFormModel >> buildGiftsFromEntries: someEntries splitRule: aSplitRule totalAmount: anAmount [

	^ someEntries flatCollect: [ :e |
			  | payerShare gifts |
			  e fromParticipant ifNil: [ ^ #(  ) ].
			  payerShare := (aSplitRule computeShares:
				                 (Money amount: anAmount currency: currency))
				                at: e fromParticipant
				                ifAbsent: [ Money amount: 0 currency: currency ].
			  gifts := e toGift: currency payerShare: payerShare amount.
			  gifts ifNil: [ #(  ) ] ifNotNil: [ gifts ] ]
]

{ #category : 'accessing' }
TripExpenseFormModel >> buildSplitRuleFor: aTrip [
    | weighted |
    weighted := self currentParticipantWeights select: [ :pair | pair value > 0 ].
    weighted isEmpty ifTrue: [
        errorMessage := 'Il faut au moins un participant'.
        self valueChanged.
        ^ nil ].
    ^ EqualSplitRule among: (weighted collect: [ :pair |
        | p |
        p := aTrip participants
            detect: [ :p2 | p2 id value = pair key ]
            ifNone: [
                Error signal: (String streamContents: [ :s |
                    s
                        nextPutAll: 'Participant introuvable : ';
                        nextPutAll: pair key ]) ].
        ParticipantWeight participant: p weight: pair value ])
]

{ #category : 'actions' }
TripExpenseFormModel >> clearJustOpened [
    justOpened := false
]

{ #category : 'accessing' }
TripExpenseFormModel >> currency [
    ^ currency
]

{ #category : 'accessing' }
TripExpenseFormModel >> currentAmount [
    ^ currentAmount
]

{ #category : 'accessing' }
TripExpenseFormModel >> currentParticipantWeights [
^ participantEntries collect: [ :e |
        e participantId -> (e included ifTrue: [ e weight ] ifFalse: [ 0 ]) ]
]

{ #category : 'accessing' }
TripExpenseFormModel >> currentPayerId [
    ^ currentPayerId
]

{ #category : 'accessing' }
TripExpenseFormModel >> errorMessage [
	^ errorMessage
]

{ #category : 'accessing' }
TripExpenseFormModel >> findPayer: aPayerId inTrip: aTrip [
    ^ aTrip participants
        detect: [ :p | p id value = aPayerId ]
        ifNone: [
            errorMessage := 'Payeur introuvable'.
            self valueChanged.
            nil ]
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

{ #category : 'initialization' }
TripExpenseFormModel >> initialize [

	super initialize.
	showing := false.
	justOpened := false.
	participantEntries := OrderedCollection new.
	giftEntries := OrderedCollection new
]

{ #category : 'testing' }
TripExpenseFormModel >> isShowing [
	^ showing ifNil: [ false ]
]

{ #category : 'actions' }
TripExpenseFormModel >> justOpened [

	^ justOpened 
]

{ #category : 'accessing' }
TripExpenseFormModel >> participantEntries [
	^ participantEntries ifNil: [ #() ]
]

{ #category : 'testing' }
TripExpenseFormModel >> participantWeightModels [
participantWeightModels ifNil: [
        participantWeightModels := participantEntries collect: [ :e |
            TripParticipantWeightModel fromEntry: e ] ].
    ^ participantWeightModels
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
TripExpenseFormModel >> setCurrentAmount: aNumber [

	currentAmount := aNumber.
	giftEntries do: [ :g | g setMaxAmount: aNumber ].
	self updateShareLabels.
	self valueChanged
]

{ #category : 'accessing' }
TripExpenseFormModel >> setCurrentPayerId: aPayerId [

	currentPayerId := aPayerId.
	giftEntries do: [ :g |
			| payer |
			payer := participantEntries
				         detect: [ :e | e participantId = aPayerId ]
				         ifNone: [ nil ].
			payer ifNotNil: [ g setFromParticipant: payer participant ] ].
		self valueChanged
]

{ #category : 'actions' }
TripExpenseFormModel >> show [

	| trip |
	trip := service findTrip: tripId.
	participantWeightModels := nil.
	participantEntries := trip participants collect: [ :p |
		                      TripExpenseParticipantEntry forParticipant: p ].
	giftEntries := OrderedCollection new.
	errorMessage := nil.
	currentAmount := nil.
	currentPayerId := participantEntries isEmpty
		                  ifTrue: [ nil ]
		                  ifFalse: [ participantEntries first participantId ].
	showing := true.
	self valueChanged
]

{ #category : 'accessing' }
TripExpenseFormModel >> totalWeight [
    ^ participantEntries
        inject: 0
        into: [ :sum :e | e included ifTrue: [ sum + e weight ] ifFalse: [ sum ] ]
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

{ #category : 'rendering' }
TripExpenseFormModel >> updateShareLabels [

	| amount |
	amount := currentAmount ifNil: [ 0 ].
	self participantWeightModels do: [ :m |
			m
				updateShareForAmount: amount
				totalWeight: self totalWeight
				currency: currency ]
]

{ #category : 'accessing' }
TripExpenseFormModel >> updateWeightsFrom: aCollectionOfArrays [

	aCollectionOfArrays do: [ :arr |
			| pid w |
			pid := arr first.
			w := arr at: 2.
			participantEntries
				detect: [ :e | e participantId = pid ]
				ifFound: [ :e |
						w > 0
							ifTrue: [
									e included: true.
									e weight: w ]
							ifFalse: [
									e included: false.
									e weight: 1 ] ] ]
]

{ #category : 'accessing' }
TripExpenseFormModel >> validateAmount: anAmount [
    (anAmount isNil or: [ anAmount <= 0 ]) ifTrue: [
        errorMessage := 'Le montant doit être positif'.
        self valueChanged.
        ^ false ].
    ^ true
]

{ #category : 'accessing' }
TripExpenseFormModel >> validateDescription: aDescription [
    (aDescription isNil or: [ aDescription trim isEmpty ]) ifTrue: [
        errorMessage := 'La description ne peut pas être vide'.
        self valueChanged.
        ^ false ].
    ^ true
]
