Class {
	#name : 'TripExpenseFormPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'rendering' }
TripExpenseFormPresenter >> buildGiftEntries [

	self model giftEntries ifNil: [ ^ #(  ) ].
	^ (self model giftEntries collect: [ :e |
			   Dictionary new
				   at: 'entryId' put: e entryId;
				   at: 'fromId' put: (e fromId ifNil: [ '' ]);
				   at: 'toId' put: (e toId ifNil: [ '' ]);
				   at: 'mode' put: e mode asString;
				   at: 'amount' put: (e amount ifNil: [ 0 ]);
				   yourself ]) asArray
]

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
TripExpenseFormPresenter >> onGiftAdd [
    Transcript showCr: 'onGiftAdd appelé'.

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
TripExpenseFormPresenter >> viewCreated [

	super viewCreated.
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
		when: TripDetailGiftAmountChanged send: #onGiftAmountChanged: to: self.
]
