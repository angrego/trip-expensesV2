Class {
	#name : 'TripParticipantWeightModel',
	#superclass : 'CpModel',
	#instVars : [
		'participantId',
		'name',
		'weight',
		'included'
	],
	#category : 'TripExpenses-UI-ParticipantWeight',
	#package : 'TripExpenses-UI',
	#tag : 'ParticipantWeight'
}

{ #category : 'instance creation' }
TripParticipantWeightModel class >> fromEntry: anEntry [
    ^ self new
        setParticipantId: anEntry participantId
        name:             anEntry name
        weight:           anEntry weight
        included:         anEntry included;
        yourself
]

{ #category : 'instance creation' }
TripParticipantWeightModel class >> participantId: aParticipantId name: aParticipantName weight: anInteger included: aBoolean [

	^ self new
		  setParticipantId: aParticipantId
		  name: aParticipantName
		  weight: anInteger
		  included: aBoolean;
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
	^ name
]

{ #category : 'accessing' }
TripParticipantWeightModel >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
TripParticipantWeightModel >> participantId [
	^ participantId
]

{ #category : 'accessing' }
TripParticipantWeightModel >> participantId: anObject [

	participantId := anObject
]

{ #category : 'accessing' }
TripParticipantWeightModel >> preferredPresenterClass [
    ^ TripParticipantWeightPresenter
]

{ #category : 'accessing' }
TripParticipantWeightModel >> setParticipantId: anId name: aName weight: aWeight included: aBoolean [
    participantId := anId.
    name          := aName.
    weight        := aWeight.
    included      := aBoolean
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
