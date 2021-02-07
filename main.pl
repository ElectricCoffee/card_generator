use v5.28;
use warnings;
use autodie;
use Template;
use Cwd;
use Getopt::Long;

GetOptions (
    'keep-svg'  => \my $keep_svg,
    clean       => \my $want_clean,
    silent      => \my $run_silent,
);

if ($want_clean) {
    chdir './out';
    for (<*>) {
        unlink $_;
    }
    exit;
}

my $tt = Template->new(
    INCLUDE_PATH => './templates',
    OUTPUT_PATH  => './out',
);

say 'Generating SVGs...' unless $run_silent;
for (1 .. 6) {
    $tt->process(
        'card.svg.tt', 
        { index => $_, resources => cwd . '/resources'}, 
        "card-$_.svg",
        { binmode => ':raw' }
    );
}

chdir './out';

say 'Generating PNGs...' unless $run_silent;
for (<*.svg>) {
    system "rsvg-convert.exe -f png -o $_.png $_";
    unlink $_ unless $keep_svg;
}