#!/usr/bin/perl -w

use strict;

use Test::More tests => 2;

use Shlomif::NavMenu;

{
    my $nav_menu = Shlomif::NavMenu->new(
        'path_info' => "hello/",
        'current_host' => "default",
        'hosts' => { 'default' => { 'base_url' => "http://www.hello.com/" }, },
        'tree_contents' =>
        {
            'host' => "default",
            'value' => "Top 1",
            'title' => "T1 Title",
            'expand_re' => "",
            'subs' =>
            [
                {
                    'value' => "Home",
                    'url' => "",
                },
                {
                    'value' => "About Me",
                    'title' => "About Myself",
                    'url' => "me/",
                },
            ],
        },
    );

    my $returned_text = $nav_menu->gen_site_map();
    my $expected_text = <<"EOF";
<ul>
<li>
<a href="..">Home</a>
</li>
<li>
<a href="../me/" title="About Myself">About Me</a> - About Myself
</li>
</ul>
EOF
    is($returned_text, $expected_text, "site_map #1"); # TEST

    

}

{
    my $nav_menu = Shlomif::NavMenu->new(
        'path_info' => "hello/",
        'current_host' => "default",
        'hosts' => { 'default' => { 'base_url' => "http://www.hello.com/" }, },
        'tree_contents' =>
        {
            'host' => "default",
            'value' => "Top 1",
            'title' => "T1 Title",
            'expand_re' => "",
            'subs' =>
            [
                {
                    'value' => "Home",
                    'url' => "",
                },
                {
                    'value' => "About Me",
                    'title' => "About Myself",
                    'url' => "me/",
                    'subs' =>
                    [
                        {
                            'url' => "round/hello/personal.html",
                            'value' => "Bio",
                            'title' => "Biography of Myself",
                        },
                    ],
                },
            ],
        },
    );

    my $returned_text = $nav_menu->gen_site_map();
    my $expected_text = <<"EOF";
<ul>
<li>
<a href="..">Home</a>
</li>
<li>
<a href="../me/" title="About Myself">About Me</a> - About Myself
<br />
<ul>
<li>
<a href="../round/hello/personal.html" title="Biography of Myself">Bio</a> - Biography of Myself
</li>
</ul>
</li>
</ul>
EOF
    is($returned_text, $expected_text, "site_map #1"); # TEST

    

}
