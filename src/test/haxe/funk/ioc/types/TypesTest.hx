package funk.ioc.types;

import funk.ioc.Injector;
import funk.ioc.types.Command;
import funk.ioc.types.Facade;

using funk.types.extensions.Attempts;

class TypesTest {

    @Test
    public function test() : Void {
        Injector.initialize();

        var facade : Facade = cast Injector.add(new Facade());
        facade.construct();

        facade.addCommand(Tracer, TraceCommand);
        facade.addCommand(Nil, NilCommand);

        facade.addProxy(TraceProxy);

        facade.dispatch(Trace("Hello, World!"));
        facade.dispatch(Ignore);
    }
}

private enum Tracer {
    Trace(value : String);
    Ignore;
}

private enum Nil {
    Nothing;
}

private class TraceCommand extends Command<Tracer> {

    public function new() {
        super();
    }

    override public function execute(value : Tracer) : Void {
        switch(value) {
            case Trace(value): trace("Trace " +  value);
            case Ignore:
        }
    }
}

private class NilCommand extends Command<Nil> {

    public function new() {
        super();
    }

    override public function execute(value : EnumValue) : Void {
        trace("Nil " + value);
    }
}

private class TraceProxy<T> extends Proxy<T> {

    public function new() {
        super();
    }

}