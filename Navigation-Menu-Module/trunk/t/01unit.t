use Test::More tests => 5;

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
    
