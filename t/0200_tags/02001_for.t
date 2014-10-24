use strict;
use warnings;
use lib qw[../../lib ../../blib/lib];
use Test::More;    # Requires 0.94 as noted in Build.PL
use Solution;
is(Solution::Template->parse(<<'TEMPLATE')->render(), <<'EXPECTED', '(1..5)');
{%for x in (1..5) %}X{%endfor%}
TEMPLATE
XXXXX
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render(eval <<'ARGS'), <<'EXPECTED', q[(range.from..range.to)]);
{% for x in (range.from..range.to) %}X{% endfor %}
TEMPLATE
{ range => { from => 10, to => 29 } }
ARGS
XXXXXXXXXXXXXXXXXXXX
EXPECTED
is( Solution::Template->parse(
                <<'TEMPLATE')->render(), <<'EXPECTED', 'for x in (100..105)');
{% for x in (100..105) %} {{ x }}{% endfor %}
TEMPLATE
 100 101 102 103 104 105
EXPECTED
TODO: {
    local $TODO = <<'';
Liquid bug. Valid syntax
does not function as expected. The problem is Liquid's
precidence based context merges. Easily fixed.

    is( Solution::Template->parse(
              <<'TEMPLATE')->render(), <<'EXPECTED', 'for x.y in (100..105)');
{% for x.y in (100..105) %} {{ x.y }}{% endfor %}
TEMPLATE
 100 101 102 103 104 105
EXPECTED
}
is( Solution::Template->parse(
                   <<'TEMPLATE')->render(), <<'EXPECTED', 'forloop.last [A]');
{% for x in (100..105) %}{{ x }}{% unless forloop.last %}, {% endunless %}{% endfor %}
TEMPLATE
100, 101, 102, 103, 104, 105
EXPECTED
is( Solution::Template->parse(
                            <<'TEMPLATE')->render(), <<'EXPECTED', 'limit:2');
{% for x in (100..105) limit:2 %} {{ x }}{% endfor %}
TEMPLATE
 100 101
EXPECTED
is( Solution::Template->parse(
                            <<'TEMPLATE')->render(), <<'EXPECTED', 'limit:0');
{% for x in (100..105) limit:0 %} {{ x }}{% endfor %}
TEMPLATE

EXPECTED
is( Solution::Template->parse(
                          <<'TEMPLATE')->render(), <<'EXPECTED', 'limit:var');
{% assign var = 5 %}
{% for x in (100..105) limit:var %} {{ x }}{%endfor%}
TEMPLATE

 100 101 102 103 104
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render(), <<'EXPECTED', 'limit:50 [beyond end of list])');
{% assign limit = 50 %}
{% for x in (100..105) limit:limit %} {{ x }}{% endfor %}
TEMPLATE

 100 101 102 103 104 105
EXPECTED
is( Solution::Template->parse(
                            <<'TEMPLATE')->render(), <<'EXPECTED', 'limit: ');
{% for x in (100..105) limit: %} {{ x }}{% endfor %}
TEMPLATE
 100 101 102 103 104 105
EXPECTED
is( Solution::Template->parse(
                           <<'TEMPLATE')->render(), <<'EXPECTED', 'offset:2');
{% for x in (100..105) offset:2 %} {{ x }}{% endfor %}
TEMPLATE
 102 103 104 105
EXPECTED
is( Solution::Template->parse(
                           <<'TEMPLATE')->render(), <<'EXPECTED', 'offset:0');
{% for x in (100..105) offset:0 %} {{ x }}{% endfor %}
TEMPLATE
 100 101 102 103 104 105
EXPECTED
is( Solution::Template->parse(
             <<'TEMPLATE')->render(), <<'EXPECTED', 'offset:var [var == 50]');
{% assign var = 50 %}
{% for x in (100..105) offset:var %} {{ x }}{%endfor%}
TEMPLATE


EXPECTED
is( Solution::Template->parse(
              <<'TEMPLATE')->render(), <<'EXPECTED', 'offset:var [var == 3]');
{% assign var = 3 %}
{% for x in (100..105) offset:var %} {{ x }}{%endfor%}
TEMPLATE

 103 104 105
EXPECTED
is( Solution::Template->parse(
                            <<'TEMPLATE')->render(), <<'EXPECTED', 'offset:');
{% for x in (100..105) offset: %} {{ x }}{% endfor %}
TEMPLATE
 100 101 102 103 104 105
EXPECTED
is( Solution::Template->parse(
                   <<'TEMPLATE')->render(), <<'EXPECTED', 'offset:2 limit:2');
{% for x in (100..105) offset:2 limit:2 %} {{ x }}{% endfor %}
TEMPLATE
 102 103
EXPECTED
is( Solution::Template->parse(
                 <<'TEMPLATE')->render(), <<'EXPECTED', 'offset:200 limit:2');
{% for x in (100..105) offset:200 limit:2 %} {{ x }}{% endfor %}
TEMPLATE

EXPECTED
is( Solution::Template->parse(
                   <<'TEMPLATE')->render(), <<'EXPECTED', 'offset:2 limit:0');
{% for x in (100..105) offset:2 limit:0 %} {{ x }}{% endfor %}
TEMPLATE

EXPECTED
is( Solution::Template->parse(
                           <<'TEMPLATE')->render(), <<'EXPECTED', 'reversed');
{% for x in (100..105) reversed %} {{ x }}{% endfor %}
TEMPLATE
 105 104 103 102 101 100
EXPECTED
is( Solution::Template->parse(
                  <<'TEMPLATE')->render(), <<'EXPECTED', 'reversed offset:2');
{% for x in (100..105) reversed offset:2 %} {{ x }}{% endfor %}
TEMPLATE
 102 103 104 105
EXPECTED
is( Solution::Template->parse(
                   <<'TEMPLATE')->render(), <<'EXPECTED', 'reversed limit:2');
{% for x in (100..105) reversed limit:2 %} {{ x }}{% endfor %}
TEMPLATE
 100 101
EXPECTED
is( Solution::Template->parse(
          <<'TEMPLATE')->render(), <<'EXPECTED', 'reversed offset:2 limit:2');
{% for x in (100..105) reversed offset:2 limit:2 %} {{ x }}{% endfor %}
TEMPLATE
 102 103
EXPECTED

#
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable for x in array');
{% for x in array %} {{ x }}{% endfor %}
TEMPLATE
 100 101 102 103 104 105
EXPECTED
TODO: {
    local $TODO = <<'';
Liquid bug. Valid syntax
does not function as expected. The problem is Liquid's
precidence based context merges. Easily fixed.

    is( Solution::Template->parse(
            <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable for x.y in array');
{% for x.y in array %} {{ x.y }}{% endfor %}
TEMPLATE
 100 101 102 103 104 105
EXPECTED
}
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable forloop.last [A]');
{% for x in array %}{{ x }}{% unless forloop.last %}, {% endunless %}{% endfor %}
TEMPLATE
100, 101, 102, 103, 104, 105
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable limit:2');
{% for x in array limit:2 %} {{ x }}{% endfor %}
TEMPLATE
 100 101
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable limit:0');
{% for x in array limit:0 %} {{ x }}{% endfor %}
TEMPLATE

EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable limit:var');
{% assign var = 5 %}
{% for x in array limit:var %} {{ x }}{%endfor%}
TEMPLATE

 100 101 102 103 104
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable limit:50 [beyond end of list])');
{% assign limit = 50 %}
{% for x in array limit:limit %} {{ x }}{% endfor %}
TEMPLATE

 100 101 102 103 104 105
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable limit: ');
{% for x in array limit: %} {{ x }}{% endfor %}
TEMPLATE
 100 101 102 103 104 105
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable offset:2');
{% for x in array offset:2 %} {{ x }}{% endfor %}
TEMPLATE
 102 103 104 105
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable offset:0');
{% for x in array offset:0 %} {{ x }}{% endfor %}
TEMPLATE
 100 101 102 103 104 105
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable offset:var [var == 50]');
{% assign var = 50 %}
{% for x in array offset:var %} {{ x }}{%endfor%}
TEMPLATE


EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable offset:var [var == 3]');
{% assign var = 3 %}
{% for x in array offset:var %} {{ x }}{%endfor%}
TEMPLATE

 103 104 105
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable offset:');
{% for x in array offset: %} {{ x }}{% endfor %}
TEMPLATE
 100 101 102 103 104 105
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable offset:2 limit:2');
{% for x in array offset:2 limit:2 %} {{ x }}{% endfor %}
TEMPLATE
 102 103
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable offset:200 limit:2');
{% for x in array offset:200 limit:2 %} {{ x }}{% endfor %}
TEMPLATE

EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable offset:2 limit:0');
{% for x in array offset:2 limit:0 %} {{ x }}{% endfor %}
TEMPLATE

EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable reversed');
{% for x in array reversed %} {{ x }}{% endfor %}
TEMPLATE
 105 104 103 102 101 100
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable reversed offset:2');
{% for x in array reversed offset:2 %} {{ x }}{% endfor %}
TEMPLATE
 102 103 104 105
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable reversed limit:2');
{% for x in array reversed limit:2 %} {{ x }}{% endfor %}
TEMPLATE
 100 101
EXPECTED
is( Solution::Template->parse(
        <<'TEMPLATE')->render({array => [100 .. 105]}), <<'EXPECTED', 'variable reversed offset:2 limit:2');
{% for x in array reversed offset:2 limit:2 %} {{ x }}{% endfor %}
TEMPLATE
 102 103
EXPECTED

# Test hashes
like(Solution::Template->parse(
           '{ {% for x in var %} {{ x.key }} => {{ x.value }},{% endfor %} }')
         ->render({var => {A => 1, B => 2, C => 3}}),
     qr[^{ (?: [ABC] => [123],){3} }$],
     'hash'
);
like(
    Solution::Template->parse(
        '{ {% for x in var reversed %} {{ x.key }} => {{ x.value }},{% endfor %} }'
        )->render({var => {A => 1, B => 2, C => 3}}),
    qr[^{ (?: [ABC] => [123],){3} }$],
    'hash reversed'
);
like(
    Solution::Template->parse(
        '{ {% for x in var offset:1 %} {{ x.key }} => {{ x.value }},{% endfor %} }'
        )->render({var => {A => 1, B => 2, C => 3}}),
    qr[^{ (?: [ABC] => [123],){2} }$],
    'hash offset:1'
);
like(
    Solution::Template->parse(
        '{ {% for x in var limit:1 %} {{ x.key }} => {{ x.value }},{% endfor %} }'
        )->render({var => {A => 1, B => 2, C => 3}}),
    qr[^{ (?: [ABC] => [123],) }$],
    'hash limit:1'
);

# check all the forloop vars
is( Solution::Template->parse(
                           '{% for x in var %}{{ forloop.type }}{% endfor %}')
        ->render({var => [1]}),
    'ARRAY',
    'forloop.type eq "ARRAY"'
);
is( Solution::Template->parse(
                           '{% for x in var %}{{ forloop.type }}{% endfor %}')
        ->render({var => {A => 1}}),
    'HASH',
    'forloop.type eq "HASH"'
);

# make sure the local variable overrides the higher scope
# I'm finished
done_testing();

# $Id: 02001_for.t e4dbc9a 2010-09-19 23:13:18Z sanko@cpan.org $
