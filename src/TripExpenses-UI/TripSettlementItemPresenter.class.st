Class {
	#name : 'TripSettlementItemPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Settlement',
	#package : 'TripExpenses-UI',
	#tag : 'Settlement'
}

{ #category : 'rendering' }
TripSettlementItemPresenter >> renderView [

	self view
		renderFrom: self model fromParticipantName
		to: self model toParticipantName
		amount: self model amount
		currency: self model currency
]
