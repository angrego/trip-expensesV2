Class {
	#name : 'TripBalanceItemPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'rendering' }
TripBalanceItemPresenter >> renderView [
	self view
		renderParticipantName: self model participantName
		amount: self model amount
		currency: self model currency
]
