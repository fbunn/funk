package funk.types;

import funk.Funk;
import funk.types.Function1;

using funk.ds.immutable.List;
using funk.ds.immutable.ListUtil;
using funk.types.Any;
using funk.types.Option;
using funk.types.Tuple2;

class Selector {

    public static function query(selector : String) : List<Expr> {
        var lexer = new Lexer(selector);
        var parser = new Parser(lexer);
        return parser.execute();
    }
}

class SelectorTypes {

    public static function toString(expr : Expr) : String {
        return extractExpr(expr);
    }

    private static function extractExpr(expr : Expr) : String {
        return switch(expr) {
            case ELine(e): extractExpr(e);
            case EProp(v): extractValue(v);
            case EPropBlock(v, e): '${extractValue(v)} ${extractExpr(e)}';
            case ESub(e): extractExpr(e);
        };
    }

    private static function extractValue(value : Value) : String {
        return switch(value) {
            case Accessor(v): ':${v}';
            case All: "*";
            case ClassName(v): '.${v}';
            case Child: ">";
            case Integer(v): Std.string(v);
            case Ident(v): '#${v}';
            case Next: "+";
            case Number(v): Std.string(v);
            case Sibling: "~";
            case Tag(v): v;
            case Word(v): v;
        }
    }
}

enum Expr {
    ELine(expr : Expr);
    EProp(value : Value);
    EPropBlock(value : Value, expr : Expr);
    ESub(expr : Expr);
}

enum Value {
    Accessor(value : String);
    All;
    ClassName(value : String);
    Child;
    Integer(value : Int);
    Ident(value : String);
    Next;
    Number(value : Float);
    Sibling;
    Tag(value : String);
    Word(value : String);
}

private enum Constant {
    Accessor(value : String);
    ClassName(value : String);
    Ident(value : String);
    Integer(value : Int);
    Number(value : Float);
    Tag(value : String);
    Word(value : String);
}

private enum Token {
    Eof;
    Gt;
    Comma;
    Const(value : Constant);
    LeftBracket;
    RightBracket;
    Plus;
    SemiColon;
    Star;
    Tilde;
    WhiteSpace;
    Unknown;
}

private class LexerPatterns {

    public var patterns : List<Tuple2<String, Function1<String, Token>>>;

    /**
     * Low level caching, so we don't have to generate these every time the lexer is invoked
     */
    public function new() {
        var list : List<Tuple2<String, Function1<String, Token>>> = Nil;
        list = list.prepend(tuple2("\\s*", function(value) {
            return WhiteSpace;
        }));
        list = list.prepend(tuple2(">", function(value){
            return Gt;
        }));
        list = list.prepend(tuple2(",", function(value){
            return Comma;
        }));
        list = list.prepend(tuple2(";", function(value){
            return SemiColon;
        }));
        list = list.prepend(tuple2("\\~", function(value){
            return Tilde;
        }));
        list = list.prepend(tuple2("\\+", function(value){
            return Plus;
        }));
        list = list.prepend(tuple2("\\*", function(value){
            return Star;
        }));
        list = list.prepend(tuple2("\\(", function(value){
            return LeftBracket;
        }));
        list = list.prepend(tuple2("\\)", function(value){
            return RightBracket;
        }));
        list = list.prepend(tuple2("0", function(value) {
            return Const(Integer(Std.parseInt(value)));
        }));
        list = list.prepend(tuple2("-?[0-9]+\\.[0-9]*", function(value) {
            return Const(Number(Std.parseFloat(value)));
        }));
        list = list.prepend(tuple2("-?\\.[0-9]+", function(value) {
            return Const(Number(Std.parseFloat(value)));
        }));
        list = list.prepend(tuple2("-?[1-9][0-9]*", function(value) {
            return Const(Integer(Std.parseInt(value)));
        }));
        list = list.prepend(tuple2("\\.[a-zA-Z0-9\\-\\_]*", function(value : String){
            return Const(ClassName(value.substr(1)));
        }));
        list = list.prepend(tuple2("#[a-zA-Z0-9\\-\\_]*", function(value : String){
            return Const(Ident(value.substr(1)));
        }));
        list = list.prepend(tuple2(":[a-zA-Z0-9\\-\\_]*", function(value : String){
            return Const(Accessor(value.substr(1)));
        }));
        list = list.prepend(tuple2("[a-zA-Z0-9\\-\\_]*", function(value) {
            return Const(Tag(value));
        }));
        list = list.prepend(tuple2("(\".*?\")|('.*?')", function(value : String) {
            return Const(Word(value.substr(1, value.length - 2)));
        }));

        patterns = list.reverse();
    }
}

private class Lexer {

    private var _source : String;

    private var _index : Int;

    private var _patterns : LexerPatterns;

    public function new(source : String) {
        _index = 0;
        _source = source;

        _patterns = new LexerPatterns();
    }

    public function hasNext() : Bool {
        return _index < _source.length;
    }

    public function next() : Option<Token> {
        return if (hasNext()) {
            var substr = _source.substr(_index++);

            var token = None;
            _patterns.patterns.find(function(tuple) {
                var ereg = new EReg("^" + tuple._1(), "");
                var result = false;
                if(ereg.match(substr)) {
                    var matched = ereg.matched(0);

                    if (matched.length > 0) {
                        _index += matched.length - 1;

                        token = tuple._2()(matched).toOption();
                        result = true;
                    }
                }
                return result;
            });
            token;
        } else {
            Some(Eof);
        }
    }
}

private class Parser {

    private var _lexer : Lexer;

    private var _bracket : Int;

    public function new(lexer : Lexer) {
        _lexer = lexer;
        _bracket = 0;
    }

    public function execute() : List<Expr> {
        var list = Nil;
        while(_lexer.hasNext()) {
            var expr = matchToken(next());
            if (AnyTypes.toBool(expr)) {
                if (_bracket != 0) {
                    Funk.error(IllegalOperationError("Bracket mismatch; extra left ( found."));
                }
                list = list.append(ELine(expr));
            }
        }
        return list;
    }

    private function hasNext() : Bool {
        return _lexer.hasNext();
    }

    private function next() : Option<Token> {
        return _lexer.hasNext() ? _lexer.next() : None;
    }

    private function matchToken(opt : Option<Token>) : Expr {
        var fold = function (value : Value) {
            var token = if (hasNext()) matchToken(next()) else null;
            return AnyTypes.toBool(token) ? EPropBlock(value, token) : EProp(value);
        };
        var openBlock = function () {
            _bracket++;
            var token = if (hasNext()) {
                matchToken(next());
            } else {
                Funk.error(IllegalOperationError("Exhausted"));
            }
            return ESub(token);
        };
        var closeBlock = function () {
            _bracket--;
            if (_bracket < 0) {
                Funk.error(IllegalOperationError("Bracket mismatch; extra right ) found."));
            }
            return null;
        };

        return switch (opt) {
            case Some(token):
                switch(token){
                    case Const(const):
                        switch (const) {
                            case Accessor(value): fold(Accessor(value));
                            case ClassName(value): fold(ClassName(value));
                            case Ident(value): fold(Ident(value));
                            case Integer(value): fold(Integer(value));
                            case Number(value): fold(Number(value));
                            case Tag(value): fold(Tag(value));
                            case Word(value): fold(Word(value));
                        }
                    case Gt: fold(Child);
                    case LeftBracket: openBlock();
                    case RightBracket:
                        closeBlock();
                        if (hasNext()) matchToken(next());
                        else null;
                    case Plus: fold(Next);
                    case Star: fold(All);
                    case Tilde: fold(Sibling);
                    case WhiteSpace: matchToken(next());
                    case Unknown: Funk.error(IllegalOperationError("Unknown token"));
                    case _: null;
                }
            case _: null;
        }
    }
}
