FSM - A finite state machine implementation.
===========

### Usage

### js

```js
var {FSM, State} = require("dropecho.fsm");

var entity = {
  data: 0
};

// input function is state "action", called when state is run.
var testState1 = new State(entity => {
  entity.data += 1;
  console.log("state1");
});

var testState2 = new State(entity => {
  entity.state2Ran = true;
  console.log("state2");
})

testState1.transitions.push(entity => {
  if (entity.data >= 2) {
    return testState2;
  }

  // null means don't transition
  return null;
});

st2.transitions.push(entity -> {
  if (entity.state2Ran) {
    return st1;
  }

  return null;
});

var fsm = new FSM(testState1);

fsm.run(); // state1
fsm.run(); // state1
fsm.run(); // state2
fsm.run(); // state1
fsm.run(); // state2
fsm.run(); // state1
fsm.run(); // state2

```
