Class {
	#name : 'TripGenerosityItemModel',
	#superclass : 'CpModel',
	#instVars : [
		'participant',
		'amount',
		'rank'
	],
	#category : 'TripExpenses-UI-Balance',
	#package : 'TripExpenses-UI',
	#tag : 'Balance'
}

{ #category : 'initialization' }
TripGenerosityItemModel class >> setParticipant: aParticipant money: aMoney rank: aRank [

	^ self new
		  setParticipant: aParticipant money: aMoney rank:aRank;
		  yourself
]

{ #category : 'accessing' }
TripGenerosityItemModel >> amount [
	^ amount amount printString.
]

{ #category : 'accessing' }
TripGenerosityItemModel >> currency [
	^amount currency 
]

{ #category : 'initialization' }
TripGenerosityItemModel >> medal [
    rank = 1 ifTrue: [ ^ '🥇' ].
    rank = 2 ifTrue: [ ^ '🥈' ].
    rank = 3 ifTrue: [ ^ '🥉' ].
    ^ ''
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
TripGenerosityItemModel >> setParticipant: aParticipant money: aMoney rank:aRank [

	participant := aParticipant.
	rank:=aRank.
	amount := aMoney
]
