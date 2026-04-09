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
        renderMaxAmount: self model maxAmount;
        renderSliderValue: self model sliderValue.
    self
        renderAllChildViewsForModels: self model beneficiaries
        atSlotNamed: #beneficiaries
]

{ #category : 'view' }
TripGiftEntryPresenter >> viewCreated [
super viewCreated.
    self view
        when: TripGiftSliderChanged       send: #onSliderChanged:     to: self;
        when: TripGiftRemoveRequested     send: #onRemoveRequested     to: self;
        when: TripParticipantWeightChanged    send: #onWeightChanged:  to: self;
        when: TripParticipantInclusionChanged send: #onInclusionChanged: to: self
]
