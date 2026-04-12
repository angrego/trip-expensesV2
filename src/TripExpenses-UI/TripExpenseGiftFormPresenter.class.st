Class {
	#name : 'TripExpenseGiftFormPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'rendering' }
TripExpenseGiftFormPresenter >> onAddGift [
    self model addGift.
    self model isShowing ifFalse: [
        self parent onGiftAdded ]
]

{ #category : 'rendering' }
TripExpenseGiftFormPresenter >> onHide [
    self model hide.
    self parent onGiftFormHidden
]

{ #category : 'rendering' }
TripExpenseGiftFormPresenter >> renderView [
    self view renderErrorMessage: (self model errorMessage ifNil: [ '' ]).
    self model isShowing ifTrue: [
        self
            renderChildViewForModel: self model giftEntryModel
            atSlotNamed: #gift ]
]

{ #category : 'rendering' }
TripExpenseGiftFormPresenter >> viewCreated [
    super viewCreated.
    self view
        when: TripExpenseGiftFormAddRequested send: #onAddGift to: self;
        when: TripExpenseGiftFormHideRequested send: #onHide    to: self
]
