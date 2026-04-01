Class {
	#name : 'TripExpenseItemPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-Server-ExpenseItem',
	#package : 'TripExpenses-Server',
	#tag : 'ExpenseItem'
}

{ #category : 'rendering' }
TripExpenseItemPresenter >> renderView [
	self view
		renderDescription: self model description
		amount:            self model amount
		currency:          self model currency
		date:              self model date
]
