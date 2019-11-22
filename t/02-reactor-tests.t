use v6;

use Test;
use Reactor;

my $supplier = Supplier.new;
my $output = Channel.new;
my &functor = -> $x { $x + 1 };

ok my $reactor = Reactor.new( :input($supplier.Supply), :$output ), "Created OK";

my $p = $reactor.start( &functor );

sleep(0.1);

is $p.WHAT, Promise, "Reactor returns a promise";
is $p.status, "Planned", "Promise is still planned";

#my $s = $supplier.Supply;
#$s.tap( -> $v { note "$v Emitted" } );

$supplier.emit( 1 );

my $sum = $output.poll();

is $sum, 2, "The reactor passed the message to the functor which incremented it and passed it out";

$supplier.emit( 1 );

$sum = $output.poll();

is $sum, 2, "Functional code is functional";

my &functor-two = -> $x { $x * 2 };

my $p2 = $reactor.start( &functor-two );

$supplier.emit( 2 );
sleep(0.1);
my @sums = ( $output.poll(), $output.poll() );

ok @sums == set(2,4), "Multiple functors can receive";


done-testing;
