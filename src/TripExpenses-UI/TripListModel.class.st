"
Je suis le modèle CP pour la liste des voyages.
Mon service est un TripApplicationService — je ne connais pas TripExpensesServerApp.
Je n'utilise aucun Dictionary JSON / handleMessage:.
"
Class {
	#name : 'TripListModel',
	#superclass : 'CpModel',
	#instVars : [
		'service',
		'trips',
		'errorMessage',
		'showingCreateForm'
	],
	#category : 'TripExpenses-UI-TripList',
	#package : 'TripExpenses-UI',
	#tag : 'TripList'
}

{ #category : 'instance creation' }
TripListModel class >> onService: aTripApplicationService [
	"aTripApplicationService est un TripApplicationService, jamais un TripExpensesServerApp."
	^ self new
		service: aTripApplicationService;
		loadTrips;
		yourself
]

{ #category : 'operations' }
TripListModel >> createTripNamed: aName currency: aCurrency [
	"Valide, crée le voyage via le service, puis recharge la liste."
	(aName isNil or: [ aName trim isEmpty ]) ifTrue: [
			errorMessage := 'Le nom du voyage ne peut pas être vide'.
			self valueChanged.
			^ self ].
	(aCurrency isNil or: [ aCurrency trim isEmpty ]) ifTrue: [
			errorMessage := 'La devise ne peut pas être vide'.
			self valueChanged.
			^ self ].
	service createTrip: aName trim currency: aCurrency trim.
	showingCreateForm := false.
	self loadTrips
]

{ #category : 'accessing' }
TripListModel >> errorMessage [
	^ errorMessage
]

{ #category : 'accessing' }
TripListModel >> errorMessage: aStringOrNil [
	errorMessage := aStringOrNil
]

{ #category : 'operations' }
TripListModel >> hideCreateForm [
	showingCreateForm := false.
	errorMessage := nil.
	self valueChanged
]

{ #category : 'initialization' }
TripListModel >> initialize [
	super initialize.
	trips := OrderedCollection new.
	errorMessage := nil.
	showingCreateForm := false
]

{ #category : 'operations' }
TripListModel >> loadTrips [
	"Charge tous les voyages depuis le service domaine directement. Chaque Trip est converti en TripItemModel via fromTrip:."

	trips := service allTrips collect: [ :trip |
		         TripItemModel fromTrip: trip ].
	errorMessage := nil.
	self valueChanged
]

{ #category : 'presenter' }
TripListModel >> preferredPresenterClass [
	^ TripListPresenter
]

{ #category : 'private - setting' }
TripListModel >> service: aTripApplicationService [
	service := aTripApplicationService
]

{ #category : 'operations' }
TripListModel >> showCreateForm [
	showingCreateForm := true.
	errorMessage := nil.
	self valueChanged
]

{ #category : 'accessing' }
TripListModel >> showingCreateForm [
	^ showingCreateForm
]

{ #category : 'accessing' }
TripListModel >> trips [
	^ trips
]
