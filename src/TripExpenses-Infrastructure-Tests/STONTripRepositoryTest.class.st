Class {
	#name : 'STONTripRepositoryTest',
	#superclass : 'TestCase',
	#instVars : [
		'repo',
		'tmpFile'
	],
	#category : 'TripExpenses-Infrastructure-Tests',
	#package : 'TripExpenses-Infrastructure-Tests'
}

{ #category : 'helpers' }
STONTripRepositoryTest >> makeTrip: aName [ 
	^ Trip name: aName currency: 'EUR'
]

{ #category : 'helpers' }
STONTripRepositoryTest >> makeTripWithParticipant: aName [ 
	| trip participant |
	trip        := self makeTrip: aName.
	participant := Participant name: 'Alice'.
	trip addParticipant: participant.
	^ trip
]

{ #category : 'running' }
STONTripRepositoryTest >> setUp [
	tmpFile := FileReference newTempFilePrefix: 'trip-test-' suffix: '.ston'.
	tmpFile ensureDelete.
	repo := STONTripRepository onFile: tmpFile
]

{ #category : 'running' }
STONTripRepositoryTest >> tearDown [
	tmpFile ensureDelete
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testAllTripsIsAliasForFindAll [
	repo save: (self makeTrip: 'Vacances').
	self assert: repo allTrips size equals: repo findAll size
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testDeleteByIdOnlyRemovesTargetTrip [
	| t1 t2 |
	t1 := self makeTrip: 'Vacances'.
	t2 := self makeTrip: 'Road trip'.
	repo save: t1.
	repo save: t2.
	repo deleteById: t1 id.
	self assert: repo findAll size equals: 1.
	self assert: repo findAll first id equals: t2 id
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testDeleteByIdRemovesTrip [
	| trip |
	trip := self makeTrip: 'Vacances'.
	repo save: trip.
	repo deleteById: trip id.
	self assert: repo findAll isEmpty
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testDeleteByIdThenFindByIdRaisesError [
	| trip |
	trip := self makeTrip: 'Vacances'.
	repo save: trip.
	repo deleteById: trip id.
	self should: [ repo findById: trip id ] raise: Error
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testDeleteByIdUnknownIdIsHarmless [
	"Supprimer un id inexistant ne doit pas lever d'erreur."
	repo save: (self makeTrip: 'Vacances').
	self shouldnt: [ repo deleteById: 'ghost-id' ] raise: Error.
	self assert: repo findAll size equals: 1
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testFindAllEmptyWhenFileAbsent [ 
	self assert: repo findAll isEmpty
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testFindAllReturnsAllSavedTrips [
	repo save: (self makeTrip: 'Vacances').
	repo save: (self makeTrip: 'Road trip').
	self assert: repo findAll size equals: 2
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testFindAllReturnsOrderedCollection [
	repo save: (self makeTrip: 'Vacances').
	self assert: (repo findAll isKindOf: SequenceableCollection)
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testFindByIdAmongSeveralTrips [
	| t1 t2 found |
	t1 := self makeTrip: 'Vacances'.
	t2 := self makeTrip: 'Road trip'.
	repo save: t1.
	repo save: t2.
	found := repo findById: t2 id.
	self assert: found name equals: 'Road trip'
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testFindByIdReturnsCorrectName [
	| trip found |
	trip := self makeTrip: 'Vacances'.
	repo save: trip.
	found := repo findById: trip id.
	self assert: found name equals: 'Vacances'
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testFindByIdReturnsCorrectTrip [ 
	| trip found |
	trip := self makeTrip: 'Vacances'.
	repo save: trip.
	found := repo findById: trip id.
	self assert: found id equals: trip id
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testFindByIdUnknownRaisesError [
	self should: [ repo findById: 'ghost-id' ] raise: Error
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testSaveCreatesFile [
	repo save: (self makeTrip: 'Vacances').
	self assert: tmpFile exists
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testSaveIsIdempotent [ 
	"Sauvegarder deux fois le même voyage ne doit pas le dupliquer."
	| trip |
	trip := self makeTrip: 'Vacances'.
	repo save: trip.
	repo save: trip.
	self assert: repo findAll size equals: 1
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testSaveMultipleTripsArePersisted [
	repo save: (self makeTrip: 'Vacances').
	repo save: (self makeTrip: 'Road trip').
	repo save: (self makeTrip: 'Week-end').
	self assert: repo findAll size equals: 3
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testSaveOneTripThenFindAll [ 
	| trip |
	trip := self makeTrip: 'Vacances'.
	repo save: trip.
	self assert: repo findAll size equals: 1
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testSavePreservesCurrency [ 
	| trip found |
	trip := self makeTrip: 'Vacances'.
	repo save: trip.
	found := repo findAll first.
	self assert: found currency equals: 'EUR'
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testSavePreservesId [ 
	| trip found |
	trip := self makeTrip: 'Vacances'.
	repo save: trip.
	found := repo findAll first.
	self assert: found id equals: trip id
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testSavePreservesName [ 
	| trip found |
	trip := self makeTrip: 'Vacances'.
	repo save: trip.
	found := repo findAll first.
	self assert: found name equals: 'Vacances'
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testSavePreservesParticipants [ 
	"Les participants doivent survivre à la sérialisation STON."
	| trip found |
	trip  := self makeTripWithParticipant: 'Vacances'.
	repo save: trip.
	found := repo findAll first.
	self assert: found participants size equals: 1.
	self assert: found participants first name equals: 'Alice'
]

{ #category : 'helpers' }
STONTripRepositoryTest >> testSaveUpdatesExistingTrip [
	"Modifier un voyage et le resauvegarder doit écraser l'ancienne version."
	| trip found |
	trip := self makeTrip: 'Vacances'.
	repo save: trip.
	trip name: 'Mega Vacances'.
	repo save: trip.
	found := repo findAll first.
	self assert: found name equals: 'Mega Vacances'
]
