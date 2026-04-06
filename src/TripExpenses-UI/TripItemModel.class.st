"
I represent a single trip summary for display in the list.
I only hold simple types (String, Number) so CP can encode me for the browser.
"
Class {
	#name : 'TripItemModel',
	#superclass : 'CpModel',
	#instVars : [
		'tripId',
		'name',
		'currency',
		'participantCount',
		'totalExpenses'
	],
	#category : 'TripExpenses-UI-TripList',
	#package : 'TripExpenses-UI',
	#tag : 'TripList'
}

{ #category : 'instance creation' }
TripItemModel class >> fromDict: aDict [
	"Conservé pour les tests de sérialisation existants (STONTripRepositoryTest, etc.)
	 Ne pas utiliser dans le code de production — préférer fromTrip:."
	^ self new
		setTripId:           (aDict at: 'id');
		setName:             (aDict at: 'name');
		setCurrency:         (aDict at: 'currency');
		setParticipantCount: (aDict at: 'participantCount');
		setTotalExpenses:    (aDict at: 'totalExpenses');
		yourself
]

{ #category : 'instance creation' }
TripItemModel class >> fromTrip: aTrip [
	"Construit un TripItemModel à partir d'un objet Trip du domaine.
	 C'est la seule factory à utiliser dans le code refactorisé."
	^ self new
		setTripId:           aTrip id;
		setName:             aTrip name;
		setCurrency:         aTrip currency;
		setParticipantCount: aTrip participants size;
		setTotalExpenses:    aTrip totalExpenses amount;
		yourself
]

{ #category : 'accessing' }
TripItemModel >> currency [
	^ currency
]

{ #category : 'accessing' }
TripItemModel >> name [
	^ name
]

{ #category : 'accessing' }
TripItemModel >> participantCount [
	^ participantCount
]

{ #category : 'testing' }
TripItemModel >> preferredPresenterClass [
	^ TripItemPresenter
]

{ #category : 'private - setting' }
TripItemModel >> setCurrency: aString [
	currency := aString
]

{ #category : 'private - setting' }
TripItemModel >> setName: aString [
	name := aString
]

{ #category : 'private - setting' }
TripItemModel >> setParticipantCount: aNumber [
	participantCount := aNumber
]

{ #category : 'private - setting' }
TripItemModel >> setTotalExpenses: aNumber [
	totalExpenses := aNumber
]

{ #category : 'private - setting' }
TripItemModel >> setTripId: aString [
	tripId := aString
]

{ #category : 'accessing' }
TripItemModel >> totalExpenses [
	^ totalExpenses
]

{ #category : 'accessing' }
TripItemModel >> tripId [
	^ tripId
]
