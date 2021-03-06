#!/usr/bin/perl -w

use strict;

use Test::More tests => 7;

use Shlomif::NavMenu;

{
my $text = "test/foo";

my $url = Shlomif::NavMenu::text_to_url_obj($text);

my $components = $url->get_url();
ok (scalar(@$components) == 2); # TEST
ok ($components->[0] eq "test"); # TEST
ok ($components->[1] eq "foo"); # TEST
ok (! $url->is_dir()); # TEST

}

{
    my $url1 = Shlomif::NavMenu::Url->new(["links.html"], 0, "server");
    my $url2 = Shlomif::NavMenu::Url->new(["links.html"], 0, "server");
    my $rel_url = $url1->get_relative_url($url2, 0);
    ok ($rel_url eq "./links.html", "Checking for same file to itself link");  # TEST
}

{
    my $root_url = Shlomif::NavMenu::Url->new("", 1);
    my $current_url = Shlomif::NavMenu::Url->new("open-source/", 1);

    ok ($current_url->get_relative_url($root_url, 1) eq "../",
        "Checking for link to root directory"); # TEST
}

{
    # TEST
    ok ((Shlomif::NavMenu::get_relative_url("open-source/", "") eq "../"),
        "get_relative_url(): Checking for link to root directory"
    );
}
