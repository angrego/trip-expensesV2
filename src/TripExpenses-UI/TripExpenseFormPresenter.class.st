Class {
	#name : 'TripExpenseFormPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'view' }
TripExpenseFormPresenter >> onAddExpense: anAnnouncement [

 | amount weights |
    amount := anAnnouncement amountString asNumber.
    weights := anAnnouncement weightsString collect: [ :entry |
        | colonIndex pid w |
        colonIndex := entry indexOf: $:.
        pid := entry copyFrom: 1 to: colonIndex - 1.
        w   := (entry copyFrom: colonIndex + 1 to: entry size) asInteger.
        pid -> w ].
    self model
        addExpense: anAnnouncement description
        amount: amount
        payerId: anAnnouncement payerId
        weights: weights.
    self model isShowing ifFalse: [
        self parent onExpenseAdded ]
]

{ #category : 'view' }
TripExpenseFormPresenter >> onAmountChanged: anAnnouncement [
    self model setCurrentAmount: anAnnouncement amount
]

{ #category : 'view' }
TripExpenseFormPresenter >> onGiftAdd [

	self model addGiftEntry
]

{ #category : 'view' }
TripExpenseFormPresenter >> onGiftAmountChanged: anAnnouncement [
    self model setGiftEntryId: anAnnouncement entryId amount: anAnnouncement amount
]

{ #category : 'view' }
TripExpenseFormPresenter >> onGiftModeChanged: anAnnouncement [
    self model setGiftEntryId: anAnnouncement entryId mode: anAnnouncement mode
]

{ #category : 'view' }
TripExpenseFormPresenter >> onInclusionChanged: anAnnouncement [
    | entry |
    entry := self model participantEntries
        detect: [ :e | e participantId = anAnnouncement participantId ]
        ifNone: [ ^ self ].
    entry included: anAnnouncement included
]

{ #category : 'view' }
TripExpenseFormPresenter >> onPayerChanged: anAnnouncement [
    self model setCurrentPayerId: anAnnouncement payerId
]

{ #category : 'view' }
TripExpenseFormPresenter >> onWeightChanged: anAnnouncement [
    | entry |
    entry := self model participantEntries
        detect: [ :e | e participantId = anAnnouncement participantId ]
        ifNone: [ ^ self ].
    entry weight: anAnnouncement weight
]

{ #category : 'rendering' }
TripExpenseFormPresenter >> renderView [

    self view
        renderPayerOptions: (self model participantEntries collect: [ :e |
            Array with: e participantId with: e name ]) asArray;
        renderErrorMessage: (self model errorMessage ifNil: [ '' ]);
        renderAddGiftButtonEnabled: (
            self model currentPayerId isNotNil and: [
                self model currentAmount isNotNil and: [
                    self model currentAmount > 0 ] ]).
    self
        renderAllChildViewsForModels: self model giftEntries
        atSlotNamed: #gifts
]

{ #category : 'rendering' }
TripExpenseFormPresenter >> renderWeights [

	self view renderParticipantWeightEntries:
		(self model participantEntries collect: [ :e |
				 Array
					 with: e participantId
					 with: e name
					 with: e weight
					 with: e included ]) asArray
				currency: self model currency.
]

{ #category : 'view' }
TripExpenseFormPresenter >> viewCreated [

	super viewCreated.
	self renderWeights.
	self view
		when: TripDetailAddExpenseRequested send: #onAddExpense: to: self;
		when: TripDetailHideExpenseFormRequested
		send: #onHideExpenseForm
		to: self;
		when: TripDetailGiftAddRequested send: #onGiftAdd to: self;
		when: TripDetailGiftRemoveRequested send: #onGiftRemove: to: self;
		when: TripDetailGiftModeChanged send: #onGiftModeChanged: to: self;
		when: TripDetailGiftFromChanged send: #onGiftFromChanged: to: self;
		when: TripDetailGiftToChanged send: #onGiftToChanged: to: self;
		when: TripDetailParticipantInclusionChanged
		send: #onInclusionChanged:
		to: self;
		when: TripDetailParticipantWeightChanged
		send: #onWeightChanged:
		to: self;
		when: TripDetailGiftAmountChanged
		send: #onGiftAmountChanged:
		to: self;
		when: TripExpensePayerChanged send: #onPayerChanged: to: self;
		when: TripExpenseAmountChanged send: #onAmountChanged: to: self
]
