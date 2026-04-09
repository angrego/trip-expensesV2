Class {
	#name : 'TripGenerosityItemModel',
	#superclass : 'CpModel',
	#instVars : [
		'participant',
		'amount'
	],
	#category : 'TripExpenses-UI-Balance',
	#package : 'TripExpenses-UI',
	#tag : 'Balance'
}

{ #category : 'initialization' }
TripGenerosityItemModel class >> setParticipant: aParticipant money: aMoney [

	^ self new setParticipant: aParticipant money: aMoney; yourself
]

{ #category : 'accessing' }
TripGenerosityItemModel >> amount [
	^ amount amount printString.
]

{ #category : 'accessing' }
TripGenerosityItemModel >> currency [
	^amount currency 
]

{ #category : 'accessing' }
TripGenerosityItemModel >> participantName [
	^participant name 
]

{ #category : 'presenter' }
TripGenerosityItemModel >> preferredPresenterClass [
    ^ TripGenerosityItemPresenter
]

{ #category : 'initialization' }
TripGenerosityItemModel >> setParticipant: aParticipant money: aMoney [ 
	participant:=aParticipant.
	amount:=aMoney.
]
