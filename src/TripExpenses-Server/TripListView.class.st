"
I am the View for TripListModel.
I am a WebComponent running in the browser.
I am a Passive View: I only render what the Presenter tells me.
I announce user actions to the Presenter via serverAnnounce.

La navigation vers un voyage est gérée par TripItemView (child view) → TripItemPresenter.
Je n'annonce plus TripListTripSelected — ce chemin était mort.
La méthode buildTripItemFor: a été supprimée — c'était du code mort.
"
Class {
	#name : 'TripListView',
	#superclass : 'CpView',
	#category : 'TripExpenses-Server-TripList',
	#package : 'TripExpenses-Server',
	#tag : 'TripList'
}

{ #category : 'web resources' }
TripListView class >> style [
	<webResource: #css>
	^ '
		:host { display: block; padding: 1rem; font-family: sans-serif; }
		.header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
		h1 { margin: 0; font-size: 1.4rem; }
		.btn-primary   { background: #5046e4; color: #fff; border: none; border-radius: 8px; padding: .5rem 1rem; cursor: pointer; }
		.btn-secondary { background: transparent; border: 1px solid #ccc; border-radius: 8px; padding: .5rem 1rem; cursor: pointer; }
		.error-banner  { background: #fee; border: 1px solid #f99; border-radius: 8px; padding: .75rem; margin-bottom: 1rem; color: #900; }
		.create-form   { border: 1px solid #e0e0e0; border-radius: 12px; padding: 1.5rem; margin-bottom: 1rem; }
		.create-form h2 { margin: 0 0 1rem; font-size: 1.1rem; }
		.input { display: block; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 8px; padding: .5rem; margin: .25rem 0 1rem; font-size: 1rem; }
		.form-actions  { display: flex; gap: .5rem; }
		.empty-state   { color: #999; text-align: center; padding: 2rem; }
	'
]

{ #category : 'web resources' }
TripListView class >> template [
	<webResource: #html>
	^ '
		<div class="header">
			<h1>Mes voyages</h1>
			<button id="btn-new" class="btn-primary">Nouveau voyage</button>
		</div>
		<div id="error-banner" class="error-banner" style="display:none"></div>
		<div id="create-form" class="create-form" style="display:none">
			<h2>Nouveau voyage</h2>
			<label>Nom du voyage</label>
			<input id="trip-name"     class="input" type="text" placeholder="Ex : Vacances été 2026">
			<label>Devise</label>
			<input id="trip-currency" class="input" type="text" value="EUR">
			<div class="form-actions">
				<button id="btn-create" class="btn-primary">Créer</button>
				<button id="btn-cancel" class="btn-secondary">Annuler</button>
			</div>
		</div>
		<slot name="trips"></slot>
	'
]

{ #category : 'initialization' }
TripListView >> buildTripItemFor: tripDict [
	| li name meta tripId |
	tripId := tripDict at: 'id'.
	li     := CpHtmlElement newWithTag: 'li'.
	li addClass: 'trip-item'.
	name := CpHtmlElement newWithTag: 'div'.
	name addClass: 'trip-name'.
	name textContent: (tripDict at: 'name').
	meta := CpHtmlElement newWithTag: 'div'.
	meta addClass: 'trip-meta'.
	meta textContent:
		(tripDict at: 'currency') ,
		' · ' , (tripDict at: 'participantCount') printString , ' participant(s)' ,
		' · ' , (tripDict at: 'totalExpenses') printString , ' ' , (tripDict at: 'currency').
	li appendChild: name.
	li appendChild: meta.
	li
		when: CpClickEvent basicPrimary
		do: [ self serverAnnounce: (TripListTripSelected tripId: tripId) ].
	^ li
]

{ #category : 'event handling' }
TripListView >> handleCancelClicked [
	self serverAnnounce: TripListHideFormRequested
]

{ #category : 'event handling' }
TripListView >> handleCreateClicked [
	| name currency |
	name     := (self shadowedElementWithId: #'trip-name')     propertyAt: 'value'.
	currency := (self shadowedElementWithId: #'trip-currency') propertyAt: 'value'.
	self serverAnnounce: (TripListCreateRequested tripName: name currency: currency)
]

{ #category : 'event handling' }
TripListView >> handleNewClicked [
	self serverAnnounce: TripListShowFormRequested
]

{ #category : 'initialization' }
TripListView >> initializeShadowRoot [
	super initializeShadowRoot.
	(self shadowedElementWithId: #'btn-new')
		when: CpClickEvent basicPrimary send: #handleNewClicked    to: self.
	(self shadowedElementWithId: #'btn-create')
		when: CpClickEvent basicPrimary send: #handleCreateClicked to: self.
	(self shadowedElementWithId: #'btn-cancel')
		when: CpClickEvent basicPrimary send: #handleCancelClicked to: self
]

{ #category : 'rendering' }
TripListView >> renderErrorMessage: aStringOrNil [
	| banner |
	banner := self shadowedElementWithId: #'error-banner'.
	aStringOrNil isNil
		ifTrue:  [ banner style: 'display:none'. banner textContent: '' ]
		ifFalse: [ banner style: 'display:block'. banner textContent: aStringOrNil ]
]

{ #category : 'rendering' }
TripListView >> renderShowCreateForm: aBoolean [
	| form btnNew |
	form   := self shadowedElementWithId: #'create-form'.
	btnNew := self shadowedElementWithId: #'btn-new'.
	aBoolean
		ifTrue:  [
			form style: 'display:block'.
			btnNew style: 'display:none'.
			(self shadowedElementWithId: #'trip-name') propertyAt: 'value' put: '' ]
		ifFalse: [
			form style: 'display:none'.
			btnNew style: 'display:block' ]
]
