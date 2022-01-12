"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.
   
For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #Scheduler,
	#superclass : #Object,
	#classInstVars : [
		'threadQueue',
		'stop'
	],
	#category : #Practica
}

{ #category : #tests }
Scheduler class >> example1 [
	"Scheduler example1"
	| makeThreadThunk counter |
	counter := 10.
	makeThreadThunk := [ :nom |
		| loop |
		loop := [ counter < 0
						ifTrue: [ Scheduler quit ].
					('In thread ' , nom , ' - counter = ' , counter asString) traceCr.
					counter := counter - 1.
					Scheduler relinquish.
					loop value. ].
		loop ]. "Retorna el bloc sense paràmetres que hem anomenat loop"
				  "Aquest serà el codi que s'executarà en cada fil"
	Scheduler initialize.
	Scheduler spawn: (makeThreadThunk value: 'a').
	Scheduler spawn: (makeThreadThunk value: 'b').
	Scheduler spawn: (makeThreadThunk value: 'c').
	Scheduler startThreads.

]

{ #category : #initialization }
Scheduler class >> initialize [
	super initialize.
	self threadQueue: Queue new.
]

{ #category : #threadManagement }
Scheduler class >> quit [
	"Stops the currently executing thread and pops it from the queue"
	"self threadQueue addLast: stop."
	self halt.
	self threadQueue isNotEmpty ifTrue: [ self threadQueue removeFirst value ]
	ifFalse: [ self stop value ]
]

{ #category : #threadManagement }
Scheduler class >> relinquish [
	"Yields control to another thread"
	| cc |
	cc := Continuation current.
	cc isNotNil
		ifTrue: [ self threadQueue addLast: cc.
					 self threadQueue removeFirst value ].
]

{ #category : #threadManagement }
Scheduler class >> spawn: aThunk [
	"Adds a thread to the queue"
	| cc |
	cc := Continuation current.
	self stop: [ ^nil ].
	cc isNotNil 
		ifTrue: [ self threadQueue addLast: cc ]
		ifFalse: [ aThunk value. ]

]

{ #category : #threadManagement }
Scheduler class >> startThreads [
	"Starts executing the threads in the queue"
	self stop: [ ^nil ].
	self threadQueue removeFirst value.
]

{ #category : #accessing }
Scheduler class >> stop [
	^ stop
]

{ #category : #accessing }
Scheduler class >> stop: aBlock [
	stop := aBlock
]

{ #category : #accessing }
Scheduler class >> threadQueue [
	^ threadQueue 
]

{ #category : #accessing }
Scheduler class >> threadQueue: aQueue [
	threadQueue := aQueue
]
