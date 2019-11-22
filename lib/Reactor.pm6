unit role Reactor;

has Supply $!input;
has Channel $!output;

submethod BUILD( :$!input, :$!output ) {}

method start( &functor ) {
    start react {
        whenever $!input -> $v {
            $!output.send( &functor( $v ) );
        }
    }
}
