"
Je rends une depense et son bouton de suppression.
Quand l utilisateur clique supprimer, je remonte l expenseId au parent
via parent onDeleteExpenseId: — le parent (TripDetailPresenter) sait recharger.
"
Class {
	#name : 'TripExpenseItemPresenter',
	#superclass : 'CpPresenter',
	#instVars : [
		'giftFormModel'
	],
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'event handling' }
TripExpenseItemPresenter >> onDeleteRequested [
	"Je connais mon modele donc son expenseId.
	 Je remonte au parent presenter (TripDetailPresenter) qui fait le travail."
	self parent onDeleteExpenseId: self model expenseId
]

{ #category : 'event handling' }
TripExpenseItemPresenter >> onGiftAddRequested: anAnnouncement [
 giftFormModel := TripExpenseGiftFormModel
        onService: self parent model service
        tripId: self parent model tripId
        expenseId: self model expenseId
        currentParticipantName: self application currentParticipantName.
    giftFormModel show.
    self renderChildViewForModel: giftFormModel atSlotNamed: #giftForm
]

{ #category : 'event handling' }
TripExpenseItemPresenter >> onGiftAdded [
    self parent onExpenseAdded
]

{ #category : 'view' }
TripExpenseItemPresenter >> onGiftFormHidden [
    self renderView
]

{ #category : 'rendering' }
TripExpenseItemPresenter >> renderView [
    self view
        attributeAt: 'data-expense-id' put: self model expenseId;
        renderDescription: self model description
        amount: self model amount
        currency: self model currency
        date: self model date
        payerName: self model payerName
        beneficiaryNames: self model beneficiaryNames.
    (giftFormModel isNotNil and: [ giftFormModel isShowing ])
        ifTrue: [
            self renderChildViewForModel: giftFormModel atSlotNamed: #giftForm ]
        ifFalse: [
            self renderAllChildViewsForModels: #() atSlotNamed: #giftForm ]
]

{ #category : 'view' }
TripExpenseItemPresenter >> viewCreated [

	super viewCreated.
	self view
		when: TripExpenseDeleteRequested
		send: #onDeleteRequested
		to: self;
		when: TripExpenseGiftAddRequested send: #onGiftAddRequested: to: self
]
