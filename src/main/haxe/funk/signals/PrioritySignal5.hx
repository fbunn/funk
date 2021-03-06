package funk.signals;

import funk.Funk;

using funk.signals.Signal5;
using funk.types.Function5;
using funk.types.PartialFunction5;
using funk.types.Option;
using funk.ds.immutable.List;

class PrioritySignal5<T1, T2, T3, T4, T5> extends Signal5<T1, T2, T3, T4, T5> {

    public function new() {
        super();
    }

    public function addWithPriority(    func : PartialFunction5<T1, T2, T3, T4, T5, Void>,
                                        ?priority : Int = 0) : Option<Slot5<T1, T2, T3, T4, T5>> {
        return registerListenerWithPriority(func, false, priority);
    }

    public function addOnceWithPriority(    func : PartialFunction5<T1, T2, T3, T4, T5, Void>,
                                            ?priority:Int = 0
                                            ) : Option<Slot5<T1, T2, T3, T4, T5>> {
        return registerListenerWithPriority(func, true, priority);
    }

    private function registerListenerWithPriority(    func : PartialFunction5<T1, T2, T3, T4, T5, Void>,
                                                    once : Bool,
                                                    priority : Int
                                                    ) : Option<Slot5<T1, T2, T3, T4, T5>> {
        if(registrationPossible(func, once)) {
            var added : Bool = false;
            var slot : Slot5<T1, T2, T3, T4, T5> = new PrioritySlot5<T1, T2, T3, T4, T5>(    this,
                                                                            func,
                                                                            once,
                                                                            priority);

            _list = _list.flatMap(function(value : Slot5<T1, T2, T3, T4, T5>) {
                var prioritySlot : PrioritySlot5<T1, T2, T3, T4, T5> = cast value;

                var list = Nil.prepend(value);
                return if(priority >= prioritySlot.priority()) {
                    added = true;
                    list.append(slot);
                } else list;
            });

            if(!added) _list = _list.prepend(slot);

            return Some(slot);
        }

        return _list.find(function(s : Slot5<T1, T2, T3, T4, T5>) : Bool return s.listener() == func);
    }
}

class PrioritySlot5<T1, T2, T3, T4, T5> extends Slot5<T1, T2, T3, T4, T5> {

    private var _priority : Int;

    public function new(    signal : Signal5<T1, T2, T3, T4, T5>,
                            listener : PartialFunction5<T1, T2, T3, T4, T5, Void>,
                            once : Bool,
                            priority : Int) {
        super(signal, listener, once);

        _priority = priority;
    }

    public function priority() : Int return _priority;
}
