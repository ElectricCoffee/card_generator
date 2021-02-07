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

#my @suits = qw(coin quill sword bell star flag);
my @suits = qw(bell);

say 'Generating SVGs...' unless $run_silent;
for my $suit (@suits) {
    for my $rank (1 .. 6) {
        $tt->process(
            'card.svg.tt', 
            { 
                index => $rank, 
                resources => cwd . '/resources', 
                pip => "$suit.svg.tt",
            }, 
            "card-$suit-$rank.svg",
            { binmode => ':raw' }
        );
    }
}
say 'SVGs done.' unless $run_silent;

chdir './out';

say 'Generating PNGs...' unless $run_silent;
for (<*.svg>) {
    system "rsvg-convert.exe -f png -o $_.png $_";
    unlink $_ unless $keep_svg;
}
say 'PNGs done.' unless $run_silent;