Class {
	#name : 'TripExpenseFormPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'event handling' }
TripExpenseFormPresenter >> onAddExpense: anAnnouncement [
    | amount |
    amount := anAnnouncement amountString asNumber.
    self model
        addExpense: anAnnouncement description
        amount: amount
        payerId: anAnnouncement payerId.
    self model isShowing ifFalse: [ self parent onExpenseAdded ]
]

{ #category : 'event handling' }
TripExpenseFormPresenter >> onAmountChanged: anAnnouncement [

	self model setCurrentAmount: anAnnouncement amount.
]

{ #category : 'event handling' }
TripExpenseFormPresenter >> onHideExpenseForm [

	self model hide.
	self parent onExpenseFormHidden
]

{ #category : 'event handling' }
TripExpenseFormPresenter >> onInclusionChanged: anAnnouncement [

 | entry |
    entry := self model participantEntries
        detect: [ :e | e participantId = anAnnouncement participantId ]
        ifNone: [ ^ self ].
    entry included: anAnnouncement included.
    self model updateShareLabels
]

{ #category : 'event handling' }
TripExpenseFormPresenter >> onPayerChanged: anAnnouncement [
    self model setCurrentPayerId: anAnnouncement payerId
]

{ #category : 'event handling' }
TripExpenseFormPresenter >> onRemoveGiftEntry: aGiftEntryModel [
    self model removeGiftEntryId: aGiftEntryModel entryId
]

{ #category : 'event handling' }
TripExpenseFormPresenter >> onWeightChanged: anAnnouncement [

    | entry |
    entry := self model participantEntries
        detect: [ :e | e participantId = anAnnouncement participantId ]
        ifNone: [ ^ self ].
    entry weight: anAnnouncement weight.
    self model updateShareLabels
]

{ #category : 'rendering' }
TripExpenseFormPresenter >> renderPayerOptions [
    self view renderPayerOptions: (self model participantEntries collect: [ :e |
        Array with: e participantId with: e name ]) asArray
]

{ #category : 'rendering' }
TripExpenseFormPresenter >> renderView [

	self model justOpened ifTrue: [
			self view reset.
			self model clearJustOpened ].
	self view
		renderPayerOptions: (self model participantEntries collect: [ :e |
					 Array with: e participantId with: e name ]) asArray
		currentPayerId: self model currentPayerId locked: true;
		renderErrorMessage: (self model errorMessage ifNil: [ '' ]).
	self
		renderAllChildViewsForModels: self model participantWeightModels
		atSlotNamed: #weights.
	self model updateShareLabels
]

{ #category : 'view' }
TripExpenseFormPresenter >> viewCreated [

	super viewCreated.
	self view
		when: TripDetailAddExpenseRequested send: #onAddExpense: to: self;
		when: TripDetailHideExpenseFormRequested
		send: #onHideExpenseForm
		to: self;
		when: TripParticipantInclusionChanged
		send: #onInclusionChanged:
		to: self;
		when: TripParticipantWeightChanged send: #onWeightChanged: to: self;
		when: TripExpensePayerChanged send: #onPayerChanged: to: self;
		when: TripExpenseAmountChanged send: #onAmountChanged: to: self
]
