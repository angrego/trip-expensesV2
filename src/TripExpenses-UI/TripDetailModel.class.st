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
		'errorMessage',
		'addParticipantModel',
		'participantFormEntries',
		'giftEntries'
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

{ #category : 'operations' }
TripDetailModel >> addExpenseDescription: aDescription amount: anAmount payerId: aPayerId participantIds: aCollectionOfIds [
	"Valide, construit l'Expense directement depuis les objets domaine l'enregistre via le service, puis recharge le voyage. Aucun Dictionary JSON — on parle directement au domaine."
	| trip payer payments splitRule expense |
	(aDescription isNil or: [ aDescription trim isEmpty ]) ifTrue: [
			errorMessage := 'La description ne peut pas être vide'.
			self valueChanged.
			^ self ].
	(anAmount isNil or: [ anAmount <= 0 ]) ifTrue: [
			errorMessage := 'Le montant doit être positif'.
			self valueChanged.
			^ self ].
	(aCollectionOfIds isNil or: [ aCollectionOfIds isEmpty ]) ifTrue: [
			errorMessage := 'Il faut au moins un participant'.
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

	splitRule := EqualSplitRule among:
		             (aCollectionOfIds collect: [ :id |
				              | p |
				              p := trip participants
					                   detect: [ :p2 | p2 id value = id ]
					                   ifNone: [
					                   Error signal:
						                   'Participant introuvable : ' , id ].
				              ParticipantWeight participant: p ]).

	expense := Expense
		           description: aDescription trim
		           totalAmount: (Money amount: anAmount currency: currency)
		           payments: payments
		           splitRule: splitRule
		           gifts: #(  )
		           date: Date today.

	service addExpense: expense toTrip: tripId.
	showingExpenseForm := false.
	self loadTrip
]

{ #category : 'testing' }
TripDetailModel >> addExpenseDescription: aDescription amount: anAmount payerId: aPayerId participantWeights: aPairCollection [
    | trip payer payments weightedParticipants splitRule gifts expense |

    (aDescription isNil or: [ aDescription trim isEmpty ]) ifTrue: [
        errorMessage := 'La description ne peut pas être vide'.
        self valueChanged. ^ self ].

    (anAmount isNil or: [ anAmount <= 0 ]) ifTrue: [
        errorMessage := 'Le montant doit être positif'.
        self valueChanged. ^ self ].

    (aPairCollection isNil or: [ aPairCollection isEmpty ]) ifTrue: [
        errorMessage := 'Il faut au moins un participant'.
        self valueChanged. ^ self ].

    trip := service findTrip: tripId.

    payer := trip participants
        detect: [ :p | p id value = aPayerId ]
        ifNone: [
            errorMessage := 'Payeur introuvable'.
            self valueChanged. ^ self ].

    payments := { Payment
        participant: payer
        amount: (Money amount: anAmount currency: currency) }.

    weightedParticipants := aPairCollection select: [ :pair | pair value > 0 ].

    weightedParticipants isEmpty ifTrue: [
        errorMessage := 'Tous les poids sont à zéro'.
        self valueChanged. ^ self ].

    splitRule := EqualSplitRule among:
        (weightedParticipants collect: [ :pair |
            | p |
            p := trip participants
                detect: [ :p2 | p2 id value = pair key ]
                ifNone: [ Error signal: 'Participant introuvable : ' , pair key ].
            ParticipantWeight participant: p weight: pair value ]).

    gifts := self buildGiftsFromEntries: (giftEntries ifNil: [ #() ])
        trip: trip
        splitRule: splitRule
        totalAmount: anAmount.

    [ expense := Expense
        description: aDescription trim
        totalAmount: (Money amount: anAmount currency: currency)
        payments: payments
        splitRule: splitRule
        gifts: gifts
        date: Date today ]
    on: Error
    do: [ :e |
        errorMessage := e messageText.
        self valueChanged.
        ^ self ].

    service addExpense: expense toTrip: tripId.
    showingExpenseForm := false.
    giftEntries := OrderedCollection new.
    self loadTrip
]

{ #category : 'accessing' }
TripDetailModel >> addGiftEntry [
    giftEntries add: TripExpenseGiftEntry new.
    self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> addParticipantModel [
	^ addParticipantModel
]

{ #category : 'accessing' }
TripDetailModel >> balances [
	^ balances
]

{ #category : 'testing' }
TripDetailModel >> buildGiftsFromEntries: someEntries trip: aTrip splitRule: aSplitRule totalAmount: anAmount [
    | totalWeight completeEntries rawGifts |
    totalWeight := aSplitRule participantWeights
        inject: 0
        into: [ :sum :pw | sum + pw weight ].

    completeEntries := someEntries select: [ :e | e isComplete ].

    rawGifts := completeEntries collect: [ :e |
        | from to giftAmount |
        from := aTrip participants
            detect: [ :p | p id value = e fromId ]
            ifNone: [ nil ].
        to := aTrip participants
            detect: [ :p | p id value = e toId ]
            ifNone: [ nil ].
        (from isNil or: [ to isNil ])
            ifTrue: [ nil ]
            ifFalse: [
                giftAmount := e mode = #share
                    ifTrue: [
                        | toPw |
                        toPw := aSplitRule participantWeights
                            detect: [ :pw | pw participant = to ]
                            ifNone: [ nil ].
                        toPw isNil
                            ifTrue:  [ Money amount: 0 currency: currency ]
                            ifFalse: [ Money amount: anAmount * toPw weight / totalWeight currency: currency ] ]
                    ifFalse: [
                        Money amount: e amount currency: currency ].
                Gift from: from to: to amount: giftAmount ] ].

    ^ rawGifts select: [ :g | g isNil not ]
]

{ #category : 'accessing' }
TripDetailModel >> currency [
	^ currency
]

{ #category : 'accessing' }
TripDetailModel >> currentParticipantWeights [
    "Retourne une collection de paires participantId -> weight,
     avec 0 pour les participants exclus."
    ^ participantFormEntries collect: [ :e |
        e participantId -> (e included ifTrue: [ e weight ] ifFalse: [ 0 ]) ]
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
    participantFormEntries
        detect: [ :e | e participantId = aParticipantId ]
        ifFound: [ :e | e included: false ].
    self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> expenses [
	^ expenses
]

{ #category : 'accessing' }
TripDetailModel >> giftEntries [
    ^ giftEntries
]

{ #category : 'operations' }
TripDetailModel >> hideExpenseForm [
	showingExpenseForm := false.
	errorMessage := nil.
	self valueChanged
]

{ #category : 'as yet unclassified' }
TripDetailModel >> includeParticipantId: aParticipantId [
    participantFormEntries
        detect: [ :e | e participantId = aParticipantId ]
        ifFound: [ :e | e included: true ].
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
	errorMessage := nil.
	addParticipantModel := nil
]

{ #category : 'operations' }
TripDetailModel >> loadTrip [
	"Charge le voyage depuis le service domaine. Chaque objet domaine est converti en sous-CpModel via les factories fromXxx:."

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
settlements := (service settlementsForTrip: tripId) collect: [ :s |
    TripSettlementItemModel fromSettlement: s ].
	errorMessage := nil.
	self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> participantFormEntries [
	^ participantFormEntries
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
TripDetailModel >> removeExpenseId: anExpenseId [
	"Supprime la depense par son id via le service, puis recharge le voyage."
	[ service removeExpense: anExpenseId fromTrip: tripId ]
		on: Error
		do: [ :e |
				errorMessage := e messageText.
				self valueChanged.
				^ self ].
	self loadTrip
]

{ #category : 'accessing' }
TripDetailModel >> removeGiftEntryId: anEntryId [
    giftEntries := giftEntries reject: [ :e | e entryId = anEntryId ].
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
    anEntry amount: aNumber
]

{ #category : 'accessing' }
TripDetailModel >> setGiftEntry: anEntry fromId: aString [
    anEntry fromId: aString
]

{ #category : 'accessing' }
TripDetailModel >> setGiftEntry: anEntry mode: aSymbol [
    anEntry mode: aSymbol.
    self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> setGiftEntry: anEntry toId: aString [
    anEntry toId: aString
]

{ #category : 'accessing' }
TripDetailModel >> setGiftEntryId: anEntryId mode: aSymbol [
    giftEntries
        detect: [ :e | e entryId = anEntryId ]
        ifFound: [ :e | e mode: aSymbol ].
    self valueChanged
]

{ #category : 'initialization' }
TripDetailModel >> setWeight: anInteger forParticipantId: aParticipantId [
    participantFormEntries
        detect: [ :e | e participantId = aParticipantId ]
        ifFound: [ :e | e weight: anInteger ].
    self valueChanged
]

{ #category : 'accessing' }
TripDetailModel >> settlements [
	^ settlements
]

{ #category : 'accessing' }
TripDetailModel >> showExpenseForm [
    | trip |
    trip := service findTrip: tripId.
    participantFormEntries := trip participants collect: [ :p |
        TripExpenseParticipantEntry forParticipant: p ].
    giftEntries := OrderedCollection new.
    showingExpenseForm := true.
    errorMessage := nil.
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
	tripId := anId.
	addParticipantModel := TripAddParticipantModel
		                       onService: service
		                       tripId: anId
]

{ #category : 'accessing' }
TripDetailModel >> tripName [
	^ tripName
]
