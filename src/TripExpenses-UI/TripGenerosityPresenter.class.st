Class {
	#name : 'TripGenerosityPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Balance',
	#package : 'TripExpenses-UI',
	#tag : 'Balance'
}

{ #category : 'rendering' }
TripGenerosityPresenter >> renderView [
    self
        renderAllChildViewsForModels: self model items
        atSlotNamed: #items
]
