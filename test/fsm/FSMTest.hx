package fsm;

import dropecho.fsm.*;
import massive.munit.Assert;

typedef Blackboard = Map<String, Dynamic>;
class GlobalTestState extends State<Blackboard> {}

class TestState1 extends State<Blackboard> {
	public function new() {
		super(function(ent:Blackboard) {
			if (!ent.exists("data")) {
				ent.set("data", 0);
			}
			ent.set("data", ent.get("data") + 1);
		});
	}
}

class TestState2 extends State<Blackboard> {
	public function new() {
		super(function(ent:Blackboard) {
			ent.set("state_2_ran", 1);
		});
	}
}

class FSMTest {
	private var bb:Blackboard;
	private var st1:TestState1;
	private var fsm:FSM<Blackboard>;

	@Before
	public function setup() {
		bb = new Blackboard();
		st1 = new TestState1();
		this.fsm = new FSM(bb, st1);
	}

	@Test
	public function starting_state_runs() {
		fsm.run();
		Assert.areEqual(1, bb.get("data"));

		fsm.run();
		Assert.areEqual(2, bb.get("data"));
	}

	@Test
	public function starting_state_transitions() {
		var st2 = new TestState2();

		st1.transitions.push(bb -> {
			if (bb.get("data") >= 2) {
				return st2;
			}

			return null;
		});

		st2.transitions.push(bb -> {
			if (bb.get("state_2_ran") > 0) {
				return st1;
			}

			return null;
		});

		// in state 1
		fsm.run();
		Assert.areEqual(1, bb.get("data"));

		// in state 1
		fsm.run();
		Assert.areEqual(2, bb.get("data"));

		// transitioned to state 2, set ran = 1
		fsm.run();
		Assert.areEqual(1, bb.get("state_2_ran"));
		Assert.areEqual(2, bb.get("data"));

		// back to st1, increment data
		fsm.run();
		Assert.areEqual(1, bb.get("state_2_ran"));
		Assert.areEqual(3, bb.get("data"));

		// back to st2, set ran = 1
		fsm.run();
		Assert.areEqual(1, bb.get("state_2_ran"));
		Assert.areEqual(3, bb.get("data"));

		// back to st1, increment data
		fsm.run();
		Assert.areEqual(1, bb.get("state_2_ran"));
		Assert.areEqual(4, bb.get("data"));
	}
}
