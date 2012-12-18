package funk.types.extensions;

import funk.Funk;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Option;
import funk.types.extensions.Options;

using funk.types.extensions.Options;

class Functions0 {

	public static function _0<T1>(func : Function0<T1>) : Function0<T1> {
		return function() {
			return func();
		};
	}

	public static function map<T1, R>(func : Function0<T1>, mapper : Function1<T1, R>) : Function0<R> {
		return function() {
			return mapper(func());
		};
	}

	public static function flatMap<T1, R>(func : Function0<T1>, mapper : Function1<T1, Function0<R>>) : Function0<R> {
		return function() {
			return mapper(func())();
		};
	}

	public static function promote<T1, R>(func : Function0<R>) : Function1<T1, R> {
		return function(x) {
			return func();
		};
	}

	public static function lazy<R>(func : Function0<R>) : Function0<R> {
		var value : Option<R> = None;

		return function() {	
			return switch(value) {
				case Some(value): value;
				case None:
					value = Some(func());
					value.get();
			};
		};
	}
}
