"
Je suis annoncee quand l utilisateur soumet le formulaire d ajout de participant.
Je porte le nom saisi.
"
Class {
	#name : 'TripAddParticipantRequested',
	#superclass : 'Announcement',
	#instVars : [
		'participantName'
	],
	#category : 'TripExpenses-UI-Participant',
	#package : 'TripExpenses-UI',
	#tag : 'Participant'
}

{ #category : 'instance creation' }
TripAddParticipantRequested class >> participantName: aName [
	^ self new
		participantName: aName;
		yourself
]

{ #category : 'accessing' }
TripAddParticipantRequested >> participantName [
	^ participantName
]

{ #category : 'accessing' }
TripAddParticipantRequested >> participantName: aString [
	participantName := aString
]
