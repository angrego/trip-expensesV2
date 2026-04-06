"
Je rends le detail d un seul voyage.
J utilise des child presenters pour participants, depenses, balances et reglements.
Le bouton Retour delegue via self application navigateToList
qui delegue a TripAppModel navigateToList qui annonce valueChanged.
"
Class {
	#name : 'TripDetailPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'rendering' }
TripDetailPresenter >> buildGiftEntries [
    self model giftEntries isNil ifTrue: [ ^ #() ].
    ^ (self model giftEntries collect: [ :e |
        Dictionary new
            at: 'entryId'  put: e entryId;
            at: 'fromId'   put: (e fromId  ifNil: [ '' ]);
            at: 'toId'     put: (e toId    ifNil: [ '' ]);
            at: 'mode'     put: e mode asString;
            at: 'amount'   put: (e amount  ifNil: [ 0 ]);
            yourself ]) asArray
]

{ #category : 'event handling' }
TripDetailPresenter >> buildPayerOptions [
	"Retourne un Array de Dictionary { 'id' -> String. 'name' -> String }.
	 CP peut serialiser des Dictionary contenant uniquement des String.
	 Plus de String encodee — plus de substrings: fragile."

	^ (self model participants collect: [ :p |
			  Dictionary new
				  at: 'id' put: p participantId;
				  at: 'name' put: p name;
				  yourself ]) asArray 
]

{ #category : 'event handling' }
TripDetailPresenter >> buildWeightEntries [
	"Retourne Array de Dictionary sérialisable par CP."

	self model participantFormEntries ifNil: [ ^ #(  ) ].
	^ (self model participantFormEntries collect: [ :e |
			   Dictionary new
				   at: 'id' put: e participantId;
				   at: 'name' put: e name;
				   at: 'included' put: e included;
				   at: 'weight' put: e weight;
				   yourself ]) asArray
]

{ #category : 'event handling' }
TripDetailPresenter >> onAddExpense: anAnnouncement [

    | amount weights |
    amount := anAnnouncement amountString asNumber.

    weights := anAnnouncement weightsString collect: [ :entry |
        | colonIndex pid w |
        colonIndex := entry indexOf: $:.
        pid := entry copyFrom: 1 to: colonIndex - 1.
        w   := (entry copyFrom: colonIndex + 1 to: entry size) asInteger.
        pid -> w ].

    self model
        addExpenseDescription: anAnnouncement description
        amount: amount
        payerId: anAnnouncement payerId
        participantWeights: weights
]

{ #category : 'event handling' }
TripDetailPresenter >> onBackRequested [
	self application navigateToList
]

{ #category : 'event handling' }
TripDetailPresenter >> onDeleteExpenseId: anAnouncement [
	"Appele par TripExpenseItemPresenter quand l utilisateur supprime une depense."

	self model removeExpenseId: anAnouncement 
]

{ #category : 'rendering' }
TripDetailPresenter >> onGiftAdd [
    self model addGiftEntry
]

{ #category : 'rendering' }
TripDetailPresenter >> onGiftModeChanged: anAnnouncement [
    self model setGiftEntryId: anAnnouncement entryId mode: anAnnouncement mode
]

{ #category : 'rendering' }
TripDetailPresenter >> onGiftRemove: anAnnouncement [
    self model removeGiftEntryId: anAnnouncement entryId
]

{ #category : 'event handling' }
TripDetailPresenter >> onHideExpenseForm [
	self model hideExpenseForm
]

{ #category : 'event handling' }
TripDetailPresenter >> onInclusionChanged: anAnnouncement [
    anAnnouncement included
        ifTrue:  [ self model includeParticipantId: anAnnouncement participantId ]
        ifFalse: [ self model excludeParticipantId: anAnnouncement participantId ]
]

{ #category : 'event handling' }
TripDetailPresenter >> onParticipantAdded [
	"Le composant addParticipant a reussi — on recharge le voyage pour rafraichir la liste des participants et les balances."

	self model loadTrip
]

{ #category : 'event handling' }
TripDetailPresenter >> onShowExpenseForm [
	self model showExpenseForm
]

{ #category : 'event handling' }
TripDetailPresenter >> onWeightChanged: anAnnouncement [
    self model
        setWeight: anAnnouncement weight
        forParticipantId: anAnnouncement participantId
]

{ #category : 'rendering' }
TripDetailPresenter >> renderView [

	self view
		renderTripName: self model tripName;
		renderCurrency: self model currency;
		renderTotalExpenses: self model totalExpenses;
		renderErrorMessage: (self model errorMessage ifNil: [ '' ]);
		renderShowExpenseForm: self model showingExpenseForm;
		renderEmptySettlements: self model settlements isEmpty;
		renderPayerOptions: self buildPayerOptions;
		renderParticipantWeightEntries: self buildWeightEntries.
	self
		renderAllChildViewsForModels: self model participants
		atSlotNamed: #participants.
	self
		renderChildViewForModel: self model addParticipantModel
		atSlotNamed: #addParticipant.
	self
		renderAllChildViewsForModels: self model expenses
		atSlotNamed: #expenses.
	self
		renderAllChildViewsForModels: self model balances
		atSlotNamed: #balances.
	self
		renderAllChildViewsForModels: self model settlements
		atSlotNamed: #settlements
]

{ #category : 'rendering' }
TripDetailPresenter >> viewCreated [
    super viewCreated.
    self model addParticipantModel
        when: ValueChanged
        send: #onParticipantAdded
        to: self.
    self view
        when: TripDetailBackRequested                send: #onBackRequested        to: self;
        when: TripDetailShowExpenseFormRequested     send: #onShowExpenseForm      to: self;
        when: TripDetailHideExpenseFormRequested     send: #onHideExpenseForm      to: self;
        when: TripDetailAddExpenseRequested          send: #onAddExpense:          to: self;
        when: TripDetailGiftAddRequested             send: #onGiftAdd              to: self;
        when: TripDetailGiftRemoveRequested          send: #onGiftRemove:          to: self;
        when: TripDetailGiftModeChanged              send: #onGiftModeChanged:     to: self
]
