"
Je suis le modele du composant autonome d ajout de participant.
Je connais le service et le tripId — je n ai pas besoin de TripDetailModel.
Je suis injecte dans TripDetailView via un slot nomme addParticipant.
Quand j ajoute un participant avec succes, j annonce valueChanged.
TripDetailPresenter observe ce changement pour recharger les participants.
"
Class {
	#name : 'TripAddParticipantModel',
	#superclass : 'CpModel',
	#instVars : [
		'service',
		'tripId',
		'showingForm',
		'errorMessage'
	],
	#category : 'TripExpenses-Server-TripDetail',
	#package : 'TripExpenses-Server',
	#tag : 'TripDetail'
}

{ #category : 'instance creation' }
TripAddParticipantModel class >> onService: aTripApplicationService tripId: aTripId [
	^ self new
		service: aTripApplicationService;
		tripId:  aTripId;
		yourself
]

{ #category : 'operations' }
TripAddParticipantModel >> addParticipantNamed: aName [
	(aName isNil or: [ aName trim isEmpty ]) ifTrue: [
		errorMessage := 'Le nom ne peut pas etre vide'.
		self valueChanged.
		^ self ].
	[ service addParticipant: aName trim toTrip: tripId ]
		on: Error
		do: [ :e |
			errorMessage := e messageText.
			self valueChanged.
			^ self ].
	showingForm  := false.
	errorMessage := nil.
	self valueChanged
]

{ #category : 'accessing' }
TripAddParticipantModel >> errorMessage [
	^ errorMessage
]

{ #category : 'accessing' }
TripAddParticipantModel >> errorMessage: aStringOrNil [
	errorMessage := aStringOrNil
]

{ #category : 'operations' }
TripAddParticipantModel >> hideForm [
	showingForm  := false.
	errorMessage := nil.
	self valueChanged
]

{ #category : 'initialization' }
TripAddParticipantModel >> initialize [
	super initialize.
	showingForm  := false.
	errorMessage := nil
]

{ #category : 'testing' }
TripAddParticipantModel >> preferredPresenterClass [
	^ TripAddParticipantPresenter
]

{ #category : 'private - setting' }
TripAddParticipantModel >> service: aTripApplicationService [
	service := aTripApplicationService
]

{ #category : 'operations' }
TripAddParticipantModel >> showForm [
	showingForm  := true.
	errorMessage := nil.
	self valueChanged
]

{ #category : 'accessing' }
TripAddParticipantModel >> showingForm [
	^ showingForm
]

{ #category : 'private - setting' }
TripAddParticipantModel >> tripId: anId [
	tripId := anId
]
