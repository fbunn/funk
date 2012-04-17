funk.signals = funk.signals || {};
funk.signals.Signal = (function(){
    var findSlot = function(slots, listener){
        return slots.find(function(item){
            return funk.option.when(item, {
                none: function(){
                    return false;
                },
                some: function(slot){
                    return  funk.util.eq(slot.listener(), listener);
                }
            });
        });
    };
    var registerListener = function(signal, listener, scope, once){
        once = funk.isDefined(once) ? once : false;

        if(registrationPossible(signal, listener, scope, once)) {
            var slot = funk.signals.Slot(signal, listener, scope, once);
            signal._slots = signal._slots.prepend(slot);
            return slot;
        }

        return findSlot(signal._slots, listener);
    };
    var registrationPossible = function(signal, listener, scope, once) {
        if(!signal._slots.nonEmpty()) {
            return true;
        } else {
            var slot = findSlot(this._slots, listener);
            if(!slot) {
                return true;
            }
            if(slot.once() != once){
                throw new funk.error.IllegalByDefinitionError();
            }
            return false;
        }
    };

    var SignalImpl = function(){
        this._slots = funk.collection.immutable.nil();
        this._valueClasses = funk.toArray(arguments);
    };
    SignalImpl.prototype = {};
    SignalImpl.prototype.constructor = SignalImpl;
    SignalImpl.prototype.name = "Signal";
    SignalImpl.prototype.add = function(listener){
        registerListener(this, listener);
    };
    SignalImpl.prototype.addOnce = function(listener){
        registerListener(this, listener, true);
    };
    SignalImpl.prototype.remove = function(listener){
        var slot = findSlot(this._slots, listener);

        if(funk.isDefined(slot)){
            this._slots = this._slots.filterNot(slot);
            return funk.option.some(slot);
        }

        return funk.option.none();
    };
    SignalImpl.prototype.removeAll = function(){
        this._slots = funk.collection.immutable.nil();
    };
    SignalImpl.prototype.dispatch = function(){
        var valueObjects = funk.toArray(arguments);

        var numValueClasses = this._valueClasses.length;
        var numValueObjects = valueObjects.length;
        if(numValueObjects < numValueClasses) {
            throw new funk.error.ArgumentError('Incorrect number of arguments. ' +
                'Expected at least ' + numValueClasses + ' but received ' +
                numValueObjects + '.');
        }

        for(var i=0; i<numValueClasses; ++i){
            if(valueObjects === null || funk.util.verifiedType(valueObjects[i], this._valueClasses[i])) {
                continue;
            }

            throw new funk.error.ArgumentError('Value object <' + valueObjects[i]
                + '> is not an instance of <' + this._valueClasses[i] + '>.');
        }

        var p = this._slots;
        if(p.nonEmpty()) {
            while(p.nonEmpty()) {
                when(p.head(), {
                    some: function(value){
                        value.execute(valueObjects);
                    }
                });
                p = p.tail();
            }
        }
    };
    SignalImpl.prototype.size = function(){
        return this._slots.size();
    };
    return SignalImpl;
})();