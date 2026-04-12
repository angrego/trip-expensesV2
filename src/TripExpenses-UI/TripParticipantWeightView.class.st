Class {
	#name : 'TripParticipantWeightView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-ParticipantWeight',
	#package : 'TripExpenses-UI',
	#tag : 'ParticipantWeight'
}

{ #category : 'web resources' }
TripParticipantWeightView class >> style [

	<webResource: #css>
	^ '
    :host { display: block; }
    .weight-row { display: flex; align-items: center; gap: .75rem; margin: .4rem 0; }
    .weight-row input[type=checkbox] { width: 18px; height: 18px; cursor: pointer; }
    .participant-name { flex: 1; font-size: .9rem; }
    .weight-input {
        width: 60px;
        border: 1px solid #ccc;
        border-radius: 6px;
        padding: .3rem .4rem;
        font-size: .95rem;
        text-align: center;
    }
    .weight-input:disabled { background: #f0f0f0; color: #aaa; }
.btn-pay-part {
    background: transparent;
    border: none;
    cursor: pointer;
    font-size: .85rem;
    padding: .2rem .3rem;
    border-radius: 4px;
    opacity: 0.6;
}
.btn-pay-part:hover { opacity: 1; }
    '
]

{ #category : 'web resources' }
TripParticipantWeightView class >> template [

	<webResource: #html>
	^ '
<div class="weight-row">
    <input id="checkbox" type="checkbox">
    <span id="name" class="participant-name"></span>
    <input id="weight" type="number" min="1" class="weight-input">
    <span id="share" class="share-label"></span>

</div>
    '
]

{ #category : 'event handling' }
TripParticipantWeightView >> handleInclusionChanged [

	| included |
	included := (self shadowedElementWithId: #checkbox) propertyAt:
		            'checked'.
	self serverAnnounce: (TripParticipantInclusionChanged
			 participantId: ((self shadowedElementWithId: #checkbox) attributeAt: 'data-pid')
			 included: included)
]

{ #category : 'event handling' }
TripParticipantWeightView >> handlePayPart [
    self serverAnnounce: (TripGiftPayPartRequested
        participantId: ((self shadowedElementWithId: #checkbox) attributeAt: 'data-pid'))
]

{ #category : 'event handling' }
TripParticipantWeightView >> handleWeightChanged [
    | w |
    w := (self shadowedElementWithId: #weight) propertyAt: 'value'.
    w isEmpty ifTrue: [ ^ self ].
    self serverAnnounce: (TripParticipantWeightChanged
        participantId: ((self shadowedElementWithId: #checkbox) attributeAt: 'data-pid')
        weight: w asNumber truncated)
]

{ #category : 'initialization' }
TripParticipantWeightView >> initializeShadowRoot [

	super initializeShadowRoot.
	(self shadowedElementWithId: #checkbox)
		when: CpChangeEvent
		send: #handleInclusionChanged
		to: self.
	(self shadowedElementWithId: #weight)
		when: CpInputEvent
		send: #handleWeightChanged
		to: self.
]

{ #category : 'rendering' }
TripParticipantWeightView >> renderIncluded: aBoolean [

	| cb weightInput |
	cb := self shadowedElementWithId: #'checkbox'.
	weightInput := self shadowedElementWithId: #'weight'.
	cb propertyAt: 'checked' put: aBoolean.
	aBoolean
		ifTrue: [ weightInput removeAttributeAt: 'disabled' ]
		ifFalse: [ weightInput attributeAt: 'disabled' put: '' ]
]

{ #category : 'rendering' }
TripParticipantWeightView >> renderName: aString [
    (self shadowedElementWithId: #name) textContent: aString
]

{ #category : 'rendering' }
TripParticipantWeightView >> renderParticipantId: anId [
    (self shadowedElementWithId: #checkbox) attributeAt: 'data-pid' put: anId
]

{ #category : 'rendering' }
TripParticipantWeightView >> renderShareLabel: aString [
    (self shadowedElementWithId: 'share') textContent: aString
]

{ #category : 'rendering' }
TripParticipantWeightView >> renderWeight: aNumber [
    (self shadowedElementWithId: #weight) propertyAt: 'value' put: aNumber printString
]
