"
I display the detail of a trip: header, participants, expenses, balances, settlements.
I am a Passive View — I only receive Strings and Booleans from my Presenter.
The back button announces TripDetailBackRequested.
"
Class {
	#name : 'TripDetailView',
	#superclass : 'CpView',
	#category : 'TripExpenses-Server-TripDetail',
	#package : 'TripExpenses-Server',
	#tag : 'TripDetail'
}

{ #category : 'web resources' }
TripDetailView class >> style [
	<webResource: #css>
	^ '
	:host { display: block; padding: 1rem; font-family: sans-serif; max-width: 640px; margin: 0 auto; }
	.header { margin-bottom: 1.5rem; display: flex; align-items: center; gap: 1rem; }
	.btn-back { background: transparent; border: none; cursor: pointer; font-size: 1.2rem; color: #5046e4; padding: 0; }
	.trip-name { font-size: 1.5rem; font-weight: 500; margin: 0 0 .25rem; flex: 1; }
	.trip-meta { color: #666; font-size: .9rem; }
	.section { margin-bottom: 1.5rem; }
	.section-title { font-size: 1rem; font-weight: 500; margin: 0 0 .5rem; color: #444; border-bottom: 2px solid #e0e0e0; padding-bottom: .25rem; }
	.participants-list { display: flex; flex-wrap: wrap; gap: .25rem; }
	.btn-primary   { background: #5046e4; color: #fff; border: none; border-radius: 8px; padding: .5rem 1rem; cursor: pointer; margin-top: .5rem; }
	.btn-secondary { background: transparent; border: 1px solid #ccc; border-radius: 8px; padding: .5rem 1rem; cursor: pointer; margin-top: .5rem; }
	.expense-form  { border: 1px solid #e0e0e0; border-radius: 12px; padding: 1.25rem; margin-bottom: 1rem; }
	.expense-form h3 { margin: 0 0 1rem; font-size: 1rem; }
	.input  { display: block; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 8px; padding: .5rem; margin: .25rem 0 .75rem; font-size: 1rem; }
	.select { display: block; width: 100%; box-sizing: border-box; border: 1px solid #ccc; border-radius: 8px; padding: .5rem; margin: .25rem 0 .75rem; font-size: 1rem; background: #fff; }
	.form-actions { display: flex; gap: .5rem; }
	.error-banner { background: #fee; border: 1px solid #f99; border-radius: 8px; padding: .75rem; margin-bottom: 1rem; color: #900; }
	.empty { color: #999; font-size: .9rem; padding: .5rem 0; }
	'
]

{ #category : 'web resources' }
TripDetailView class >> template [
	<webResource: #html>
	^ '
	<div class="header">
		<button id="btn-back" class="btn-back" title="Retour">&#8592;</button>
		<div>
			<h1 class="trip-name" id="trip-name">…</h1>
			<div class="trip-meta" id="trip-meta"></div>
		</div>
	</div>
	<div id="error-banner" class="error-banner" style="display:none"></div>
	<div class="section">
		<div class="section-title">Participants</div>
		<div class="participants-list"><slot name="participants"></slot></div>
	</div>
	<div class="section">
		<div class="section-title">Dépenses</div>
		<slot name="expenses"></slot>
		<div id="expense-form" class="expense-form" style="display:none">
			<h3>Nouvelle dépense</h3>
			<label>Description</label>
			<input  id="expense-desc"   class="input"  type="text" placeholder="Ex : Restaurant">
			<label>Montant</label>
			<input  id="expense-amount" class="input"  type="number" min="0.01" step="0.01" placeholder="0.00">
			<label>Payé par</label>
			<select id="expense-payer"  class="select"></select>
			<div class="form-actions">
				<button id="btn-add"    class="btn-primary">Ajouter</button>
				<button id="btn-cancel" class="btn-secondary">Annuler</button>
			</div>
		</div>
		<button id="btn-show-form" class="btn-primary">+ Ajouter une dépense</button>
	</div>
	<div class="section">
		<div class="section-title">Balances</div>
		<slot name="balances"></slot>
	</div>
	<div class="section">
		<div class="section-title">Règlements</div>
		<slot name="settlements"></slot>
		<div id="empty-settlements" class="empty">Tout le monde est quitte !</div>
	</div>
	'
]

{ #category : 'event handling' }
TripDetailView >> handleAddExpense [
	| desc amount payerId |
	desc    := (self shadowedElementWithId: #'expense-desc')   propertyAt: 'value'.
	amount  := (self shadowedElementWithId: #'expense-amount') propertyAt: 'value'.
	payerId := (self shadowedElementWithId: #'expense-payer')  propertyAt: 'value'.
	self serverAnnounce: (TripDetailAddExpenseRequested
		description:  desc
		amountString: amount
		payerId:      payerId)
]

{ #category : 'event handling' }
TripDetailView >> handleBack [
	self serverAnnounce: TripDetailBackRequested
]

{ #category : 'event handling' }
TripDetailView >> handleHideForm [
	self serverAnnounce: TripDetailHideExpenseFormRequested
]

{ #category : 'event handling' }
TripDetailView >> handleShowForm [
	self serverAnnounce: TripDetailShowExpenseFormRequested
]

{ #category : 'initialization' }
TripDetailView >> initializeShadowRoot [
	super initializeShadowRoot.
	(self shadowedElementWithId: #'btn-back')
		when: CpClickEvent basicPrimary send: #handleBack       to: self.
	(self shadowedElementWithId: #'btn-show-form')
		when: CpClickEvent basicPrimary send: #handleShowForm   to: self.
	(self shadowedElementWithId: #'btn-add')
		when: CpClickEvent basicPrimary send: #handleAddExpense to: self.
	(self shadowedElementWithId: #'btn-cancel')
		when: CpClickEvent basicPrimary send: #handleHideForm   to: self
]

{ #category : 'rendering' }
TripDetailView >> renderCurrency: aCurrency [
	(self shadowedElementWithId: #'trip-name')
		setAttribute: 'data-currency' value: aCurrency
]

{ #category : 'rendering' }
TripDetailView >> renderErrorMessage: aString [
	| banner |
	banner := self shadowedElementWithId: #'error-banner'.
	aString isEmpty
		ifTrue:  [ banner style: 'display:none'. banner textContent: '' ]
		ifFalse: [ banner style: 'display:block'. banner textContent: aString ]
]

{ #category : 'rendering' }
TripDetailView >> renderParticipantOptions: aString [
	| select |
	select := self shadowedElementWithId: #'expense-payer'.
	select removeChildren.
	aString isEmpty ifTrue: [ ^ self ].
	(aString substrings: $|) do: [ :pair |
		| parts option |
		parts  := pair substrings: $:.
		option := CpHtmlElement newWithTag: 'option'.
		option setAttribute: 'value' value: parts first.
		option textContent: parts last.
		select appendChild: option ]
]

{ #category : 'rendering' }
TripDetailView >> renderShowExpenseForm: aBoolean [
	| form btn |
	form := self shadowedElementWithId: #'expense-form'.
	btn  := self shadowedElementWithId: #'btn-show-form'.
	aBoolean
		ifTrue:  [
			form style: 'display:block'. btn style: 'display:none'.
			(self shadowedElementWithId: #'expense-desc')   propertyAt: 'value' put: ''.
			(self shadowedElementWithId: #'expense-amount') propertyAt: 'value' put: '' ]
		ifFalse: [
			form style: 'display:none'. btn style: 'display:block' ]
]

{ #category : 'rendering' }
TripDetailView >> renderTotalExpenses: aTotal [
	| currency meta |
	currency := (self shadowedElementWithId: #'trip-name')
		getAttribute: 'data-currency' ifAbsent: [ '' ].
	meta := self shadowedElementWithId: #'trip-meta'.
	meta textContent: 'Total : ' , aTotal , ' ' , currency
]

{ #category : 'rendering' }
TripDetailView >> renderTripName: aName [
	(self shadowedElementWithId: #'trip-name') textContent: aName
]
