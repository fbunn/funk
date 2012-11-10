package funk.signal;

import funk.errors.IllegalOperationError;
import funk.errors.RangeError;
import funk.option.Option;
import funk.signal.Signal0;

import massive.munit.Assert;
import util.AssertExtensions;

using massive.munit.Assert;
using util.AssertExtensions;

class Slot0Test {

	public var signal : Signal0;

	@Before
	public function setup() {
		signal = new Signal0();
	}

	@After
	public function tearDown() {
		signal = null;
	}

	@Test
	public function when_calling_execute__should_call_listener() : Void {
		var called = false;
		var listener = function() {
			called = true;
		};
		var slot = new Slot0(signal, listener, false);
		slot.execute();
		called.isTrue();
	}

	@Test
	public function when_calling_execute_when_disabled__should_not_call_listener() : Void {
		var called = false;
		var listener = function() {
			called = true;
		};
		var slot = new Slot0(signal, listener, false);
		slot.enabled = false;
		slot.execute();
		called.isFalse();
	}

	@Test
	public function when_calling_execute__should_leave_signal_with_one() : Void {
		var listener = function() {};
		var slot = signal.add(listener).get();
		slot.execute();
		signal.size.areEqual(1);
	}

	@Test
	public function when_calling_execute_with_once__should_leave_signal_with_zero() : Void {
		var listener = function() {};
		var slot = signal.addOnce(listener).get();
		slot.execute();
		signal.size.areEqual(0);
	}

	@Test
	public function when_calling_remove_twice__should_signal_with_zero_listeners() : Void {
		var listener = function() {};
		var slot = signal.add(listener).get();
		slot.remove();
		slot.remove();
		signal.size.areEqual(0);
	}

	@Test
	public function when_calling_listener__should_return_same_listener() : Void {
		var listener = function() {};
		var slot = new Slot0(signal, listener, false);
		slot.listener.areEqual(listener);
	}

	@Test
	public function when_calling_productElement__should_return_same_listener() : Void {
		var listener = function() {};
		var slot = new Slot0(signal, listener, false);
		slot.productElement(0).areEqual(listener);
	}

	@Test
	public function when_calling_productElement_with_index_as_1__should_throw_Error() : Void {
		var listener = function() {};
		var slot = new Slot0(signal, listener, false);
		var called = try {
			slot.productElement(1);
			false;
		} catch (error : RangeError) {
			true;
		}
		called.isTrue();
	}

	@Test
	public function when_calling_productArity__should_be_1() : Void {
		var listener = function() {};
		var slot = new Slot0(signal, listener, false);
		slot.productArity.areEqual(1);
	}
}