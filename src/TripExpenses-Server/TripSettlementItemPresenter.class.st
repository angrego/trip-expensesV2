Class {
	#name : 'TripSettlementItemPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-Server-TripSettlement',
	#package : 'TripExpenses-Server',
	#tag : 'TripSettlement'
}

{ #category : 'rendering' }
TripSettlementItemPresenter >> renderView [
	self view
		renderFrom:     self model fromName
		to:             self model toName
		amount:         self model amount
		currency:       self model currency
]
