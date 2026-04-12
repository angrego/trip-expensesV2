Class {
	#name : 'TripGiftPayPartRequested',
	#superclass : 'Announcement',
	#instVars : [
		'participantId'
	],
	#category : 'TripExpenses-UI-Gift',
	#package : 'TripExpenses-UI',
	#tag : 'Gift'
}

{ #category : 'accessing' }
TripGiftPayPartRequested class >> participantId: aString [

	^ self new
		  participantId: aString;
		  yourself
]

{ #category : 'accessing' }
TripGiftPayPartRequested >> participantId [

	^ participantId
]

{ #category : 'accessing' }
TripGiftPayPartRequested >> participantId: aParticipantId [

	participantId := aParticipantId
]
