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

{ #category : #tests }
Scheduler class >> factorial: aNumber [
	"Calcula el factorial d'un nombre"
	"Scheduler factorial: 5"
	| fact factThunk |
	fact := Array new: aNumber.
	factThunk := [ :n |
		[  n <= 1
			ifTrue: [ (n asString, '! = 1') traceCr.
						 fact at: 1 put: 1.
				       Scheduler quit. ]
			ifFalse: [ Scheduler spawn: (factThunk value: n - 1).
						  [ (fact at: (n-1)) isNil ] whileTrue: [ Scheduler relinquish ].
						  fact at: n put: (fact at: (n-1)) * n.
						  (n asString, '! = ', (fact at: n) asString) traceCr.
						  Scheduler quit. ]
		] ].
	Scheduler initialize.
	Scheduler spawn: (factThunk value: aNumber).
	Scheduler startThreads.
]

{ #category : #initialization }
Scheduler class >> initialize [
	super initialize.
	self threadQueue: Queue new
]

{ #category : #tests }
Scheduler class >> map: aBlock to: aCollection [
	"Implementacio de map"
	"Scheduler example4: [ :x | x*2 ] to: #(1 2 3)"
	| size result mapThunk |
	size := aCollection size.
	result := Array new: size.
	mapThunk := [ :pos |
		[ size < pos
			ifFalse: [ 
				| valAtPos |
				valAtPos := aCollection at: pos.
				result at: pos put: (aBlock value: valAtPos).
				(pos asString, '=', (result at: pos) asString) traceCr.
				Scheduler spawn: (mapThunk value: pos + 1).
				Scheduler quit.
			]
		] ].

	Scheduler initialize.
	Scheduler spawn: (mapThunk value: 1).
	Scheduler startThreads.
	^ result
]

{ #category : #threadManagement }
Scheduler class >> quit [
	"Stops the currently executing thread and pops it from the queue"
	self threadQueue isNotEmpty ifTrue: [ self threadQueue removeFirst value ]
	ifFalse: [ self stop value ]
]

{ #category : #threadManagement }
Scheduler class >> relinquish [
	"Yields control to another thread"
	| cc |
	cc := Continuation current.
	(cc isNotNil and: [ self threadQueue notEmpty ])
		ifTrue: [ self threadQueue addLast: cc.
					 self threadQueue removeFirst value ]
]

{ #category : #tests }
Scheduler class >> reverse: aCollection [
	"Mostra al transcript una col·leccio invertida"
	"Scheduler reverse: 'banana'"
	| reverseThunk |
	reverseThunk := [ :s | [ 
			s == 0
				ifFalse: [ 
					((aCollection at: s) asString) trace.
					Scheduler spawn: (reverseThunk value: s - 1).
					Scheduler quit
					]
			] ].
	
	Scheduler initialize.
	Scheduler spawn: (reverseThunk value: (aCollection size)).
	Scheduler startThreads.
]

{ #category : #threadManagement }
Scheduler class >> spawn: aThunk [
	"Adds a thread to the queue"
	self threadQueue addLast: aThunk

]

{ #category : #threadManagement }
Scheduler class >> startThreads [
	"Starts executing the threads in the queue"
	self stop: [ ^nil ].
	self threadQueue notEmpty ifTrue: [ self threadQueue removeFirst value ]
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
