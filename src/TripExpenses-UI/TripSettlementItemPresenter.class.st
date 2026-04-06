Class {
	#name : 'TripSettlementItemPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'rendering' }
TripSettlementItemPresenter >> renderView [
	self view
		renderFrom: self model fromName
		to: self model toName
		amount: self model amount
		currency: self model currency
]
