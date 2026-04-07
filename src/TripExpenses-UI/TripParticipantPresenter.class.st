Class {
	#name : 'TripParticipantPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Participant',
	#package : 'TripExpenses-UI',
	#tag : 'Participant'
}

{ #category : 'rendering' }
TripParticipantPresenter >> renderView [
	self view renderName: self model name
]
