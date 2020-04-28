
var entity = {
  hunger: 0,
  money: 0,
  thirst: 0
};

var state = document.getElementById('state');
function setState(obj) {
  state.innerHTML = '<pre>' +
    JSON.stringify(obj.entity, null, 2) +
    '<br/>' +
    JSON.stringify({ currentState:obj.currentState.name }, null, 2) +
  '</pre>';
}
var log = document.getElementById('log');
function appendLog(string) {
  log.innerHTML = string + '<br/>' + log.innerHTML;
}

var eatingState = new State(entity => {
  appendLog('Im eating bois');
  entity.hunger -= 1;
  entity.money -= 1;
});
eatingState.name = 'drinking';

var drinkingState = new State(entity => {
  appendLog('A nice cool one suuuure hits the spot, woo boi.');
  entity.thirst -= 1;
  entity.money -= 1;
});

drinkingState.name = 'drinking';

var miningState = new State(() => {
  appendLog('Im mining bois');
  entity.hunger += 1;
  entity.thirst += Math.random() * 2;
  entity.money += 0.5 + Math.random()*5;
});
miningState.name = 'mining';

// Done eating, hunger sated.
eatingState.transitions.push(entity => {
  if(entity.hunger <= 1) {
    appendLog('REAL FULL bois, gonna go mine.');
    return miningState;
  }
  return null;
});

// Done eating, can't buy more food.
eatingState.transitions.push(ent => {
  if(entity.money < 1) {
    appendLog('Too broke to eat, back to the mines');
    return miningState;
  }

  return null;
});

// after drink sated, go eat.
drinkingState.transitions.push(entity => {
  const { thirst, hunger, money } = entity;
  if(thirst < 1 && hunger > 3 && money > 1) {
    appendLog('After that drink, I sure feel like some grub.');
    return eatingState;
  }

  return null;
});

// too broke to drink, go mine.
drinkingState.transitions.push(entity => {
  if(entity.money < 1) {
    appendLog('Spent my last dollar on a drink, back to the mines');
    return miningState;
  }

  return null;
});


// Hunger too high, go eat.
miningState.transitions.push(entity => {
  if(entity.hunger >= 4) {
    appendLog('Real hungry, gonna go eat.');
    if(entity.money <= 0) {
      appendLog('Well, nevermind that, Im broke');
      return null;
    }
    return eatingState;
  }

  return null;
});

// Thirst too high, go eat.
miningState.transitions.push(entity => {
  if(entity.thirst >= 2) {
    appendLog('Oh boi, mining is sweaty work. Time for a drink!');
    if(entity.money <= 0) {
      appendLog('Well, nevermind that, Im broke');
      return null;
    }
    return drinkingState;
  }

  return null;
});


var fsm = new FSM(entity, miningState);
setState(fsm);

console.log(fsm);

setInterval(() => {
  fsm.run();
  setState(fsm);
}, 1000);
