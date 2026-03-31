Class {
	#name : 'ParticipantId',
	#superclass : 'Object',
	#instVars : [
		'value'
	],
	#category : 'TripExpenses-Domain-ValueObject',
	#package : 'TripExpenses-Domain-ValueObject'
}

{ #category : 'instance creation' }
ParticipantId class >> from: aString [

	^ self new value: aString; yourself 
]

{ #category : 'translating' }
ParticipantId class >> generate [

^self new value: UUID new asString 
]

{ #category : 'accessing' }
ParticipantId >> = other [

	^ other class = self class and: [ value = other value ]
]

{ #category : 'accessing' }
ParticipantId >> hash [ 
 ^ value hash 

]

{ #category : 'accessing' }
ParticipantId >> value [
	^value
]

{ #category : 'accessing' }
ParticipantId >> value: aString [

	value := aString
]
