package fsm;

import massive.munit.Assert;
import dropecho.ai.fsm.State;

class StateTestObject {
	public var Data:Int;

	public function new(?data:Int = 0) {
		Data = data;
	}
}

class StateTest {
	private var state:State<StateTestObject>;
	private var entity:StateTestObject;

	@Before
	public function setup() {
		entity = new StateTestObject();

		var action = function(s:StateTestObject) {
			s.Data++;
		};

		var transition = function(s:StateTestObject) {
			return s.Data > 1 ? new State(action) : null;
		};

		state = new State(action, [transition]);
	}

	@Test
	public function test_can_create_state() {
		Assert.isTrue(state != null);
	}

	@Test
	public function test_execute_should_call_action() {
		state.execute(entity);

		Assert.areEqual(1, entity.Data);
	}

	@Test
	public function test_execute_should_return_this_on_failed_transition() {
		var switchState = state.execute(entity);

		Assert.areEqual(state, switchState);
	}

	@Test
	public function test_execute_should_return_new_state_on_transition() {
		state.execute(entity);
		var switchState = state.execute(entity);

		Assert.isTrue(switchState != null && switchState != state);
	}
}
