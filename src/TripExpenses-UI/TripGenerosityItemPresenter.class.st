Class {
	#name : 'TripGenerosityItemPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Balance',
	#package : 'TripExpenses-UI',
	#tag : 'Balance'
}

{ #category : 'rendering' }
TripGenerosityItemPresenter >> renderView [
    self view
        renderParticipantName: self model participantName;
        renderAmount: self model amount;
        renderCurrency: self model currency
]
