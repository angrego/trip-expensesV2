"
Je suis le presenter du composant autonome d ajout de participant.
Je fais le lien entre TripAddParticipantModel et TripAddParticipantView.
Quand le modele announce valueChanged apres un ajout reussi,
TripDetailPresenter (mon parent) recharge les participants via son propre renderView.
"
Class {
	#name : 'TripAddParticipantPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-Server-TripDetail',
	#package : 'TripExpenses-Server',
	#tag : 'TripDetail'
}

{ #category : 'event handling' }
TripAddParticipantPresenter >> onAddParticipant: anAnnouncement [
	self model addParticipantNamed: anAnnouncement participantName
]

{ #category : 'event handling' }
TripAddParticipantPresenter >> onHideForm [
	self model hideForm
]

{ #category : 'event handling' }
TripAddParticipantPresenter >> onShowForm [
	self model showForm
]

{ #category : 'rendering' }
TripAddParticipantPresenter >> renderView [
	self view
		renderShowForm:    self model showingForm;
		renderErrorMessage: (self model errorMessage ifNil: [ '' ])
]

{ #category : 'rendering' }
TripAddParticipantPresenter >> viewCreated [
	super viewCreated.
	self view
		when: TripAddParticipantShowFormRequested send: #onShowForm    to: self;
		when: TripAddParticipantHideFormRequested send: #onHideForm    to: self;
		when: TripAddParticipantRequested        send: #onAddParticipant: to: self
]
