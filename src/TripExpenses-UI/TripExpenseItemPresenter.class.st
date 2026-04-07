"
Je rends une depense et son bouton de suppression.
Quand l utilisateur clique supprimer, je remonte l expenseId au parent
via parent onDeleteExpenseId: — le parent (TripDetailPresenter) sait recharger.
"
Class {
	#name : 'TripExpenseItemPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Expense',
	#package : 'TripExpenses-UI',
	#tag : 'Expense'
}

{ #category : 'rendering' }
TripExpenseItemPresenter >> onDeleteRequested [
	"Je connais mon modele donc son expenseId.
	 Je remonte au parent presenter (TripDetailPresenter) qui fait le travail."
	self parent onDeleteExpenseId: self model expenseId
]

{ #category : 'rendering' }
TripExpenseItemPresenter >> renderView [
	"Stocke l expenseId dans data-expense-id sur la vue pour que
	 la vue puisse le lire au moment du clic sans connaitre le modele."

	self view
		attributeAt: 'data-expense-id' put: self model expenseId;
		renderDescription: self model description
		amount: self model amount
		currency: self model currency
		date: self model date
		payerName: self model payerName
		beneficiaryNames: self model beneficiaryNames
]

{ #category : 'rendering' }
TripExpenseItemPresenter >> viewCreated [
	super viewCreated.
	self view
		when: TripExpenseDeleteRequested
		send: #onDeleteRequested
		to:   self
]
