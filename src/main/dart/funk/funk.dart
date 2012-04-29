#library("funk:funk");

#import("dart:core");

#source("IFunkObject.dart");
#source("Type.dart");
#source("Product.dart");
#source("ProductIterator.dart");
#source("util/eq.dart");
#source("util/require.dart");
#source("util/verifiedType.dart");
#source("errors/ArgumentError.dart");
#source("errors/RangeError.dart");
#source("exceptions/IllegalByDefinitionException.dart");
#source("exceptions/NoSuchElementException.dart");
#source("exceptions/TypeException.dart");
#source("tuple/ITuple.dart");
#source("tuple/Tuple1.dart");
#source("tuple/Tuple2.dart");
#source("option/Option.dart");
#source("option/None.dart");
#source("option/Some.dart");
#source("option/when.dart");
#source("collections/ICollection.dart");
#source("collections/IList.dart");
#source("collections/toList.dart");
#source("collections/IteratorUtil.dart");
#source("collections/immutable/ListImpl.dart");
#source("collections/immutable/NilImpl.dart");
#source("ioc/errors/BindingException.dart");
#source("ioc/IProvider.dart");
#source("ioc/IScope.dart");
#source("ioc/Binding.dart");
#source("ioc/Module.dart");
#source("ioc/Injector.dart");
#source("types/ListType.dart");
#source("types/OptionType.dart");
#source("types/StringType.dart");

main(){
  // IModule mod = module();
  // mod.getInstance(String);
}