Class {
	#name : 'TripBalanceItemPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-Server-Balance',
	#package : 'TripExpenses-Server',
	#tag : 'Balance'
}

{ #category : 'rendering' }
TripBalanceItemPresenter >> renderView [
	self view
		renderParticipantName: self model participantName
		amount:                self model amount
		currency:              self model currency
]
