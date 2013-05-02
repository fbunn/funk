package funk.types;

using funk.types.PartialFunction4;
using massive.munit.Assert;

class PartialFunction4Test {


    @Test
    public function when_partial_isDefinedAt_2_should_be_true() : Void {
        var partial = Partial4(function(v0, v1, v2, v3) return v0 > 0, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        partial.isDefinedAt(2, 1, 1, 1).isTrue();
    }

    @Test
    public function when_partial_isDefinedAt_minus_2_should_be_false() : Void {
        var partial = Partial4(function(v0, v1, v2, v3) return v0 > 0, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        partial.isDefinedAt(-2, 1, 1, 1).isFalse();
    }

    @Test
    public function when_partial_call_with_2_should_be_16() : Void {
        var partial = Partial4(function(v0, v1, v2, v3) return v0 > 0, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        Assert.areEqual(partial.call(2, 2, 2, 2), 16);
    }

    @Test
    public function when_partial_call_with_2_should_not_be_5() : Void {
        var partial = Partial4(function(v0, v1, v2, v3) return v0 > 0, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        Assert.areNotEqual(partial.call(2, 2, 2, 2), 5);
    }

    @Test
    public function when_partial_call_with_minus_2_should_throw_error() : Void {
        var partial = Partial4(function(v0, v1, v2, v3) return v0 > 0, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var called = try { partial.call(-2, -2, -2, -2); false; } catch (e : Dynamic) true;
        called.isTrue();
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_isDefinedAt_1_should_be_true() : Void {
        var partial0 = Partial4(function(v0, v1, v2, v3) return v0 == 1, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial1 = Partial4(function(v0, v1, v2, v3) return v1 == 2, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial = partial0.orElse(partial1);
        partial.isDefinedAt(1, 1, 1, 1).isTrue();
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_isDefinedAt_2_should_be_true() : Void {
        var partial0 = Partial4(function(v0, v1, v2, v3) return v0 == 1, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial1 = Partial4(function(v0, v1, v2, v3) return v1 == 2, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial = partial0.orElse(partial1);
        partial.isDefinedAt(2, 2, 2, 2).isTrue();
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_isDefinedAt_minus_2_should_be_false() : Void {
        var partial0 = Partial4(function(v0, v1, v2, v3) return v0 == 1, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial1 = Partial4(function(v0, v1, v2, v3) return v1 == 2, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial = partial0.orElse(partial1);
        partial.isDefinedAt(-2, -2, -2, -2).isFalse();
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_call_1_should_be_2() : Void {
        var partial0 = Partial4(function(v0, v1, v2, v3) return v0 == 1, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial1 = Partial4(function(v0, v1, v2, v3) return v1 == 2, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial = partial0.orElse(partial1);
        Assert.areEqual(partial.call(1, 1, 1, 1), 1);
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_call_2_should_be_16() : Void {
        var partial0 = Partial4(function(v0, v1, v2, v3) return v0 == 1, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial1 = Partial4(function(v0, v1, v2, v3) return v1 == 2, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial = partial0.orElse(partial1);
        Assert.areEqual(partial.call(2, 2, 2, 2), 16);
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_call_2_should_not_be_5() : Void {
        var partial0 = Partial4(function(v0, v1, v2, v3) return v0 == 1, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial1 = Partial4(function(v0, v1, v2, v3) return v1 == 2, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial = partial0.orElse(partial1);
        Assert.areNotEqual(partial.call(2, 2, 2, 2), 5);
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_call_minus_2_should_throw_error() : Void {
        var partial0 = Partial4(function(v0, v1, v2, v3) return v0 == 1, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial1 = Partial4(function(v0, v1, v2, v3) return v1 == 2, function(v0, v1, v2, v3) return v0 * v1 * v2 * v3).fromPartial();
        var partial = partial0.orElse(partial1);
        var called = try { partial.call(-2, -2, -2, -2); false; } catch(e : Dynamic) true;
        called.isTrue();
    }
}
