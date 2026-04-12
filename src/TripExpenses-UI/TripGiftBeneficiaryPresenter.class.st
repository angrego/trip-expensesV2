Class {
	#name : 'TripGiftBeneficiaryPresenter',
	#superclass : 'CpPresenter',
	#category : 'TripExpenses-UI-Gift',
	#package : 'TripExpenses-UI',
	#tag : 'Gift'
}

{ #category : 'event handling' }
TripGiftBeneficiaryPresenter >> onInclusionChanged: anAnnouncement [
    self model included: anAnnouncement included.
    self parent onInclusionChanged: anAnnouncement
]

{ #category : 'event handling' }
TripGiftBeneficiaryPresenter >> onPayPartRequested: anAnnouncement [
    self parent onPayPartRequested: anAnnouncement
]

{ #category : 'event handling' }
TripGiftBeneficiaryPresenter >> onWeightChanged: anAnnouncement [
    self model weight: anAnnouncement weight.
    self parent onWeightChanged: anAnnouncement
]

{ #category : 'view' }
TripGiftBeneficiaryPresenter >> renderView [
    self view
        renderParticipantId: self model participantId;
        renderName:          self model name;
        renderWeight:        self model weight;
        renderIncluded:      self model included;
        renderShareLabel:    self model shareLabel
]

{ #category : 'view' }
TripGiftBeneficiaryPresenter >> viewCreated [
    super viewCreated.
    self view
        when: TripParticipantWeightChanged    send: #onWeightChanged:    to: self;
        when: TripParticipantInclusionChanged send: #onInclusionChanged: to: self;
        when: TripGiftPayPartRequested        send: #onPayPartRequested: to: self
]
