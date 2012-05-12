package funk.collections.immutable;

import funk.option.Option;
import funk.collections.IList;
import funk.collections.immutable.Nil;

using funk.collections.immutable.Nil;

class NilIterator<T> {
	
	public function new() {
	}
	
	public function hasNext() : Bool {
		return false;
	}
	
	public function next() : T {
		return null;
	}
	
	public function nextOption() : Option<T> {
		return None;
	}
}

class NilIteratorType {
	
	inline public static function toArray<T>(iter : NilIterator<T>) : Array<T> {
		return [];
	}
	
	inline public static function toList<T>(iter : NilIterator<T>) : IList<T> {
		return nil.instance();
	}
}