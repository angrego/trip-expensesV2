Class {
	#name : 'TripParticipantWeightModel',
	#superclass : 'CpModel',
	#instVars : [
		'weight',
		'included',
		'shareLabel',
		'participant'
	],
	#category : 'TripExpenses-UI-ParticipantWeight',
	#package : 'TripExpenses-UI',
	#tag : 'ParticipantWeight'
}

{ #category : 'instance creation' }
TripParticipantWeightModel class >> fromEntry: anEntry [

	^ self
		  participant: anEntry participant
		  weight: anEntry weight
		  included: anEntry included.
]

{ #category : 'instance creation' }
TripParticipantWeightModel class >> participant: aParticipant weight: aWeight included: aBoolean [
    ^ self new
        setWeight:   aWeight
        included:    aBoolean
        participant: aParticipant;
        yourself
]

{ #category : 'accessing' }
TripParticipantWeightModel >> included [
	^ included
]

{ #category : 'accessing' }
TripParticipantWeightModel >> included: anObject [

	included := anObject.
	self valueChanged.
]

{ #category : 'accessing' }
TripParticipantWeightModel >> name [

	^ participant name
]

{ #category : 'accessing' }
TripParticipantWeightModel >> participant [
^participant
]

{ #category : 'accessing' }
TripParticipantWeightModel >> participant:aParticipant [
participant := aParticipant .
]

{ #category : 'accessing' }
TripParticipantWeightModel >> participantId [

	^ participant id value.
]

{ #category : 'presenter' }
TripParticipantWeightModel >> preferredPresenterClass [

	^ TripParticipantWeightPresenter
]

{ #category : 'accessing' }
TripParticipantWeightModel >> setWeight: aWeight included: aBoolean participant: aParticipant [

	participant := aParticipant.
	weight := aWeight.
	included := aBoolean.
	shareLabel :=String new.
]

{ #category : 'accessing' }
TripParticipantWeightModel >> shareLabel [
	^ shareLabel
]

{ #category : 'accessing' }
TripParticipantWeightModel >> shareLabel: aString [

	shareLabel := aString.
	self valueChanged.
]

{ #category : 'accessing' }
TripParticipantWeightModel >> shareLabelForAmount: anAmount totalWeight: aTotalWeight currency: aCurrency [
    self included ifFalse: [ ^ '–' ].
    aTotalWeight = 0 ifTrue: [ ^ '0 ' , aCurrency ].
    ^ (anAmount * weight / aTotalWeight roundTo: 0.01) printString , ' ' , aCurrency
]

{ #category : 'accessing' }
TripParticipantWeightModel >> updateShareForAmount: anAmount totalWeight: aTotalWeight currency: aCurrency [

	| label share stream |
	label := included
		         ifFalse: [ '–' ]
		         ifTrue: [
				         aTotalWeight = 0
					         ifTrue: [ '0 ' , aCurrency ]
					         ifFalse: [
							         share := anAmount * weight / aTotalWeight roundTo:
								                  0.01.
							         stream := WriteStream on: String new.
							         stream
								         nextPutAll: share printString;
								         nextPut: $ ;
								         nextPutAll: aCurrency.
							         stream contents ] ].
	shareLabel = label ifTrue: [ ^ self ].
	shareLabel := label.
	self valueChanged
]

{ #category : 'accessing' }
TripParticipantWeightModel >> weight [
	^ weight
]

{ #category : 'accessing' }
TripParticipantWeightModel >> weight: anObject [

	weight := anObject.
	self valueChanged.
]
