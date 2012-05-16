package funk.signal;

import funk.signal.Slot;
import funk.signal.Signal0;

interface ISlot0 implements ISlot {
	
	var listener(default, default) : (Void -> Void);
	
	function execute() : Void;
}

class Slot0 extends Slot, implements ISlot0 {
	
	public var listener(default, default) : (Void -> Void);
	
	private var _signal : ISignal0;
	
	public function new(signal : ISignal0, listener : (Void -> Void), once : Bool) {
		super();
		
		_signal = signal;
		
		this.listener = listener;
		this.once = once;
	}
	
	public function execute() : Void {
		listener();
	}
}