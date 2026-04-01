Class {
	#name : 'TripParticipantModel',
	#superclass : 'CpModel',
	#instVars : [
		'participantId',
		'name'
	],
	#category : 'TripExpenses-Server',
	#package : 'TripExpenses-Server'
}

{ #category : 'instance creation' }
TripParticipantModel class >> fromDict: aDict [
	^ self new
		setId:   (aDict at: 'id')
		name:    (aDict at: 'name');
		yourself
]

{ #category : 'accessing' }
TripParticipantModel >> name [ ^ name
]

{ #category : 'accessing' }
TripParticipantModel >> participantId [ ^ participantId
]

{ #category : 'testing' }
TripParticipantModel >> preferredPresenterClass [ ^ TripParticipantPresenter
]

{ #category : 'initialization' }
TripParticipantModel >> setId: anId name: aName [
	participantId := anId.
	name          := aName
]
