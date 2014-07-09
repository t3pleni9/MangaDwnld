#!/usr/bin/perl
my $imageURL = "$ARGV[0]";
my $pageCount = "$ARGV[1]";
my @r = split /01|001|0001/, $imageURL;
my $diff = length($imageURL) - length (join '', @r);
my $form = "%0".$diff."d";
for $i (1..$pageCount) {
    print $r[0].sprintf($form, $i).$r[1]." ";
}

