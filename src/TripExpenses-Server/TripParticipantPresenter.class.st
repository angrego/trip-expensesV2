Class {
	#name : 'TripParticipantPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-Server-TripParticipant',
	#package : 'TripExpenses-Server',
	#tag : 'TripParticipant'
}

{ #category : 'rendering' }
TripParticipantPresenter >> renderView [
	self view renderName: self model name
]
