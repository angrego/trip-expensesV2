Class {
	#name : 'TripGiftEntryPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Gift',
	#package : 'TripExpenses-UI',
	#tag : 'Gift'
}

{ #category : 'event handling' }
TripGiftEntryPresenter >> onBeneficiaryToggled: anAnnouncement [
    anAnnouncement included
        ifTrue:  [ self model includeBeneficiaryId: anAnnouncement participantId ]
        ifFalse: [ self model excludeBeneficiaryId: anAnnouncement participantId ]
]

{ #category : 'event handling' }
TripGiftEntryPresenter >> onInclusionChanged: anAnnouncement [
    anAnnouncement included
        ifTrue:  [ self model includeBeneficiaryId: anAnnouncement participantId ]
        ifFalse: [ self model excludeBeneficiaryId: anAnnouncement participantId ]
]

{ #category : 'event handling' }
TripGiftEntryPresenter >> onPayPartRequested: anAnnouncement [
    self model payPartFor: anAnnouncement participantId
]

{ #category : 'event handling' }
TripGiftEntryPresenter >> onRemoveGiftEntry: aGiftEntryModel [
    self model removeGiftEntryId: aGiftEntryModel entryId
]

{ #category : 'event handling' }
TripGiftEntryPresenter >> onRemoveRequested [

	self parent onRemoveGiftEntry: self model
]

{ #category : 'event handling' }
TripGiftEntryPresenter >> onSliderChanged: anAnnouncement [

	self model sliderValue: anAnnouncement amountValue
]

{ #category : 'rendering' }
TripGiftEntryPresenter >> onWeightChanged: anAnnouncement [

    self model setWeight: anAnnouncement weight forBeneficiaryId: anAnnouncement participantId

]

{ #category : 'rendering' }
TripGiftEntryPresenter >> renderView [

	self view
    renderSlider: self model sliderValue
    max: self model maxAmount
    payerShare: self model payerTheoreticalShare amount.
	self
		renderAllChildViewsForModels: self model beneficiaries
		atSlotNamed: #beneficiaries
]

{ #category : 'view' }
TripGiftEntryPresenter >> viewCreated [

	super viewCreated.
	self view
		when: TripGiftSliderChanged send: #onSliderChanged: to: self;
		when: TripGiftRemoveRequested send: #onRemoveRequested to: self;
		when: TripParticipantWeightChanged send: #onWeightChanged: to: self;
		when: TripGiftPayPartRequested send: #onPayPartRequested: to: self;
		when: TripParticipantInclusionChanged
		send: #onInclusionChanged:
		to: self
]
