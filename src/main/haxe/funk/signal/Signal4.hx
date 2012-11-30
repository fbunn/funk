package funk.signal;

import funk.Funk;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.types.Function4;
import funk.types.Option;
import funk.types.extensions.Options;
import funk.signal.Signal;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Options;

interface ISignal4<T1, T2, T3, T4> implements ISignal {

	function add(func : Function4<T1, T2, T3, T4, Void>) : Option<Slot4<T1, T2, T3, T4>>;

	function addOnce(func : Function4<T1, T2, T3, T4, Void>) : Option<Slot4<T1, T2, T3, T4>>;

	function remove(func : Function4<T1, T2, T3, T4, Void>) : Option<Slot4<T1, T2, T3, T4>>;

	function dispatch(value0 : T1, value1 : T2, value2 : T3, value3 : T4) : Void;
}

class Signal4<T1, T2, T3, T4> extends Signal, implements ISignal4<T1, T2, T3, T4> {

	private var _list : List<Slot4<T1, T2, T3, T4>>;

	public function new() {
		super();

		_list = Nil;
	}

	public function add(func : Function4<T1, T2, T3, T4, Void>) : Option<Slot4<T1, T2, T3, T4>> {
		return registerListener(func, false);
	}

	public function addOnce(	func : Function4<T1, T2, T3, T4, Void>
								) : Option<Slot4<T1, T2, T3, T4>> {

		return registerListener(func, true);
	}

	public function remove(	func : Function4<T1, T2, T3, T4, Void>
							) : Option<Slot4<T1, T2, T3, T4>> {

		var o = _list.find(function(s : Slot4<T1, T2, T3, T4>) : Bool {
			return listenerEquals(s.listener, func);
		});

		_list = _list.filterNot(function(s : Slot4<T1, T2, T3, T4>) : Bool {
			return listenerEquals(s.listener, func);
		});

		return o;
	}

	override public function removeAll() : Void {
		_list = Nil;
	}

	public function dispatch(value0 : T1, value1 : T2, value2 : T3, value3 : T4) : Void {
		var slots = _list;
		while(slots.nonEmpty()) {
        	slots.head().execute(value0, value1, value2, value3);
        	slots = slots.tail();
      	}
	}

	private function listenerEquals(	func0 : Function4<T1, T2, T3, T4, Void>,
										func1 : Function4<T1, T2, T3, T4, Void>) : Bool {
		return if(func0 == func1) {
			true;
		}
		#if js
		else if(	Reflect.hasField(func0, 'scope') &&
					Reflect.hasField(func1, 'scope') &&
					Reflect.field(func0, 'scope') == Reflect.field(func1, 'scope') &&
					Reflect.field(func0, 'method') == Reflect.field(func1, 'scope')) {
			true;
		}
		#end
		else {
			false;
		}
	}

	private function registerListener(	func : Function4<T1, T2, T3, T4, Void>,
										once : Bool) : Option<Slot4<T1, T2, T3, T4>> {

		if(registrationPossible(func, once)) {
			var slot : Slot4<T1, T2, T3, T4> = new Slot4<T1, T2, T3, T4>(this, func, once);
			_list = _list.prepend(slot);
			return Some(slot);
		}

		return _list.find(function(s : Slot4<T1, T2, T3, T4>) : Bool {
			return listenerEquals(s.listener, func);
		});
	}

	private function registrationPossible(	func : Function4<T1, T2, T3, T4, Void>,
											once : Bool) : Bool {
		if(!_list.nonEmpty()) {
			return true;
		}

		var slot = _list.find(function(s : Slot4<T1, T2, T3, T4>) : Bool {
			return listenerEquals(s.listener, func);
		});

		return switch(slot) {
			case None: true;
			case Some(x):
				if(x.once != once) {
					Funk.error(Errors.IllegalOperationError('You cannot addOnce() then add() the same " +
					 "listener without removing the relationship first.'));
				}
				false;
		}
	}

	override private function get_size() : Int {
		return _list.size();
	}
}

class Slot4<T1, T2, T3, T4> extends Slot {

	public var listener(dynamic, never) : Function4<T1, T2, T3, T4, Void>;

	private var _listener : Function4<T1, T2, T3, T4, Void>;

	private var _signal : ISignal4<T1, T2, T3, T4>;

	public function new(	signal : ISignal4<T1, T2, T3, T4>,
							listener : Function4<T1, T2, T3, T4, Void>,
							once : Bool) {
		super();

		_signal = signal;
		_listener = listener;

		this.once = once;
	}

	public function execute(value0 : T1, value1 : T2, value2 : T3, value3 : T4) : Void {
		if(!enabled) {
			return;
		}
		if(once) {
			remove();
		}

		listener(value0, value1, value2, value3);
	}

	override public function remove() : Void {
		_signal.remove(listener);
	}

	public function get_listener() : Function4<T1, T2, T3, T4, Void> {
		return _listener;
	}
}
