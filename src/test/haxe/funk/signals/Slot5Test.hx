package funk.signals;

import funk.signals.Signal5;

using funk.types.Option;
using funk.types.PartialFunction5;
using massive.munit.Assert;
using unit.Asserts;

class Slot5Test {

    public var signal : Signal5<Int, Int, Int, Int, Int>;

    @Before
    public function setup() {
        signal = new Signal5<Int, Int, Int, Int, Int>();
    }

    @After
    public function tearDown() {
        signal = null;
    }

    @Test
    public function when_calling_execute__should_call_listener() : Void {
        var called = false;
        var listener = function(value0, value1, value2, value3, value4) {
            called = true;
        }.fromFunction();
        var slot = new Slot5<Int, Int, Int, Int, Int>(signal, listener, false);
        slot.execute(1, 2, 3, 4, 5);
        called.isTrue();
    }

    @Test
    public function when_calling_execute__should_leave_signal_with_one() : Void {
        var listener = function(value0, value1, value2, value3, value4) {}.fromFunction();
        var slot = signal.add(listener).get();
        slot.execute(1, 2, 3, 4, 5);
        signal.size().areEqual(1);
    }

    @Test
    public function when_calling_execute_with_once__should_leave_signal_with_zero() : Void {
        var listener = function(value0, value1, value2, value3, value4) {}.fromFunction();
        var slot = signal.addOnce(listener).get();
        slot.execute(1, 2, 3, 4, 5);
        signal.size().areEqual(0);
    }

    @Test
    public function when_calling_remove_twice__should_signal_with_zero_listeners() : Void {
        var listener = function(value0, value1, value2, value3, value4) {}.fromFunction();
        var slot = signal.add(listener).get();
        slot.remove();
        slot.remove();
        signal.size().areEqual(0);
    }

    @Test
    public function when_calling_listener__should_return_same_listener() : Void {
        var listener = function(value0, value1, value2, value3, value4) {}.fromFunction();
        var slot = new Slot5<Int, Int, Int, Int, Int>(signal, listener, false);
        slot.listener().areEqual(listener);
    }
}
