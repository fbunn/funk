package funk.actors;

class ActorCell {

    private var _actor : Actor;

    private var _mailbox : Mailbox;

    private var _dispatcher : MessageDispatcher;

    private var _system : ActorSystem;

    private var _childrenRefs : List<ActorRef>;

    private var _currentMessage : Envelope;

    public function new() {
        _dispatcher = _system.dispatchers.lookup(props.dispatcher());
    }

    public function start() {
        _mailbox = _dispatcher.createMailbox(this);
        _mallbox.systemEnqueue(self(), Create);

        _parent.sendSystemMessage(Supervise(self()));

        _dispatcher.attach(this);
    }

    public function suspend() : Void _dispatcher.systemDispatch(this, Suspend);

    public function resume() : Void _dispatcher.systemDispatch(this, Resume);
    
    public function stop() : Void _dispatcher.systemDispatch(this, Stop);

    public function children() : List<ActorRef> return _childrenRefs.children;

    public function tell<T>(message : T, sender : ActorRef) : Void {
        var ref = AnyTypes.toBool(sender)? sender : _system.deadLetters;
        _dispatcher.dispatch(this, Envelope(message, ref));
    }

    public function sender() : ActorRef {
        return switch(_currentMessage) {
            case Envelope(msg, sender) if (AnyTypes.toBool(sender)): sender;
            case _: _system.deadLetters;
        }
    }

    public function newActor() : Actor {
        try {
            var instance = props.creator();

            if (AnyTypes.toBool(instance)) {
                Funk.Errors(ActorError("Actor instance passed to actorOf can't be 'null'"));
            }
        } catch(e : Dynamic) {
            throw e;
        }
    }

    public function systemInvoke(message : SystemMessage) {
        switch(message) {
            case Create: create();
            case Recreate(cause): recreate(cause);
            case Link(subject): link(subject);
            case Unlink(subject): unlink(subject);
            case Suspend: suspend();
            case Resume: resume();
            case Terminated: terminated();
            case Supervise(child): supervise(child);
            case ChildTerminated(child): handChildTerminated(child);
        }
    }

    public function invoke(message : Envelope) {
        _currentMessage = message;
    }

    private function create() : Void {
        try {
            _actor = newActor();
            _actor.preStart();
        } catch (e : Dynamic) {
            _parent.tell(Failed(self, "exception during creation"));
        }
    }

    private function recreate(cause : Errors) : Void {
        switch(cause) {
            case _: // TODO (Simon) : Work out if we can reboot the actor.
        }
    }

    private function suspend() : Void if(isNormal()) _dispatcher.suspend(this);

    private function resume() : Void if(isNormal()) _dispatcher.resume(this);

    private function link(subject : ActorRef) : Void {
        if (!isTerminating()) {
            // TODO (Simon) : Workout if we need to link
        }
    }

    private function unlink(subject : ActorRef) : Void {
        if (!isTerminating()) {
            // TODO (Simon) : Workout if we need to link
        }
    }

    private function terminated() : Void {
        children().foreach(function(value) value.stop());

        _dispatcher.detach(this);
        parent().sendSystemMessage(ChildTerminated(self()));
        _actor = null;
    }

    private function supervise(child : ActorRef) : Void {
        var opt = _childrenRefs.find(function(value) return value == child);
        if (opt.isEmpty()) {
            _childrenRefs = _childrenRefs.prepend(child);
        }
    }

    private function handChildTerminated(child : ActorRef) : Void {
        _childrenRefs = _childrenRefs.filterNot(function(value) return value == child);
    }
}