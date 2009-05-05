package Test::DummyGenerator::Rule::Default;

use Test::DummyGenerator::Rule;

use DateTime;
use String::Random;
my $sr = String::Random->new;

rule str => sub { $sr->randregex($_[0]); };

rule rand => sub { int(rand $_[0]) + 1 };

rule exp => sub {
    (my $exp = $_[0]) =~ s/_/$_/g;
    eval $exp;
};

rule range => sub {
    (my $arg_str = $_[0]) =~ s/\s//g;
    my ($min, $max) = (split ',', $arg_str);
    return int(rand($max - $min + 1)) + $min;
};

rule add => sub {
    my $d = DateTime->now->set_time_zone('Asia/Tokyo')->add( eval $_[0] );
    my $ymd = $d->ymd;
    my $hms = $d->hms;
    return "${ymd} ${hms}";
};

1;
