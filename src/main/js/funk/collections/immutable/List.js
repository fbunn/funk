funk.collection = funk.collection || {};
funk.collection.immutable = funk.collection.immutable || {};
funk.collection.immutable.List = (function(){
    var ListImpl = function(head, tail){
        this._head = funk.option.some(head);
        this._tail = tail;
        this._length = 0;
        this._lengthKnown = false;
        this._newListCtor = funk.collection.immutable.List;
    };
    ListImpl.prototype = new funk.collection.List();
    ListImpl.prototype.constructor = ListImpl;
    ListImpl.prototype.size = function(){
        if(this._lengthKnown) {
            return this._length;
        }
        var p = this;
        var length = 0;
        while(p.nonEmpty()) {
            ++length;
            p = p.tail();
        }

        this._length = length;
        this._lengthKnown = true;
        return length;
    };
    ListImpl.prototype.hasDefinedSize = function(value){
        return true;
    };
    ListImpl.prototype.product$equals = ListImpl.prototype.equals;
    ListImpl.prototype.equals = function(value){
        if(value === funk.util.verifiedType(value)) {
            return this.product$equals(value);
        }
        return false;
    };
    ListImpl.prototype.productArity = function(){
        return this.size();
    };
    ListImpl.prototype.productElement = function(index){
        funk.util.requireRange(index, this.productArity());

        var p = this;
        while(p.nonEmpty()) {
            if(index == 0) {
                return p.head();
            }
            p = p.tail();
            index -= 1;
        }

        throw new funk.error.NoSuchElementError();
    };
    ListImpl.prototype.productPrefix = function(){
        return "List";
    };
    ListImpl.prototype.prepend = function(value){
        return new this._newListCtor(value, this);
    };
    ListImpl.prototype.prependAll = function(value){
        if(value === funk.util.verifiedType(value, funk.collection.List)) {
            var total = value.size();
            
            if(0 == total) {
                return this;
            }
            
            var buffer = [];
            var last = total - 1;
            
            var p = value,
                i = 0,
                j = 0;
            
            while(p.nonEmpty()) {
                buffer[i++] = new this._newListCtor(p.head(), null);
                p = p.tail();
            }

            buffer[last]._tail = this;

            for(i=0, j=1; i<last; ++i, ++j) {
                buffer[i]._tail = buffer[j];
            }

            return buffer[0];
        }  
    };
    ListImpl.prototype.get = function(index){
        return this.productElement(index);
    };
    ListImpl.prototype.contains = function(value){
        var p = this;
        while(p.nonEmpty()) {
            if(funk.util.eq(p.head(), value)){
                return true;
            }
            p = p.tail();
        }
        return false;
    };
    ListImpl.prototype.count = function(func){
        var n = 0;
        var p = this;
        while(p.nonEmpty()){
            if(func(p.head())){
                ++n;
            }
            p = p.tail();
        }
        return n;
    };
    ListImpl.prototype.nonEmpty = function(){
        return true;
    };
    ListImpl.prototype.drop = function(index){
        funk.util.require(index >= 0, "index must be positive.");

        var p = this;
        for(var i=0; i<index; ++i){
            if(p.isEmpty()) {
                return funk.collection.immutable.nil();
            }

            p = p.tail();
        }

        return p;
    };
    ListImpl.prototype.dropRight = function(index){
        funk.util.require(index >= 0, "index must be positive.");

        if(0 == index) {
            return this;
        }

        index = this.size() - index;
        if(index <= 0) {
            return funk.collection.immutable.nil();
        }

        var buffer = [];
        var last = index - 1;
        var p = this,
            i = 0,
            j = 0;
        for(i = 0; i<index; ++i){
            buffer[i] = new this._newListCtor(p.head(), null);
            p = p.tail();
        }

        buffer[last]._tail = funk.collection.immutable.nil();

        for(i=0, j=1; i<last; ++i, ++j){
            buffer[i]._tail = buffer[j];
        }

        return buffer[0];
    };
    ListImpl.prototype.dropWhile = function(func){
        var p = this;
        while(p.nonEmpty()){
            if(!func(p.head())) {
                return p;
            }
            p = p.tail();
        }
        return funk.collection.immutable.nil();
    };
    ListImpl.prototype.exists = function(func){
        var p = this;
        while(p.nonEmpty()){
            if(func(p.head())){
                return true;
            }
            p = p.tail();
        }
        return false;
    };
    ListImpl.prototype.filter = function(func){
        var p = this,
            q = null,
            first = null,
            last = null,
            allFiltered = true;
        while(p.nonEmpty()){
            if(func(p.head())) {
                q = new this._newListCtor(p.head(), funk.collection.immutable.nil());

                if(null !== last){
                    last._tail = q;
                }

                if(null === first){
                    first = q;
                }

                last = q;
            } else {
                allFiltered = false;
            }

            p = p.tail();
        }

        if(allFiltered) {
            return this;
        }

        return (null === first) ? funk.collection.immutable.nil() : first;
    };
    ListImpl.prototype.filterNot = function(func){
        var p = this,
            q = null,
            first = null,
            last = null,
            allFiltered = true;
        while(p.nonEmpty()){
            if(!func(p.head())) {
                q = new this._newListCtor(p.head(), funk.collection.immutable.nil());

                if(null !== last){
                    last._tail = q;
                }

                if(null === first){
                    first = q;
                }

                last = q;
            } else {
                allFiltered = false;
            }

            p = p.tail();
        }

        if(allFiltered) {
            return this;
        }

        return (null === first) ? funk.collection.immutable.nil() : first;
    };
    ListImpl.prototype.find = function(func){
        var p = this;
        while(p.nonEmpty()){
            if(func(p.head())){
                return p.head();
            }

            p = p.tail();
        }

        return funk.option.none();
    };
    ListImpl.prototype.flatMap = function(func){
        var index = this.size(),
            buffer = [],
            p = this,
            i = 0;
        while(p.nonEmpty()){
            buffer[i++] = verifiedType(func(p.head()), funk.collection.List);
            p = p.tail();
        }

        var list = buffer[--index];
        while(--index > -1) {
            list = list.prependAll(buffer[index]);
        }
        return list;
    };
    ListImpl.prototype.foldLeft = function(x, func){
        var value = x,
            p = this;
        while(p.nonEmpty()){
            value = func(value, p.head());
            p = p.tail();
        }
        return value;
    };
    ListImpl.prototype.foldRight = function(x, func){
        var value = x,
            buffer = this.toArray(),
            index = buffer.length;
        while(--index > -1){
            value = func(value, buffer[index]);
        }
        return value;
    };
    ListImpl.prototype.forall = function(func){
        var p = this;
        while(p.nonEmpty()){
            if(!func(p.head())){
                return false;
            }
            p = p.tail();
        }
        return true;
    };
    ListImpl.prototype.foreach = function(func){
        var p = this;
        while(p.nonEmpty()){
            func(p.head());
            p = p.tail();
        }
    };
    ListImpl.prototype.head = function(){
        return this._head;
    };
    ListImpl.prototype.indices = function(){
        var index = this.size(),
            p = funk.collection.immutable.nil();
        while(--index > -1){
            p = p.prepend(index);
        }
        return p;
    };
    ListImpl.prototype.init = function(){
        return this.dropRight(1);
    };
    ListImpl.prototype.isEmpty = function(){
        return false;
    };
    ListImpl.prototype.last = function(){
        var p = this,
            value = funk.option.none();
        while(p.nonEmpty()){
            value = p.head();
            p = p.tail();
        }
        return value;
    };
    ListImpl.prototype.map = function(func){
        var total = this.size(),
            buffer = [],
            last = total - 1;

        var p = this,
            i = 0,
            j = 0;

        for(i = 0; i < total; ++i) {
            buffer[i] = new this._newListCtor(func(p.head()), null);
            p = p.tail();
        }

        buffer[last]._tail = funk.collection.immutable.nil();

        for(i=0, j=1; i<last; ++i, ++j){
            buffer[i]._tail = buffer[j];
        }

        return buffer[0];
    };
    ListImpl.prototype.name = "List";
    return ListImpl;
})();