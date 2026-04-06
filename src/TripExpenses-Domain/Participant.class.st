Class {
	#name : 'Participant',
	#superclass : 'Object',
	#instVars : [
		'id',
		'name'
	],
	#category : 'TripExpenses-Domain-TripExpenses-Domain-Model',
	#package : 'TripExpenses-Domain',
	#tag : 'TripExpenses-Domain-Model'
}

{ #category : 'accessing' }
Participant class >> name: aString [
(aString isNil or: [ aString trim isEmpty ]) ifTrue: [
		Error signal: 'Name cannot be blank' ].
	^ self new
		  id: ParticipantId generate;
		  name: aString;
		  yourself
]

{ #category : 'accessing' }
Participant >> = other [

^ (self class=other class) and:[other id= id].
]

{ #category : 'accessing' }
Participant >> hash [ 
    ^ id hash
]

{ #category : 'accessing' }
Participant >> id [
	^ id
]

{ #category : 'accessing' }
Participant >> id: anUUID [
id:=anUUID 
]

{ #category : 'accessing' }
Participant >> name [
	^ name
]

{ #category : 'accessing' }
Participant >> name: aString [ 
	name := aString
]
