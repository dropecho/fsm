import massive.munit.TestSuite;

import fsm.FSMTest;
import fsm.StateTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */
class TestSuite extends massive.munit.TestSuite
{
	public function new()
	{
		super();

		add(fsm.FSMTest);
		add(fsm.StateTest);
	}
}
