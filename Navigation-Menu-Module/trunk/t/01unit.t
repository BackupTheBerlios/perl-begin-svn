# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Shlomif-NavMenu.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 4;

use Shlomif::NavMenu;

my $text = "test/foo";

my $url = Shlomif::NavMenu::text_to_url_obj($text);

my $components = $url->get_url();
ok (scalar(@$components) == 2); # TEST
ok ($components->[0] eq "test"); # TEST
ok ($components->[1] eq "foo"); # TEST
ok (! $url->is_dir()); # TEST

