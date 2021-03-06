package funk.actors;

import funk.actors.ActorRef;
import funk.futures.Promise;
import funk.types.Any;
import funk.types.extensions.Strings;
import massive.munit.async.AsyncFactory;

using massive.munit.Assert;
using funk.types.Attempt;
using funk.types.Option;

class ActorSystemTest {

    private var _system : ActorSystem;

    @Before
    public function setup() : Void {
        _system = ActorSystem.create('system');
    }

    @Test
    public function calling_actorOf_should_return_ActorRef_that_is_not_null() : Void {
        _system.actorOf(new Props(MockClass), "listener").isNotNull();
    }

    @Test
    public function calling_actorOf_should_return_valid_ActorRef() : Void {
        var ref = _system.actorOf(new Props(MockClass), "listener");
        AnyTypes.isInstanceOf(ref, ActorRef).isTrue();
    }

    @Test
    public function calling_actorOf_should_return_valid_ActorRef_path() : Void {
        var rand = Std.string(Std.int(Math.random() * 9999));
        var ref = _system.actorOf(new Props(MockClass), 'name$rand');
        ref.path().toString().areEqual('funk://system/user/name$rand/');
    }

    @Test
    public function calling_actorOf_multiple_times_should_return_valid_ActorRef_path() : Void {
        for (i in 0...10) {
            var ref = _system.actorOf(new Props(MockClass), 'name$i');
            ref.path().toString().areEqual('funk://system/user/name$i/');
        }
    }

    @Test
    public function calling_actorOf_and_telling_the_actor_some_info_should_be_called() : Void {
        var expected = "hello";
        var ref = _system.actorOf(new Props(MockClass), 'name');
        ref.send(expected, ref);
        MockClass.Actual.areEqual(expected);
    }

    @Test
    public function calling_toString_on_actor_path_should_return_valid_path() : Void {
        var path = _system.actorPath().toString();
        path.areEqual('funk://system/user/');
    }

    @Test
    public function calling_actorFor_should_return_ActorRef_that_is_not_null() : Void {
        var actual = '';
        var expected = 'Name_${Strings.uuid()}';

        var ref = _system.actorOf(new Props(MockClass), expected);

        _system.actorFor(ref.path()).get().isNotNull();
    }

    @Test
    public function calling_actorFor_should_return_ActorRef_that_is_not_an_EmptyActorRef() : Void {
        var actual = '';
        var expected = 'Name_${Strings.uuid()}';

        var ref = _system.actorOf(new Props(MockClass), expected);

        AnyTypes.isInstanceOf(_system.actorFor(ref.path()).get(), EmptyActorRef).isFalse();
    }

    @Test
    public function calling_actorFor_should_return_ActorRef_that_is_the_same_path() : Void {
        var actual = '';
        var expected = 'Name_${Strings.uuid()}';

        var ref = _system.actorOf(new Props(MockClass), expected);

        _system.actorFor(ref.path()).get().path().toString().areEqual(ref.path().toString());
    }
}

private class MockClass extends Actor {

    public static var Actual : AnyRef;

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        Actual = value;
    }
}
