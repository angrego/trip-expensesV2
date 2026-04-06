Class {
	#name : 'TripParticipantPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-TripDetail',
	#package : 'TripExpenses-UI',
	#tag : 'TripDetail'
}

{ #category : 'rendering' }
TripParticipantPresenter >> renderView [
	self view renderName: self model name
]
