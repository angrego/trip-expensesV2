Class {
	#name : 'TripParticipantModel',
	#superclass : 'CpModel',
	#instVars : [
		'participantId',
		'name'
	],
	#category : 'TripExpenses-Server-TripParticipant',
	#package : 'TripExpenses-Server',
	#tag : 'TripParticipant'
}

{ #category : 'instance creation' }
TripParticipantModel class >> fromDict: aDict [
	"Conservé pour compatibilité avec les tests existants."
	^ self new
		setId:   (aDict at: 'id')
		name:    (aDict at: 'name');
		yourself
]

{ #category : 'instance creation' }
TripParticipantModel class >> fromParticipant: aParticipant [
	"Construit depuis un objet Participant du domaine.
	 ParticipantId est un Value Object — on extrait sa valeur String."
	^ self new
		setId:   aParticipant id value
		name:    aParticipant name;
		yourself
]

{ #category : 'accessing' }
TripParticipantModel >> name [
	^ name
]

{ #category : 'accessing' }
TripParticipantModel >> participantId [
	^ participantId
]

{ #category : 'testing' }
TripParticipantModel >> preferredPresenterClass [
	^ TripParticipantPresenter
]

{ #category : 'private - setting' }
TripParticipantModel >> setId: anId name: aName [
	participantId := anId.
	name          := aName
]
