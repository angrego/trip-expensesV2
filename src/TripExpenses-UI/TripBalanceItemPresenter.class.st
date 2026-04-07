Class {
	#name : 'TripBalanceItemPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Balance',
	#package : 'TripExpenses-UI',
	#tag : 'Balance'
}

{ #category : 'rendering' }
TripBalanceItemPresenter >> renderView [
	self view
		renderParticipantName: self model participantName
		amount: self model amount
		currency: self model currency
]
