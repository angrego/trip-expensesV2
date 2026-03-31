Class {
	#name : 'ParticipantWeight',
	#superclass : 'Object',
	#instVars : [
		'participant',
		'weight'
	],
	#category : 'TripExpenses-Domain-ValueObject',
	#package : 'TripExpenses-Domain-ValueObject'
}

{ #category : 'as yet unclassified' }
ParticipantWeight class >> participant: aParticipant [

	^ self
		  participant: aParticipant
		  weight: 1
]

{ #category : 'as yet unclassified' }
ParticipantWeight class >> participant: aParticipant weight: anInteger [

anInteger <= 0 ifTrue: [ Error signal: 'Weight must be positive' ].
    ^ self new
        participant: aParticipant;
        weight: anInteger ;
        yourself
]

{ #category : 'accessing' }
ParticipantWeight >> participant [
	^ participant
]

{ #category : 'as yet unclassified' }
ParticipantWeight >> participant: aParticipant [ 
	participant:=aParticipant 
]

{ #category : 'accessing' }
ParticipantWeight >> weight [
	^ weight
]

{ #category : 'accessing' }
ParticipantWeight >> weight: anInteger [ 
	weight:=anInteger 
]
