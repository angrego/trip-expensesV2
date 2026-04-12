Class {
	#name : 'TripLoginRequested',
	#superclass : 'Announcement',
	#instVars : [
		'participantName',
		'password'
	],
	#category : 'TripExpenses-UI-Login',
	#package : 'TripExpenses-UI',
	#tag : 'Login'
}

{ #category : 'instance creation' }
TripLoginRequested class >> participantName: aName password: aPassword [
    ^ self new
        participantName: aName;
        password: aPassword;
        yourself
]

{ #category : 'accessing' }
TripLoginRequested >> participantName [

	^ participantName
]

{ #category : 'accessing' }
TripLoginRequested >> participantName: anObject [

	participantName := anObject
]

{ #category : 'accessing' }
TripLoginRequested >> password [

	^ password
]

{ #category : 'accessing' }
TripLoginRequested >> password: anObject [

	password := anObject
]
