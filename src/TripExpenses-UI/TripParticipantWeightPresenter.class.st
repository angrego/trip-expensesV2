Class {
	#name : 'TripParticipantWeightPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-ParticipantWeight',
	#package : 'TripExpenses-UI',
	#tag : 'ParticipantWeight'
}

{ #category : 'event handling' }
TripParticipantWeightPresenter >> onInclusionChanged: anAnnouncement [

	self model included: anAnnouncement included.
	self parent onInclusionChanged: anAnnouncement.
]

{ #category : 'event handling' }
TripParticipantWeightPresenter >> onWeightChanged: anAnnouncement [

	self model weight: anAnnouncement weight.
	self parent onWeightChanged: anAnnouncement.
]

{ #category : 'rendering' }
TripParticipantWeightPresenter >> renderView [

	self view
		renderParticipantId: self model participantId;
		renderName: self model name;
		renderWeight: self model weight;
		renderIncluded: self model included;
		renderShareLabel:    self model shareLabel
]

{ #category : 'view' }
TripParticipantWeightPresenter >> viewCreated [

	super viewCreated.
	self view
		when: TripParticipantWeightChanged send: #onWeightChanged: to: self;
		when: TripParticipantInclusionChanged send: #onInclusionChanged: to: self
]
