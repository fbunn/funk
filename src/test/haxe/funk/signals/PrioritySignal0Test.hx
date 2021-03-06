package funk.signals;

import funk.signals.PrioritySignal0;

using funk.types.Option;
using funk.types.PartialFunction0;
using massive.munit.Assert;
using unit.Asserts;

class PrioritySignal0Test extends Signal0Test {

    private var prioritySignal : PrioritySignal0;

    @Before
    override public function setup() {
        super.setup();

        var s = new PrioritySignal0();
        signal = s;
        prioritySignal = s;

        signalName = 'PrioritySignal0';
    }

    @After
    override public function tearDown() {
        super.tearDown();

        prioritySignal = null;
    }

    @Test
    public function when_adding_two_items_with_larger_priority__should_dispatch_in_order() : Void {
        var called0 = false;
        var called1 = false;

        prioritySignal.addWithPriority(function(){
            called0 = true;
        }.fromFunction(), 1);
        prioritySignal.addWithPriority(function(){
            if(called0) {
                called1 = true;
            }
        }.fromFunction(), 2);
        prioritySignal.dispatch();

        called1.isTrue();
    }

    @Test
    public function when_adding_three_items_with_larger_priority__should_dispatch_in_order() : Void {
        var called0 = false;
        var called1 = false;
        var called2 = false;

        prioritySignal.addWithPriority(function(){
            called0 = true;
        }.fromFunction(), 1);
        prioritySignal.addWithPriority(function(){
            if(called0) {
                called1 = true;
            }
        }.fromFunction(), 2);
        prioritySignal.addWithPriority(function(){
            if(called1) {
                called2 = true;
            }
        }.fromFunction(), 3);
        prioritySignal.dispatch();

        called2.isTrue();
    }

    @Test
    public function when_adding_two_items_with_smaller_priority__should_dispatch_in_order() : Void {
        var called0 = false;
        var called1 = false;

        prioritySignal.addWithPriority(function(){
            if(called0) {
                called1 = true;
            }
        }.fromFunction(), 2);
        prioritySignal.addWithPriority(function(){
            called0 = true;
        }.fromFunction(), 1);
        prioritySignal.dispatch();

        called1.isTrue();
    }

    @Test
    public function when_adding_three_items_with_smaller_priority__should_dispatch_in_order() : Void {
        var called0 = false;
        var called1 = false;
        var called2 = false;

        prioritySignal.addWithPriority(function(){
            if(called1) {
                called2 = true;
            }
        }.fromFunction(), 3);
        prioritySignal.addWithPriority(function(){
            if(called0) {
                called1 = true;
            }
        }.fromFunction(), 2);
        prioritySignal.addWithPriority(function(){
            called0 = true;
        }.fromFunction(), 1);
        prioritySignal.dispatch();

        called2.isTrue();
    }

    @Test
    public function when_adding_three_items_with_mixed_priority__should_dispatch_in_order() : Void {
        var called0 = false;
        var called1 = false;
        var called2 = false;

        prioritySignal.addWithPriority(function(){
            if(called0) {
                called1 = true;
            }
        }.fromFunction(), 2);
        prioritySignal.addWithPriority(function(){
            if(called1) {
                called2 = true;
            }
        }.fromFunction(), 3);
        prioritySignal.addWithPriority(function(){
            called0 = true;
        }.fromFunction(), 1);
        prioritySignal.dispatch();

        called2.isTrue();
    }

    @Test
    public function when_adding_with_priority__should_size_be_1() : Void {
        prioritySignal.addWithPriority(function(){}.fromFunction());
        prioritySignal.size().areEqual(1);
    }

    @Test
    public function when_adding_with_priority_after_dispatch__should_size_be_1() : Void {
        prioritySignal.addWithPriority(function(){}.fromFunction());
        prioritySignal.dispatch();
        prioritySignal.size().areEqual(1);
    }

    @Test
    public function when_adding_once_with_priority__should_size_be_1() : Void {
        prioritySignal.addOnceWithPriority(function(){}.fromFunction());
        prioritySignal.size().areEqual(1);
    }

    @Test
    public function when_adding_once_with_priority_after_dispatch__should_size_be_1() : Void {
        prioritySignal.addOnceWithPriority(function(){}.fromFunction());
        prioritySignal.dispatch();
        prioritySignal.size().areEqual(0);
    }

    @Test
    public function when_adding_adding_same_function_twice__should_return_same_slot() : Void {
        var func = function(){}.fromFunction();

        var slot = prioritySignal.addWithPriority(func);
        prioritySignal.addWithPriority(func).get().areEqual(slot.get());
    }
}
