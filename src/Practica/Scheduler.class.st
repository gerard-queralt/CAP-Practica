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
		'thunkQueue',
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

{ #category : #tests }
Scheduler class >> example2: aNumber [
	| tag fibs makeFibThunk |
	('fibonacci(' , aNumber asString , ')') traceCr.
	tag := '[NFIB]'.
	fibs := Array new: (aNumber+1).
	
	makeFibThunk := [ :n |
		[ n <= 1
			ifTrue: [ (tag , 'Base case: ') traceCr.
						 ' fib(0) = 0' traceCr.
						 ' fib(1) = 1' traceCr.
						 fibs at: 1 put: 0.
						 fibs at: 2 put: 1.
						 Scheduler quit ]
			ifFalse: [ (tag , 'spawn Fibonacci(' , (n - 1) asString , ') thunk') traceCr.
						  Scheduler spawn: (makeFibThunk value: (n-1)).
						  [((fibs at: n) isNil) or: [ (fibs at: n-1) isNil ]] whileTrue:
																						[ Scheduler relinquish ].
						  fibs at: (n+1) put: ((fibs at: n) + (fibs at: n-1)).
						  (tag , 'n = ' , n asString , ' | fib(' , n asString , ') = ' ,
																			(fibs at: n+1) asString ) traceCr.
						  Scheduler quit.
						]
			] ]. "'makeFibThunk value: N' retorna el bloc sense paràmetres [ n <= 1 ... ]"

	Scheduler initialize.
	Scheduler spawn: (makeFibThunk value: aNumber).
	Scheduler startThreads.

]

{ #category : #initialization }
Scheduler class >> initialize [
	super initialize.
	self threadQueue: Queue new.
	self thunkQueue: Queue new.
]

{ #category : #threadManagement }
Scheduler class >> quit [
	"Stops the currently executing thread and pops it from the queue"
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
	"self thunkQueue addLast: aThunk"

]

{ #category : #threadManagement }
Scheduler class >> startThreads [
	"Starts executing the threads in the queue"
	self stop: [ ^nil ].
	"[ self thunkQueue isNotEmpty ] whileTrue: [ 
		| cc thunk |
		thunk := self thunkQueue removeFirst.
		cc := Continuation current.
		cc isNotNil 
			ifTrue: [ self threadQueue addLast: cc ]
			ifFalse: [ thunk value. ]	
	]."
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

{ #category : #accessing }
Scheduler class >> thunkQueue [
	"La thunkQueue probablement no es necessaria"
	^ thunkQueue 
]

{ #category : #accessing }
Scheduler class >> thunkQueue: aQueue [
	"La thunkQueue probablement no es necessaria"
	thunkQueue := aQueue
]
