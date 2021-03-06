#!/usr/bin/perl -w

use strict;

use Test::More tests => 4;

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
<a href="../">Home</a>
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
<a href="../">Home</a>
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
    is($returned_text, $expected_text, "site_map #2"); # TEST
}

{
    my $nav_menu = Shlomif::NavMenu->new(
        'path_info' => "hello/world/",
        'current_host' => "default",
        'hosts' =>
        {
            'default' =>
            {
                'base_url' => "http://www.hello.com/",
            },
            'other' => 
            { 
                'base_url' => "http://www.other-url.co.il/~shlomif/", 
            },
        },
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
                        {
                            'url' => "round/toto/",
                            'value' => "Gloria",
                            'title' => "A Useful Conspiracy",
                        },
                    ],
                },
                {
                    'value' => "Tam Tam Drums",
                    'title' => "Drumming is good for your health",
                    'url' => "hoola/",
                    'host' => "other",
                    'subs' =>
                    [
                        {
                            'url' => "hello/hoop.html",
                            'title' => "Hoola Hoops Rulez and Ownz!",
                            'value' => "Hoola Hoops",
                            'host' => "default",
                        },
                        {
                            'url' => "tetra/",
                            'value' => "Tetrahedron",
                            'subs' =>
                            [
                                {
                                    'url' => "tetra/one/",
                                    'value' => "Tetra One",
                                    'title' => "Tetra One Title",
                                },
                            ],
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
<a href="../../">Home</a>
</li>
<li>
<a href="../../me/" title="About Myself">About Me</a> - About Myself
<br />
<ul>
<li>
<a href="../../round/hello/personal.html" title="Biography of Myself">Bio</a> - Biography of Myself
</li>
<li>
<a href="../../round/toto/" title="A Useful Conspiracy">Gloria</a> - A Useful Conspiracy
</li>
</ul>
</li>
<li>
<a href="http://www.other-url.co.il/~shlomif/hoola/" title="Drumming is good for your health">Tam Tam Drums</a> - Drumming is good for your health
<br />
<ul>
<li>
<a href="../hoop.html" title="Hoola Hoops Rulez and Ownz!">Hoola Hoops</a> - Hoola Hoops Rulez and Ownz!
</li>
<li>
<a href="http://www.other-url.co.il/~shlomif/tetra/">Tetrahedron</a>
<br />
<ul>
<li>
<a href="http://www.other-url.co.il/~shlomif/tetra/one/" title="Tetra One Title">Tetra One</a> - Tetra One Title
</li>
</ul>
</li>
</ul>
</li>
</ul>
EOF
    is($returned_text, $expected_text, "site_map - complex"); # TEST
}

# Now testing that the separator is safely skipped and does not generate
# a double </li>
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
                {
                    'separator' => 1,
                    'skip' => 1,
                },
                {
                    'value' => "Hoola",
                    'title' => "Hoola Hoop",
                    'url' => "me-too/",
                },
            ],
        },
    );

    my $returned_text = $nav_menu->gen_site_map();
    my $expected_text = <<"EOF";
<ul>
<li>
<a href="../">Home</a>
</li>
<li>
<a href="../me/" title="About Myself">About Me</a> - About Myself
</li>
<li>
<a href="../me-too/" title="Hoola Hoop">Hoola</a> - Hoola Hoop
</li>
</ul>
EOF
    is($returned_text, $expected_text, "site_map - separator"); # TEST

    

}

