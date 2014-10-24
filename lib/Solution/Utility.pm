package Solution::Utility;
{
    use strict;
    use warnings;
    our $MAJOR = 0.0; our $MINOR = 0; our $DEV = -3; our $VERSION = sprintf('%1d.%02d' . ($DEV ? (($DEV < 0 ? '' : '_') . '%02d') : ('')), $MAJOR, $MINOR, abs $DEV);
    our $FilterSeparator = qr[\s*\|\s*];
    my $ArgumentSeparator = qr[,];
    our $FilterArgumentSeparator    = qr[:];
    our $VariableAttributeSeparator = qr[\.];
    our $TagStart                   = qr[{%\s*];
    our $TagEnd                     = qr[\s*%}];
    our $VariableSignature          = qr[\(?[\w\-\.\[\]]\)?];
    my $VariableSegment = qr[[\w\-]\??]x;
    our $VariableStart = qr[{{\s*];
    our $VariableEnd   = qr[\s*}}];
    my $VariableIncompleteEnd = qr[}}?];
    my $QuotedString          = qr/"[^"]+"|'[^']+'/;
    my $QuotedFragment = qr/${QuotedString}|(?:[^\s,\|'"]|${QuotedString})+/;
    my $StrictQuotedFragment = qr/"[^"]+"|'[^']+'|[^\s,\|,\:,\,]+/;
    my $FirstFilterArgument
        = qr/${FilterArgumentSeparator}(?:${StrictQuotedFragment})/;
    my $OtherFilterArgument
        = qr/${ArgumentSeparator}(?:${StrictQuotedFragment})/;
    my $SpacelessFilter
        = qr/${FilterSeparator}(?:${StrictQuotedFragment})(?:${FirstFilterArgument}(?:${OtherFilterArgument})*)?/;
    our $Expression    = qr/(?:${QuotedFragment}(?:${SpacelessFilter})*)/;
    our $TagAttributes = qr[(\w+)(?:\s*\:\s*(${QuotedFragment}))?];
    my $AnyStartingTag = qr[\{\{|\{\%];
    my $PartialTemplateParser
        = qr[${TagStart}.*?${TagEnd}|${VariableStart}.*?${VariableIncompleteEnd}];
    my $TemplateParser = qr[(${PartialTemplateParser}|${AnyStartingTag})];
    our $VariableParser = qr[^
                            ${VariableStart}                        # {{
                                ([\w\.]+)    #   name
                                (?:\s*\|\s*(.+)\s*)?                 #   filters
                            ${VariableEnd}                          # }}
                            $]x;
    our $VariableFilterArgumentParser
        = qr[\s*,\s*(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))];

    sub tokenize {
        map { $_ ? $_ : () } split $TemplateParser, shift || '';
    }
}
1;

=pod

=head1 NAME

Solution::Utility - Utility stuff. Watch your step.

=head1 Description

It's best to just forget this package exists. It's messy but seems to work.

=head1 See Also

Liquid for Designers: http://wiki.github.com/tobi/liquid/liquid-for-designers

L<Solution|Solution/"Create your own filters">'s docs on custom filter creation

=head1 Author

Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

The original Liquid template system was developed by jadedPixel
(http://jadedpixel.com/) and Tobias Lütke (http://blog.leetsoft.com/).

=head1 License and Legal

Copyright (C) 2009 by Sanko Robinson E<lt>sanko@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify it under
the terms of The Artistic License 2.0.  See the F<LICENSE> file included with
this distribution or http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all original POD documentation is
covered by the Creative Commons Attribution-Share Alike 3.0 License.  See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.

=for git $Id: Utility.pm 76e9e91 2010-09-21 02:58:26Z sanko@cpan.org $

=cut
