package Test::DummyGenerator::Rule::Default;

use Test::DummyGenerator::Rule;

use DateTime;
use String::Random;
my $sr = String::Random->new;

rule str => sub {
    local $SIG{__WARN__} = sub {
        print $_[0] if $_[0] !~ /treat/;
    };
    $sr->randregex($_[0]);
};

rule rand => sub { int(rand $_[0]) + 1 };

rule exp => sub { eval $_[0]; };

rule range => sub {
    (my $arg_str = $_[0]) =~ s/[^,.0-9]//g;
    my ($min, $max) = (split ',', $arg_str);
    my $rnd = $max - $min + 1;
    return int(rand $rnd) + $min;
};

rule add => sub {
    my $d = DateTime->now->set_time_zone('Asia/Tokyo')->add(eval "($_[0])");
    my $ymd = $d->ymd;
    my $hms = $d->hms;
    return "${ymd} ${hms}";
};

1;
