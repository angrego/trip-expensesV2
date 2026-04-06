Class {
	#name : 'TripItemView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-TripList',
	#package : 'TripExpenses-UI',
	#tag : 'TripList'
}

{ #category : 'web resources' }
TripItemView class >> style [
	<webResource: #css>
	^ '
		:host { display: block; margin-bottom: .5rem; }
		.trip-item {
			border: 1px solid #e0e0e0;
			border-radius: 12px;
			padding: 1rem;
			cursor: pointer;
			transition: background .15s;
		}
		.trip-item:hover { background: #f5f5ff; }
		.trip-name { font-weight: 500; margin-bottom: .25rem; }
		.trip-meta { font-size: .85rem; color: #666; }
	'
]

{ #category : 'web resources' }
TripItemView class >> template [
	<webResource: #html>
	^ '
		<div class="trip-item" id="item">
			<div class="trip-name" id="name"></div>
			<div class="trip-meta" id="meta"></div>
		</div>
	'
]

{ #category : 'initialization' }
TripItemView >> handleClicked [
	"Annonce simple sans données — TripItemPresenter sait quel modèle a été cliqué"
	self serverAnnounce: TripItemClicked
]

{ #category : 'initialization' }
TripItemView >> initializeShadowRoot [
	super initializeShadowRoot.
	(self shadowedElementWithId: #item)
		when: CpClickEvent basicPrimary
		send: #handleClicked
		to:   self
]

{ #category : 'initialization' }
TripItemView >> renderTripName: aName currency: aCurrency participantCount: aCount totalExpenses: aTotal [
	"Tout en String — CP peut encoder sans problème"
	(self shadowedElementWithId: #name) textContent: aName.
	(self shadowedElementWithId: #meta) textContent:
		aCurrency , ' · ' , aCount , ' participant(s) · ' , aTotal , ' ' , aCurrency
]
