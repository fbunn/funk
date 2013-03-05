package funk.types.extensions;

import funk.types.Attempt;
import funk.types.Either;
import funk.types.Function1;
import funk.types.Predicate2;
import funk.types.Option;
import funk.types.Attempt;

using funk.types.extensions.Reflects;

// TODO (Simon) : Consider moving this to wildcard.
class Anys {

	public static function equals<T1, T2>(value0 : T1, value1 : T2, ?func : Predicate2<T1, T2>) : Bool {
		if (func == null) {
			func = function (a, b) {
				var type0 = Type.typeof(a);
				var type1 = Type.typeof(b);
				if (Type.enumEq(type0, type1)) {
					return switch(type0) {
						case TEnum(_):
							Type.enumEq(cast a, cast b);
						default:
							cast a == cast b;
					};
				}
				return false;
			};
		}
		return func(value0, value1);
	}

	public static function toBool<T>(value : Null<T>) : Bool {
		return if(value == null) {
			false;
		} else if(Std.is(value, Bool)) {
            cast value;
        } else if(Std.is(value, Float) || Std.is(value, Int)) {
          	cast(value) > 0;
        } else if(Std.is(value, String)) {
            Strings.isNonEmpty(cast value);
        } else if(Std.is(value, Option)) {
        	OptionTypes.toBool(cast value);
        } else if(Std.is(value, Attempt)) {
        	AttemptTypes.toBool(cast value);
        } else if(Std.is(value, Either)) {
        	EitherTypes.toBool(cast value);
        } else {
			true;
		}
	}

	public static function toString<T>(value : T, ?func : Function1<T, String>) : String {
		return if(toBool(func)) {
			func(value);
		} else {
			Std.string(value);
			/**
			if (value.hasMethod('toString')) {
				value.callMethod('toString');
			} else {
				Std.string(value);
			}
			*/
		}
	}
}
