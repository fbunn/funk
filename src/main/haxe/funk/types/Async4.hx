package funk.types;

import funk.Funk;
import funk.types.Deferred;
import funk.types.Function4;
import funk.types.Option;
import funk.types.Promise;

using funk.types.extensions.Options;
using funk.types.extensions.Functions4;

class Async4<T1, T2, T3, T4> {

	private var _deferred : Deferred<Tuple4<T1, T2, T3, T4>>;

	private var _promise : Promise<Tuple4<T1, T2, T3, T4>>;

	public function new(func : Function4<T1, T2, T3, T4, Void>) {
		_deferred = new Deferred();
		_promise = _deferred.promise();
		_promise.then(function(tuple) {
			func.untuple()(tuple);
		});
	}

	public function add(value : Option<Async4<T1, T2, T3, T4>>) : Async4<T1, T2, T3, T4> {
		switch(value) {
			case Some(async): 
				_promise.then(function (value) {
					async.yield.untuple()(value);
				});
			case None:
		}
		return this;
	}

	public function yield(value0 : T1, value1 : T2, value2 : T3, value3 : T4) : Void {
		_deferred.resolve(tuple4(value0, value1, value2, value3));
	}
}
