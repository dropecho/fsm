package dropecho.ai.fsm;

@:expose("fsm.FSM")
class FSM<T> {
	public var globalState:State<T>;
	public var currentState:State<T>;
	public var previousState:State<T>;
	public var entity:T;

	public function new(entity:T, startingState:State<T>, ?globalState:State<T> = null) {
		this.entity = entity;
		this.currentState = startingState;
		this.globalState = globalState;
	}

	public function run() {
		if (globalState != null) {
			currentState = checkBlip();
		}

		if (currentState != null) {
			currentState = currentState.execute(entity);
		}
	}

	private function checkBlip():State<T> {
		var blip = globalState.execute(entity);

		if (blip == null && previousState != null) {
			return previousState;
		}

		if (blip != null && blip != globalState) {
			previousState = currentState;
			return blip;
		}

		return currentState;
	}
}
