"
Je suis le WebComponent autonome pour l ajout d un participant.
Je vis dans un slot de TripDetailView — je suis independante de son HTML.
"
Class {
	#name : 'TripAddParticipantView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-Participant',
	#package : 'TripExpenses-UI',
	#tag : 'Participant'
}

{ #category : 'web resources' }
TripAddParticipantView class >> style [
	<webResource: #css>
	^ '
	:host { display: block; margin-top: .5rem; }
	.btn-primary   { background: #5046e4; color: #fff; border: none; border-radius: 8px; padding: .5rem 1rem; cursor: pointer; }
	.btn-secondary { background: transparent; border: 1px solid #ccc; border-radius: 8px; padding: .5rem 1rem; cursor: pointer; }
	.add-form { border: 1px solid #e0e0e0; border-radius: 12px; padding: 1rem; margin-top: .5rem; }
	.input { display: block; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 8px; padding: .5rem; margin: .25rem 0 .75rem; font-size: 1rem; }
	.form-actions { display: flex; gap: .5rem; }
	.error-banner { background: #fee; border: 1px solid #f99; border-radius: 8px; padding: .5rem .75rem; margin-bottom: .5rem; color: #900; font-size: .9rem; }
	'
]

{ #category : 'web resources' }
TripAddParticipantView class >> template [
	<webResource: #html>
	^ '
	<button id="btn-show" class="btn-primary">+ Ajouter un participant</button>
	<div id="add-form" class="add-form" style="display:none">
		<div id="error-banner" class="error-banner" style="display:none"></div>
		<label>Nom du participant</label>
		<input id="participant-name" class="input" type="text" placeholder="Ex : Alice">
		<div class="form-actions">
			<button id="btn-add"    class="btn-primary">Ajouter</button>
			<button id="btn-cancel" class="btn-secondary">Annuler</button>
		</div>
	</div>
	'
]

{ #category : 'event handling' }
TripAddParticipantView >> handleAdd [
	| name |
	name := (self shadowedElementWithId: #'participant-name')
		        propertyAt: 'value'.
	self serverAnnounce:
		(TripAddParticipantRequested participantName: name)
]

{ #category : 'event handling' }
TripAddParticipantView >> handleHideForm [
	self serverAnnounce: TripAddParticipantHideFormRequested
]

{ #category : 'event handling' }
TripAddParticipantView >> handleShowForm [
	self serverAnnounce: TripAddParticipantShowFormRequested
]

{ #category : 'initialization' }
TripAddParticipantView >> initializeShadowRoot [
	super initializeShadowRoot.
	(self shadowedElementWithId: #'btn-show')
		when: CpClickEvent basicPrimary send: #handleShowForm  to: self.
	(self shadowedElementWithId: #'btn-add')
		when: CpClickEvent basicPrimary send: #handleAdd       to: self.
	(self shadowedElementWithId: #'btn-cancel')
		when: CpClickEvent basicPrimary send: #handleHideForm  to: self
]

{ #category : 'rendering' }
TripAddParticipantView >> renderErrorMessage: aString [
	| banner |
	banner := self shadowedElementWithId: #'error-banner'.
	aString isEmpty
		ifTrue:  [ banner style: 'display:none'. banner textContent: '' ]
		ifFalse: [ banner style: 'display:block'. banner textContent: aString ]
]

{ #category : 'rendering' }
TripAddParticipantView >> renderShowForm: aBoolean [
	| form btn |
	form := self shadowedElementWithId: #'add-form'.
	btn  := self shadowedElementWithId: #'btn-show'.
	aBoolean
		ifTrue:  [
			form style: 'display:block'. btn style: 'display:none'.
			(self shadowedElementWithId: #'participant-name') propertyAt: 'value' put: '' ]
		ifFalse: [
			form style: 'display:none'. btn style: 'display:block' ]
]
