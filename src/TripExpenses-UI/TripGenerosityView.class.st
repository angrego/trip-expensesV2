Class {
	#name : 'TripGenerosityView',
	#superclass : 'CpView',
	#category : 'TripExpenses-UI-Balance',
	#package : 'TripExpenses-UI',
	#tag : 'Balance'
}

{ #category : 'web resources' }
TripGenerosityView class >> style [
    <webResource: #css>
    ^ '
    :host { display: block; }
    .section-title {
        font-size: 1rem;
        font-weight: 500;
        color: #444;
        border-bottom: 2px solid #e0e0e0;
        padding-bottom: .25rem;
        margin-bottom: .5rem;
    }
    '
]

{ #category : 'web resources' }
TripGenerosityView class >> template [
    <webResource: #html>
    ^ '
    <div class="section-title">🏆 Générosité</div>
    <slot name="items"></slot>
    '
]
